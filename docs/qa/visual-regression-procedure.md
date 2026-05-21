# Visual Regression Procedure

Updated: 2026-05-21  
Owner: Phase H.7 UI QA

## Scope

Visual regression covers the Phase H responsive matrix:

- `360x640`
- `768x1024`
- `1024x768`
- `1280x800`
- `1600x900`
- `1920x1080`

Routes and ready checks are defined in `tool/qa/visual_regression.config.js`.
Baselines are stored in `docs/qa/visual-baselines/phase7/`; current captures
are written to `output/playwright/phase7/current/`.

## Local Baseline Refresh

1. Build release web assets.

```powershell
flutter build web --release
```

2. Serve the release build without cache.

```powershell
npx -y http-server build\web -p 54556 -a 127.0.0.1 -c-1
```

3. Refresh baselines after intentional UI changes.

```powershell
node tool\qa\phase7_acceptance_probe.js `
  --visual-only `
  --base-url http://127.0.0.1:54556 `
  --update-visual-baseline
```

4. Run the compare pass.

```powershell
node tool\qa\phase7_acceptance_probe.js `
  --visual-only `
  --base-url http://127.0.0.1:54556
```

Expected result: `PASS`, max decoded-pixel diff `<= 1%`.

## Review Rules

- Refresh baseline only after the UI change is intentional and focused.
- Inspect `docs/research/phase7-visual-regression-2026-05-21.md` before
  committing a baseline refresh.
- Keep `output/playwright/phase7/current/` out of git.
- Commit `tool/qa/visual_regression.config.js`, changed baseline PNGs under
  `docs/qa/visual-baselines/phase7/`, and this procedure together.
- Known console noise such as Firebase/App Check 403s is filtered by the probe;
  layout, render, or JavaScript errors are not ignored.

## Adding Routes

Add a route object to `visualRegressionPages`:

```js
{ name: 'route-name', route: '/#/path', ready: /Visible copy|Fallback copy/ }
```

Ready text must be learner-facing copy that appears after loading. Avoid
spinners, internal IDs, or transient animation labels.

