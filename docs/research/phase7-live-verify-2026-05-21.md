# Phase 7 Live Verify

Generated: `2026-05-21`

Base URL: `https://jpstudy.web.app`

Result: `PASS`

## Deployment

- `node tool\deploy\hosting_deploy.js` completed and released Firebase Hosting `jpstudy`.
- Build command uses `flutter build web --release --base-href=/ --wasm`.
- Live headers:
  - `/` -> `200`, `Cache-Control: no-store, must-revalidate, no-cache`
  - `/main.dart.wasm` -> `200`, `Content-Type: application/wasm`, `Cache-Control: no-cache`
  - `/main.dart.mjs` -> `200`, `Cache-Control: no-cache`
  - `/flutter_bootstrap.js` -> `200`, `Cache-Control: no-cache`
  - `/llms.txt` -> `200`, valid text file

## Learner Flow Proof

- Home rendered on production with overview widget labels visible for `Kế hoạch`, `Tiến độ`, and `Đang dở`; Phase 6 widget tests cover all 4 widgets including streak/`Chuỗi ngày`.
- Mobile viewport `360x640` rendered the app canvas without route failure.
- Random connected routes rendered:
  - `/#/lesson/1?level=N5`
  - `/#/vocab`
  - `/#/grammar/1`
  - `/#/kanji/%E6%B5%B7/graph`
  - `/#/jlpt/reading`
- Unexpected app/page errors during route proof: `0`.

## Telemetry / Safety

After deferred bootstrap on production, network proof observed:

- Wasm runtime: `main.dart.wasm` and `skwasm` requested.
- App Check monitoring path: reCAPTCHA + `content-firebaseappcheck.googleapis.com` exchange request observed.
- Anonymous Auth path: `identitytoolkit.googleapis.com` sign-up/lookup requests observed.
- Sentry path: Sentry browser SDK + ingest envelope request observed.
- GA4 path: `gtag/js` + `google-analytics.com/g/collect` page-view request observed.

App Check enforcement was not enabled by this run; only client activation/monitoring requests were observed.

## Phase 7 Gates

- Random sample E2E: `PASS`, `25/25`.
- Visual regression: `PASS` after resetting the baseline for the intentional JS -> Wasm renderer switch.
- Persona flows: `PASS`.
- Lighthouse: `PASS`.
  - Mobile: Performance `100`, Accessibility `100`, Best Practices `100`, SEO `100`.
  - Desktop: Performance `89`, Accessibility `100`, Best Practices `100`, SEO `100`.
