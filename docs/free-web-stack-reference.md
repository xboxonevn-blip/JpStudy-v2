# Free Web Stack Reference

Last verified: 2026-05-19.

Purpose: keep a durable reference for future Codex sessions when making hosting,
backend, content-source, or cost-control decisions for JpStudy.

## Current Project Posture

- JpStudy is a local-first Flutter app. Study progress, FSRS review state, and
  content access should stay local by default.
- The production web app is built from `build/web` and is currently configured
  for Firebase Hosting through `firebase.json`.
- Public content is bundled as JSON assets under `assets/data/content/`.
- Current measured build shape:
  - `build/web`: about 68.8 MB raw.
  - `assets/data`: about 24.3 MB JSON.
  - `docs/research/D7-performance/web_perf_budget.json` caps total build raw
    bytes at 72 MB and JSON raw bytes at 28 MB.
- Cloud backup is intentionally off by default:
  `JPSTUDY_ENABLE_CLOUD_BACKUP=false`.
- Firebase Storage rules only allow authenticated owners to access
  `users/{uid}/backup.json` and `users/{uid}/legacy_migration.json`; all other
  Storage paths are denied.

## Recommended Free-Tier Architecture

Use this order unless the product constraints change:

1. Host the static Flutter web build on Cloudflare Pages.
2. Keep Firebase Auth for identity.
3. Keep Firebase Analytics only after consent and Do Not Track checks.
4. Keep Firebase App Check for Firebase-backed surfaces.
5. Keep cloud backup disabled until there is a deliberate sync release.
6. Keep progress and curriculum data local-first; prefer file export/import over
   always-on cloud writes.

This gives the app normal web availability without introducing server compute,
paid database reads, or per-request backend costs.

## Hosting Choices

### Cloudflare Pages

Best default for public web traffic.

- Good fit for a static Flutter build.
- Official limits include 20,000 files per project and 25 MiB per file. The
  current build is below those limits.
- Move the Firebase Hosting headers into Cloudflare `_headers` if switching.
- Keep SPA fallback equivalent to Firebase's rewrite to `/index.html`.

### Firebase Hosting Spark

Useful as the Firebase-native deployment path, but risky as the only public
host once traffic grows.

- The repo already targets `build/web` in `firebase.json`.
- Spark transfer is small enough that a roughly 69 MB Flutter build can burn
  quota quickly with new visitors, cache misses, or redeploys.
- Keep it as a beta/mirror host unless quota proves sufficient.

### GitHub Pages / Netlify / Vercel

Acceptable fallback options for static hosting.

- GitHub Pages is simple but less flexible for headers and SPA deployment
  details.
- Netlify and Vercel are convenient, but plan quotas and commercial-use limits
  should be checked before relying on them for production.

## Immediate Cost-Control Tasks

- Cache static content more aggressively when content is versioned. The current
  Firebase config sets `assets/assets/data/content/**` to `no-cache`; that is
  safe for freshness but inefficient for repeated visits.
- Lazy-load Firebase web SDK modules. `web/preload.js` currently imports
  `firebase-storage.js` and `firebase-analytics.js` before Flutter boots.
  Prefer loading Storage only when cloud backup is enabled or opened, and
  Analytics only after consent.
- Keep `flutter_service_worker.js` unregister-only unless a deliberate offline
  caching strategy is designed. Avoid precaching the entire content library on
  first visit.
- Do not add Firestore, Functions, paid SQL, hosted search, or always-on custom
  APIs until a feature needs server-side trust or shared state.
- If a custom API becomes necessary, put it behind auth, rate limits, and App
  Check-like abuse controls.

## Firebase Boundaries

Keep:

- Firebase Auth for email/password and Google identity.
- Firebase Analytics for consented product telemetry.
- Firebase App Check for Firebase-protected resources.
- Firebase Storage scaffolding for a future opt-in encrypted backup release.

Avoid for now:

- Firestore for per-interaction study state.
- Cloud Functions as a default app backend.
- Public anonymous Storage writes.
- Cloud backup on Spark.

Security reminders:

- Keep web Firebase API keys restricted by HTTP referrer.
- Keep production Auth authorized domains narrow.
- Keep Storage writes capped at 5 MiB JSON and owner-only paths.
- Do not deploy all hosting targets accidentally; deploy the intended target.

## Redistribution-Safe Content Sources

Prefer sources with explicit redistribution terms:

- JMdict / KANJIDIC2 from EDRDG for dictionary and kanji facts.
- KanjiVG for stroke order vectors. Current repo attribution says CC BY-SA 3.0.
- Unicode Unihan for Unicode metadata and Vietnamese Sino-Xenic readings.
- Tatoeba sentences only with attribution and quality filtering.
- Aozora Bunko public-domain prose only after confirming the individual work is
  out of copyright and suitable for app use.
- Google Fonts / Noto families only under their published font licenses.

Use only as references unless permission/license is clear:

- Official JLPT sample/workbook PDFs.
- NHK News Easy and public reading-practice pages.
- Vietnamese grammar websites and online dictionaries.
- Owner-provided Google Drive study material.

Do not use:

- Unclear-license JLPT vocabulary, kanji, or grammar list pages as bulk-import
  sources.
- Any source explicitly excluded by the owner, including `nhaikanji.com`.

Important content policy already exists in:

- `docs/third_party_kanjivg.md`
- `docs/credits/upper-jlpt-sources.md`
- `docs/research/D2-content/kanji-expansion-source-policy-2026-05-18.md`

## Source Links Checked

- Firebase pricing: https://firebase.google.com/pricing
- Cloudflare Pages limits: https://developers.cloudflare.com/pages/platform/limits/
- GitHub Pages limits: https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits
- EDRDG license: https://www.edrdg.org/edrdg/licence.html
- KanjiVG: https://github.com/KanjiVG/kanjivg
- Tatoeba downloads: https://tatoeba.org/en/downloads
- Unicode terms: https://www.unicode.org/terms_of_use.html
- JLPT FAQ: https://www.jlpt.jp/e/faq/
