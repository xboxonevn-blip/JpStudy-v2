const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const repoRoot = path.resolve(__dirname, '../../..');

test('Firebase preload includes the App Check web SDK module', () => {
  const preload = fs.readFileSync(
    path.join(repoRoot, 'web', 'preload.js'),
    'utf8',
  );

  assert.match(preload, /firebase-app-check\.js/);
  assert.match(preload, /firebaseAppCheck/);
  assert.match(preload, /window\.firebase_app_check\s*=\s*firebaseAppCheck/);
});

test('preload seeds Phase 7 Lighthouse prefs before Flutter bootstrap', () => {
  const preload = fs.readFileSync(
    path.join(repoRoot, 'web', 'preload.js'),
    'utf8',
  );

  assert.match(preload, /jpstudy_qa/);
  assert.match(preload, /phase7_lighthouse/);
  assert.match(preload, /flutter\.onboarding\.completed/);
  assert.match(preload, /scheduleFirebaseSdkPreload/);
  assert.match(preload, /setTimeout\(run, 30000\)/);
  assert.ok(
    preload.indexOf('loadFlutterBootstrap();') <
      preload.indexOf('scheduleFirebaseSdkPreload();'),
    'Flutter bootstrap should not wait for Firebase SDK preload',
  );
});

test('Firebase Hosting CSP allows reCAPTCHA scripts for App Check', () => {
  const firebaseConfig = fs.readFileSync(
    path.join(repoRoot, 'firebase.json'),
    'utf8',
  );

  assert.match(firebaseConfig, /script-src[^;"]*https:\/\/www\.google\.com/);
  assert.match(firebaseConfig, /connect-src[^;"]*https:\/\/www\.google\.com/);
  assert.match(firebaseConfig, /frame-src[^;"]*https:\/\/www\.google\.com/);
});

test('Firebase Hosting CSP allows the Sentry web SDK CDN', () => {
  const firebaseConfig = fs.readFileSync(
    path.join(repoRoot, 'firebase.json'),
    'utf8',
  );

  assert.match(
    firebaseConfig,
    /script-src[^;"]*https:\/\/browser\.sentry-cdn\.com/,
  );
  assert.match(firebaseConfig, /connect-src[^;"]*https:\/\/\*\.sentry\.io/);
});

test('hosting deploy helper requires App Check key and injects deploy dart-defines', () => {
  const scriptPath = path.join(repoRoot, 'tool', 'deploy', 'hosting_deploy.js');
  assert.equal(
    fs.existsSync(scriptPath),
    true,
    'tool/deploy/hosting_deploy.js should exist',
  );

  const { buildPlan } = require(scriptPath);

  assert.throws(
    () => buildPlan({ env: {} }),
    /JPSTUDY_RECAPTCHA_SITE_KEY/,
  );

  const plan = buildPlan({
    env: {
      JPSTUDY_RECAPTCHA_SITE_KEY: 'site-key',
      JPSTUDY_SENTRY_DSN: 'dsn',
      JPSTUDY_SENTRY_ENVIRONMENT: 'production',
      JPSTUDY_RELEASE: 'release-123',
      JPSTUDY_SENTRY_SMOKE_EVENT: 'false',
    },
  });

  assert.equal(plan.build.command, 'flutter');
  assert.deepEqual(plan.build.args, [
    'build',
    'web',
    '--release',
    '--base-href=/',
    '--wasm',
    '--dart-define=JPSTUDY_RECAPTCHA_SITE_KEY=site-key',
    '--dart-define=JPSTUDY_SENTRY_DSN=dsn',
    '--dart-define=JPSTUDY_SENTRY_ENVIRONMENT=production',
    '--dart-define=JPSTUDY_RELEASE=release-123',
    '--dart-define=JPSTUDY_SENTRY_SMOKE_EVENT=false',
  ]);
  assert.equal(plan.deploy.command, 'firebase');
  assert.deepEqual(plan.deploy.args, [
    'deploy',
    '--only',
    'hosting:jpstudy',
  ]);
});

test('hosting deploy helper redacts Firebase token from logged deploy args', () => {
  const scriptPath = path.join(repoRoot, 'tool', 'deploy', 'hosting_deploy.js');
  const { buildPlan, deployArgsForEnv, redactArgs } = require(scriptPath);
  assert.equal(typeof redactArgs, 'function');

  const plan = buildPlan({
    env: {
      JPSTUDY_RECAPTCHA_SITE_KEY: 'site-key',
    },
  });
  const args = deployArgsForEnv(plan, {
    FIREBASE_PROJECT: 'jpstudy-v2',
    FIREBASE_TOKEN: 'firebase-secret-token',
  });
  const redacted = redactArgs(args);

  assert.deepEqual(redacted, [
    'deploy',
    '--only',
    'hosting:jpstudy',
    '--project',
    'jpstudy-v2',
    '--token',
    '<redacted>',
    '--non-interactive',
  ]);
  assert.equal(redacted.includes('firebase-secret-token'), false);
});

test('hosting deploy helper avoids shell args for deploy commands', () => {
  const scriptPath = path.join(repoRoot, 'tool', 'deploy', 'hosting_deploy.js');
  const { buildPlan, deployArgsForEnv, resolveInvocation } = require(scriptPath);
  assert.equal(typeof resolveInvocation, 'function');

  const plan = buildPlan({
    env: {
      JPSTUDY_RECAPTCHA_SITE_KEY: 'site-key',
    },
  });
  const build = resolveInvocation(plan.build);
  const deploy = resolveInvocation(
    plan.deploy,
    deployArgsForEnv(plan, { FIREBASE_PROJECT: 'jpstudy-v2' }),
  );

  assert.equal(build.options.shell, false);
  assert.equal(deploy.options.shell, false);
  assert.ok(build.command.length > 0);
  assert.ok(deploy.command.length > 0);
  assert.ok(deploy.args.includes('deploy'));
});

test('main warns instead of silently skipping missing web App Check key', () => {
  const source = fs.readFileSync(path.join(repoRoot, 'lib', 'main.dart'), 'utf8');

  assert.match(source, /App Check disabled: JPSTUDY_RECAPTCHA_SITE_KEY/);
  assert.match(source, /Firebase App Check activation failed:/);
  assert.doesNotMatch(source, /if \(siteKey\.isEmpty\) return;/);
});

test('main renders app before deferred Firebase and App Check bootstrap', () => {
  const source = fs.readFileSync(path.join(repoRoot, 'lib', 'main.dart'), 'utf8');

  assert.match(source, /_scheduleDeferredBootstrap\(container, preferences\)/);
  assert.match(source, /addPostFrameCallback/);
  assert.match(source, /Duration\(seconds: 45\)/);
  assert.ok(
    source.indexOf('runApp(') < source.indexOf('_runDeferredBootstrap'),
    'runApp should be reachable before deferred cloud bootstrap starts',
  );
});
