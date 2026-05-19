const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const { buildPlan } = require('../../../tool/deploy/hosting_deploy.js');

const workflow = fs.readFileSync('.github/workflows/ui-string-guard.yml', 'utf8');

test('CI workflow exposes a manual Sentry smoke trigger', () => {
  assert.match(workflow, /workflow_dispatch:\s*\n\s*inputs:\s*\n\s*sentry_smoke:/);
  assert.match(workflow, /JPSTUDY_SENTRY_SMOKE_EVENT/);
  assert.match(workflow, /node tool\/deploy\/hosting_deploy\.js/);
  assert.ok(
    buildPlan({
      env: {
        JPSTUDY_RECAPTCHA_SITE_KEY: 'site-key',
        JPSTUDY_SENTRY_SMOKE_EVENT: 'true',
      },
    }).build.args.includes('--dart-define=JPSTUDY_SENTRY_SMOKE_EVENT=true'),
  );
  assert.match(workflow, /name: Trigger Sentry smoke event/);
  assert.match(workflow, /sentry-smoke=1/);
});

test('CI workflow keeps live Lighthouse performance gate lenient', () => {
  assert.match(
    workflow,
    /artifact and\s*\n\s*\/\/ resource-smoke budgets are the deterministic performance gates\./,
  );
  assert.match(workflow, /performance: 0\.20,/);
});

test('CI workflow publishes launch readiness blockers with proof-state', () => {
  assert.match(workflow, /name: Report launch readiness blockers/);
  assert.match(
    workflow,
    /npm run report:launch-readiness -- --out \/tmp\/jpstudy-launch-readiness\.md --proof-state docs\/compliance\/launch-proof-state\.json/,
  );
  assert.match(workflow, /cat \/tmp\/jpstudy-launch-readiness\.md >> "\$\{GITHUB_STEP_SUMMARY\}"/);
});
