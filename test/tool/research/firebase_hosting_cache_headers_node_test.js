const assert = require('node:assert/strict');
const fs = require('node:fs');
const test = require('node:test');

function loadHostingHeaders() {
  const firebaseJson = JSON.parse(fs.readFileSync('firebase.json', 'utf8'));
  return firebaseJson.hosting[0].headers;
}

function cacheControlFor(source) {
  const entry = loadHostingHeaders().find((item) => item.source === source);
  assert.ok(entry, `missing hosting header entry for ${source}`);
  const header = entry.headers.find(
    (item) => item.key.toLowerCase() === 'cache-control',
  );
  assert.ok(header, `missing Cache-Control for ${source}`);
  return header.value;
}

test('Flutter web shell and content assets revalidate while stable runtime files use bounded cache', () => {
  for (const source of [
    'index.html',
    '/',
    'flutter_service_worker.js',
    'version.json',
  ]) {
    assert.equal(
      cacheControlFor(source),
      'no-cache, no-store, must-revalidate',
    );
  }

  for (const source of [
    'main.dart.js',
    'main.dart.mjs',
    'main.dart.wasm',
    'flutter_bootstrap.js',
    'flutter.js',
    'assets/assets/data/content/**',
    'assets/AssetManifest*',
  ]) {
    assert.equal(cacheControlFor(source), 'no-cache');
  }

  for (const source of ['sqlite3.wasm', 'drift_worker.js']) {
    assert.equal(cacheControlFor(source), 'public, max-age=2592000');
  }
});
