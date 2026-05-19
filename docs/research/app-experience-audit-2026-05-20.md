# App Experience Audit - 2026-05-20

Directive D audit log. This file is the running whole-app experience audit:
each live pass must inspect the whole visible screen, every CTA on that screen,
empty/error states, copy, internal labels, layout balance, and connected flows.
Every defect found here must have a ticket in `docs/research/quality-backlog.md`.

## Scope Status

| Area | Status | Evidence |
| --- | --- | --- |
| Home / App Check boot | Audited slice | Fresh VI/N4 home rendered and App Check network path activated. |
| Grammar N2 direct detail | Audited slice | Fresh direct `/#/grammar/1` rendered examples and practice gate. |
| Grammar N4 direct detail | Audited slice | Fresh direct `/#/grammar/81` rendered examples and practice gate. |
| Grammar N4 catalog search | Audited slice | Search `ところです` returned a row instead of empty state. |
| Full app sweep | Pending | Continue after the current dirty batch commit: Home, Học, Từ vựng, Kanji, Kana/Foundation, Hán-Việt, Review, Exams, Profile, Search, and all connected CTAs. |

## Defects Logged

| Ticket | Area | Finding | Status |
| --- | --- | --- | --- |
| QA-A-018 | App Check | Deployable web builds could miss App Check activation. | Fixed + deployed |
| QA-A-019 | Grammar examples | Upper-level grammar examples could be blank because the flat object schema was not decoded. | Fixed + deployed |
| QA-A-020 | Sentry | Sentry CDN was not allowed by Hosting CSP. | Fixed + deployed |
| QA-A-021 | Grammar direct links | Direct grammar detail could load before active-level seed and stay loading/not-found. | Fixed + deployed |
| QA-B-001-G-N4-L46-L50 | Grammar content | N4 lessons 46-50 needed source verification plus full detail/example/practice proof. | Fixed + deployed |

## Live Proof Artifacts

- `output/playwright/live-appcheck-home-proof.png`
- `output/playwright/live-n2-direct-detail-fixed-detail-top.png`
- `output/playwright/live-n2-direct-detail-fixed-detail-examples.png`
- `output/playwright/live-n2-direct-detail-fixed-practice-gate.png`
- `output/playwright/live-n4-direct-detail-fixed-detail-top.png`
- `output/playwright/live-n4-direct-detail-fixed-detail-examples.png`
- `output/playwright/live-n4-direct-detail-fixed-practice-gate.png`
- `output/playwright/live-n4-search-tokoro-fixed.png`

## Notes For Next Sweep

- Continue with full app audit before resuming feature queue work.
- Pay special attention to self-attestation buttons in Kana/Foundation and any
  "Đã học/Tôi đã thuộc" action that does not require practice.
- Re-audit Hán-Việt from the Kanji learning flow, not only from the standalone
  rule list.
- Re-audit `Kế hoạch hôm nay` and other dashboard cards for layout balance,
  untranslated copy, internal labels, and CTA destinations.
