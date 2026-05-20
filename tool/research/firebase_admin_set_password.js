#!/usr/bin/env node
'use strict';

/**
 * Rotate a Firebase Auth user's password via the Admin SDK (keeps the same UID).
 *
 * Why this exists: the Firebase Console cannot set a password directly for an
 * email/password user - it only sends a reset email - and `admin@jpstudy.test`
 * uses the reserved `.test` TLD, so reset emails are undeliverable. This tool
 * calls `updateUser` instead. The UID is preserved, so test data and the
 * deletion-runbook proof tied to that UID stay valid.
 *
 * Credentials: uses Application Default Credentials (ADC). The permanent
 * GOOGLE_APPLICATION_CREDENTIALS variable points at the BigQuery-only
 * `ga4-data-reader` service account, which CANNOT manage Firebase Auth. This
 * script therefore drops that variable for its own process so ADC falls
 * through to gcloud user credentials. Run once, signed in as the project
 * owner (chung.phukiengiabuon@gmail.com):
 *
 *   gcloud auth application-default login
 *
 * The new password is typed into a hidden prompt - it is never passed as a
 * CLI argument, never echoed to the terminal, and never logged.
 *
 * Usage:
 *   node tool/research/firebase_admin_set_password.js                   # dry-run
 *   node tool/research/firebase_admin_set_password.js --execute          # rotate
 *   node tool/research/firebase_admin_set_password.js --uid <uid> --execute
 */

const DEFAULT_PROJECT = 'jpstudy-v2';
const DEFAULT_EMAIL = 'admin@jpstudy.test';
const MIN_PASSWORD_LENGTH = 8;

function parseArgs(argv) {
  const args = {
    project: DEFAULT_PROJECT,
    email: DEFAULT_EMAIL,
    uid: null,
    execute: false,
    help: false,
  };
  for (let i = 0; i < argv.length; i += 1) {
    const item = argv[i];
    if (item === '--email') args.email = argv[(i += 1)];
    else if (item === '--uid') {
      args.uid = argv[(i += 1)];
      args.email = null;
    } else if (item === '--project') args.project = argv[(i += 1)];
    else if (item === '--execute') args.execute = true;
    else if (item === '--help' || item === '-h') args.help = true;
    else throw new Error(`Unknown argument: ${item}`);
  }
  return args;
}

function printHelp() {
  console.log(
    [
      'Rotate a Firebase Auth user password (Admin SDK, keeps the same UID).',
      '',
      'Usage:',
      '  node tool/research/firebase_admin_set_password.js ' +
        '[--email <email> | --uid <uid>] [--project <id>] [--execute]',
      '',
      `Defaults: --email ${DEFAULT_EMAIL}  --project ${DEFAULT_PROJECT}`,
      'Without --execute the script runs a dry-run: it verifies credentials',
      'and the target user but changes nothing.',
      '',
      'Prerequisite (run once, signed in as the project owner):',
      '  gcloud auth application-default login',
    ].join('\n'),
  );
}

/**
 * Read one line from stdin without echoing it (raw mode, for password entry).
 * Control characters are built with String.fromCharCode so the source stays
 * plain printable ASCII. Handles Enter, Backspace, Ctrl+C and Ctrl+D.
 */
function readSecret(promptText) {
  return new Promise((resolve) => {
    const { stdin, stdout } = process;
    const ENTER_LF = String.fromCharCode(10);
    const ENTER_CR = String.fromCharCode(13);
    const CTRL_C = String.fromCharCode(3);
    const CTRL_D = String.fromCharCode(4);
    const BACKSPACE = String.fromCharCode(127);
    const BACKSPACE_ALT = String.fromCharCode(8);
    const FIRST_PRINTABLE = String.fromCharCode(32);

    stdout.write(promptText);
    const wasRaw = Boolean(stdin.isRaw);
    if (stdin.isTTY) stdin.setRawMode(true);
    stdin.resume();

    let value = '';
    const finish = (result, exitCode) => {
      if (stdin.isTTY) stdin.setRawMode(wasRaw);
      stdin.pause();
      stdin.removeListener('data', onData);
      stdout.write(ENTER_LF);
      if (typeof exitCode === 'number') process.exit(exitCode);
      else resolve(result);
    };
    const onData = (buf) => {
      for (const ch of buf.toString('utf8')) {
        if (ch === ENTER_LF || ch === ENTER_CR || ch === CTRL_D) {
          return finish(value);
        }
        if (ch === CTRL_C) return finish(null, 130);
        if (ch === BACKSPACE || ch === BACKSPACE_ALT) {
          value = value.slice(0, -1);
        } else if (ch >= FIRST_PRINTABLE) {
          value += ch;
        }
      }
    };
    stdin.on('data', onData);
  });
}

function validatePassword(password, confirmation) {
  if (password !== confirmation) return 'Passwords do not match.';
  if (password.length < MIN_PASSWORD_LENGTH) {
    return `Password must be at least ${MIN_PASSWORD_LENGTH} characters.`;
  }
  if (/^\s|\s$/.test(password)) {
    return 'Password must not start or end with whitespace.';
  }
  return null;
}

function loadAuth(project) {
  // Drop the BigQuery-only service-account key so ADC resolves to gcloud
  // user credentials (`gcloud auth application-default login`).
  if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    delete process.env.GOOGLE_APPLICATION_CREDENTIALS;
  }
  const { getApps, initializeApp, applicationDefault } = require('firebase-admin/app');
  const { getAuth } = require('firebase-admin/auth');
  if (getApps().length === 0) {
    initializeApp({ projectId: project, credential: applicationDefault() });
  }
  return getAuth();
}

async function resolveUser(auth, { uid, email }) {
  return uid ? auth.getUser(uid) : auth.getUserByEmail(email);
}

async function main(argv = process.argv.slice(2)) {
  const args = parseArgs(argv);
  if (args.help) {
    printHelp();
    return;
  }

  const auth = loadAuth(args.project);

  let user;
  try {
    user = await resolveUser(auth, args);
  } catch (error) {
    throw new Error(
      `Could not load the target user (${args.uid || args.email}) in project ` +
        `${args.project}: ${error.message}. ` +
        'If this is an auth/permission error, run ' +
        '`gcloud auth application-default login` as the project owner first.',
    );
  }

  console.log('Target user:');
  console.log(`  project : ${args.project}`);
  console.log(`  email   : ${user.email || '(none)'}`);
  console.log(`  uid     : ${user.uid}`);
  console.log(`  disabled: ${user.disabled}`);

  if (!args.execute) {
    console.log('');
    console.log('Dry-run OK - credentials and target user verified.');
    console.log('Re-run with --execute to rotate the password.');
    return;
  }

  console.log('');
  console.log('--execute: enter a new password below. Press Ctrl+C to abort.');
  const password = await readSecret('New password: ');
  const confirmation = await readSecret('Confirm new password: ');
  const problem = validatePassword(password, confirmation);
  if (problem) throw new Error(problem);

  await auth.updateUser(user.uid, { password });
  console.log('');
  console.log(`Password rotated for ${user.email || user.uid}.`);
  console.log(`UID is unchanged: ${user.uid}`);
}

if (require.main === module) {
  main().catch((error) => {
    console.error(`ERROR: ${error.message}`);
    process.exit(1);
  });
}

module.exports = { parseArgs, validatePassword };
