#!/usr/bin/env node
'use strict';

const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '../..');

function requireEnv(env, name) {
  const value = `${env[name] ?? ''}`.trim();
  if (!value) {
    throw new Error(
      `${name} is required for production Hosting deploy. ` +
        `Set it before building deployable web artifacts.`,
    );
  }
  return value;
}

function addDartDefine(args, name, value) {
  const normalized = `${value ?? ''}`.trim();
  if (normalized) {
    args.push(`--dart-define=${name}=${normalized}`);
  }
}

function buildPlan({ env = process.env } = {}) {
  const siteKey = requireEnv(env, 'JPSTUDY_RECAPTCHA_SITE_KEY');
  const buildArgs = [
    'build',
    'web',
    '--release',
    '--base-href=/',
    '--wasm',
    `--dart-define=JPSTUDY_RECAPTCHA_SITE_KEY=${siteKey}`,
  ];

  addDartDefine(buildArgs, 'JPSTUDY_SENTRY_DSN', env.JPSTUDY_SENTRY_DSN);
  addDartDefine(
    buildArgs,
    'JPSTUDY_SENTRY_ENVIRONMENT',
    env.JPSTUDY_SENTRY_ENVIRONMENT,
  );
  addDartDefine(
    buildArgs,
    'JPSTUDY_RELEASE',
    env.JPSTUDY_RELEASE || `${env.GITHUB_SHA ?? ''}`.slice(0, 12),
  );
  addDartDefine(
    buildArgs,
    'JPSTUDY_SENTRY_SMOKE_EVENT',
    env.JPSTUDY_SENTRY_SMOKE_EVENT,
  );

  return {
    build: {
      command: 'flutter',
      args: buildArgs,
    },
    deploy: {
      command: 'firebase',
      args: ['deploy', '--only', 'hosting:jpstudy'],
    },
  };
}

function resolveCommand(command) {
  const extension = process.platform === 'win32' ? '.cmd' : '';
  const local = path.join(repoRoot, 'node_modules', '.bin', `${command}${extension}`);
  return fs.existsSync(local) ? local : command;
}

function resolveInvocation(step, args = step.args) {
  if (process.platform === 'win32') {
    if (step.command === 'firebase') {
      const firebaseJs = path.join(
        repoRoot,
        'node_modules',
        'firebase-tools',
        'lib',
        'bin',
        'firebase.js',
      );
      if (fs.existsSync(firebaseJs)) {
        return {
          command: process.execPath,
          args: [firebaseJs, ...args],
          options: { shell: false },
        };
      }
    }

    if (step.command === 'flutter') {
      return {
        command: 'cmd.exe',
        args: ['/d', '/s', '/c', 'flutter', ...args],
        options: { shell: false },
      };
    }
  }

  return {
    command: resolveCommand(step.command),
    args,
    options: { shell: false },
  };
}

function redactArgs(args) {
  return args.map((arg, index) => {
    if (args[index - 1] === '--token') return '<redacted>';
    if (arg.startsWith('--token=')) return '--token=<redacted>';
    const match = arg.match(/^--dart-define=([^=]+)=/);
    if (match) return `--dart-define=${match[1]}=<redacted>`;
    return arg;
  });
}

function runStep(step, args = step.args) {
  console.log(`$ ${step.command} ${redactArgs(args).join(' ')}`);
  const invocation = resolveInvocation(step, args);
  const result = spawnSync(invocation.command, invocation.args, {
    cwd: repoRoot,
    env: process.env,
    shell: invocation.options.shell,
    stdio: 'inherit',
  });

  if (result.error) {
    throw result.error;
  }
  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}

function deployArgsForEnv(plan, env = process.env) {
  const args = [...plan.deploy.args, '--project', env.FIREBASE_PROJECT || 'jpstudy-v2'];
  const token = `${env.FIREBASE_TOKEN ?? ''}`.trim();
  if (token) {
    args.push('--token', token);
  }
  args.push('--non-interactive');
  return args;
}

if (require.main === module) {
  let plan;
  try {
    plan = buildPlan();
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }

  runStep(plan.build);
  runStep(plan.deploy, deployArgsForEnv(plan));
}

module.exports = { buildPlan, deployArgsForEnv, redactArgs, resolveInvocation };
