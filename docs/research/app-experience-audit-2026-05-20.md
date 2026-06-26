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
| Kana detail sheet | Audited slice | Static + widget audit found self-attestation button; replaced with Kana quiz gate; live proof opened the quiz from the sheet. |
| Mistakes / JLPT support / Weakness Radar copy | Audited slice | Static audit found internal 1-3-7 labels leaking as `D1/D3/D7`; replaced with learner-facing day labels; live bundle scan found no `D1 `/`D3 `/`D7 ` leaks. |
| Foundations hub / Kana detail copy | Audited slice | Live route-matrix text + widget audit found `Open`, `yoon`, `rules`, `strokes`, and `clear` leaking; localized/removed; live proof verified hub/grid/sheet/quiz. |
| Vocab detail conjugation panel | Audited slice | Live VI/N5 proof opened `帰る`, verified examples plus sourced `帰って`/`帰らない` forms, clicked `Luyện chia thể`, reached a scoped 1-item hub, answered practice, and verified noun `学生` hides conjugation UI. |
| Search result card | Audited slice | Live VI/N5 search `かえる` returned `国へ帰るの`; QA-A-026 fixed the top-hit click so it opens the detail screen. |
| Grammar detail connected conjugation | Audited slice | Fresh VI/N4 direct detail `/#/grammar/81` rendered examples and the related-conjugation CTA; Directive D live proof caught missing `Verb-て` detection, fixed it, then verified `Luyện chia thể liên quan` opened a non-empty form drill. |
| Kanji detail connected conjugation | Audited slice | Fresh VI/N4 Kanji grid opened `飼`; detail showed example words and a sourced `Luyện chia thể` CTA; CTA opened a scoped `1 mục có nguồn sẵn sàng` hub and then a non-empty conjugation question. |
| Practice Board conjugation due queue | Audited slice | A wrong conjugation answer created a due SRS card; after the due interval, Practice Board showed `Ôn chia thể đến hạn`, Daily Plan showed `Ôn chia thể đến hạn`, and `Mở chia thể` opened due-scoped `Câu 1/1` instead of a full-level fallback. |
| Conjugation DB metadata | Audited slice | Live proof confirmed deployed `main.dart.js` contains `conjugation_lemma` + indexes and `lemmas.json` is `200/no-cache` with `3907` JMdict_e rows. |
| Conjugation SRS / Mistakes | Audited slice | Live proof confirmed deployed `main.dart.js` contains `conjugation_srs_state`, `idx_conjugation_srs_due`, `idx_conjugation_srs_skill`, and Mistakes rendered the empty state cleanly; Home nav CTA returned to dashboard. |
| Conjugation hub / practice | Audited slice | Live VI/N5 proof opened `/#/grammar/conjugation`, saw `398 mục có nguồn sẵn sàng`, clicked `Luyện chia thể`, selected an answer, confirmed, and saw `Đúng` + `Câu tiếp`; console app errors were `0`. |
| Onboarding language | Audited slice | Fresh live browser at 1366x768 selected `Tiếng Việt`, clicked Continue to level, selected N5, clicked Start, and reached VI/N5 home; QA-A-025 fixed the consent banner overlap. |
| Lesson vocab flashcards / ghost grammar / lesson grammar / Practice copy | Audited slice | Static + live sweep found manual `Learned` and `Mark as Mastered` controls that updated progress without a learner gate, broken `v? d?` grammar example count copy, and machine-like Vietnamese copy. QA-A-027 removed the self-attestation controls, records ghost answers through grammar SRS, normalized learner-facing copy, deployed, and live proof confirmed the lesson/practice screens plus clean fresh CSP. |
| P0 backlog live proof sweep | Audited slice | Rechecked old fixed-local P0 tickets after the latest deploy: QA-A-001 now routes `/#/exam-center` -> sidebar `Hồ sơ` -> `#/me` with the profile screen, and QA-A-004 now renders VI/N2 lesson 1 as `N2 / Shin Kanzen N2 Bài 1` with loaded Vocab and non-empty Grammar. |
| Home/Library Vietnamese copy | Audited slice | Static + live copy sweep found `dọn review`, `dọn hàng đợi`, `TÍN HIỆU LEVEL`, and mixed English `level`/`lesson` in Vietnamese Home/Library flows. QA-A-028 replaced them with natural Vietnamese; live VI/N2 Home/Summary/Library proof passed after deploy. |
| Vocab direct route | Audited slice | Fresh VI/N5 `/#/vocab` showed a spinner after 25 seconds with no app exception. QA-A-029 now renders the hub from bundled manifests/counts and decouples first paint from review-home DB loading; live proof shows the hub plus working `Ôn ngay` and `Minna no Nihongo I` CTAs. |
| Grammar/Kanji direct routes | Audited slice | While root-causing QA-A-029, fresh VI/N5 `/#/grammar` and `/#/kanji` also stayed in loading states after 25-45 seconds with no app exception. QA-A-030 added bounded loading panels for Grammar/Kanji DB-backed work, then live proof verified direct routes plus Grammar practice/detail and Kanji writing/Hán-Việt CTAs. |
| P1 backlog live proof sweep | Audited slice | Rechecked old fixed-local P1 rows after the latest deploy: QA-A-002 Vocab copy/badges are learner-facing, QA-A-003 Review copy is natural and CTAs open target content, and QA-A-005 VI/N2 Home/Review no longer leaks `Minna No Nihongo 200001`. |
| Grammar practice gate N5-N1 | Audited slice | QA-A-008 closeout live proof opened Grammar hub -> first detail -> examples -> `Luyện tập để hiểu` for VI N5/N4/N3/N2/N1; every level reached `Câu 1/5`, no empty due state, and no manual learned/self-attestation copy. |
| Grammar transformation question quality | Audited slice | QA-A-008 live proof exposed punctuation-only duplicate options in generated transformation drills; QA-A-031 dedupes transformation choices by sentence shape and live proof confirms rendered option keys are unique. |
| QA-A-030 vocab canonical cleanup | Audited slice | After the current dirty-batch gates were green, resumed Minna app-diff cleanup from owner-provided local canonical sources only. Batches 013-067 applied two hundred eighty-five curated N5/N4 repairs and skipped default candidates that would narrow learner nuance. Latest text-hygiene batch covered lesson-28 `娘`, `自分`, `それに`, `ちょっとお願いがあるんですが`, `日にち`, `土`, and `体育館`, replacing stale templates and a hidden broken connector example with learner-facing contexts. |
| Full app sweep | Pending | Continue after the current dirty batch commit: Home, Học, Từ vựng, Kanji, Kana/Foundation, Hán-Việt, Review, Exams, Profile, Search, and all connected CTAs. |

## Defects Logged

| Ticket | Area | Finding | Status |
| --- | --- | --- | --- |
| QA-A-018 | App Check | Deployable web builds could miss App Check activation. | Fixed + deployed |
| QA-A-001 | Shell navigation | After visiting `/#/exam-center`, clicking sidebar `Hồ sơ` could route to the wrong branch. | Fixed + deployed |
| QA-A-004 | Lesson title | Upper-JLPT lesson detail could show stale Minna titles instead of Shin Kanzen curriculum labels. | Fixed + deployed |
| QA-A-019 | Grammar examples | Upper-level grammar examples could be blank because the flat object schema was not decoded. | Fixed + deployed |
| QA-A-020 | Sentry | Sentry CDN was not allowed by Hosting CSP. | Fixed + deployed |
| QA-A-021 | Grammar direct links | Direct grammar detail could load before active-level seed and stay loading/not-found. | Fixed + deployed |
| QA-A-022 | Kana | Kana sheet allowed untested self-attestation via `Tôi đã thuộc`. | Fixed + deployed |
| QA-A-023 | Copy/internal labels | Mistakes, JLPT support, and Home Weakness Radar exposed `D1/D3/D7` checkpoint labels. | Fixed + deployed |
| QA-A-024 | Foundations copy/internal labels | Foundations hub and Kana sheet exposed `Open`, `yoon`, `rules`, `strokes`, and `clear`. | Fixed + deployed |
| QA-A-025 | Onboarding | Fresh language onboarding could hide the continue CTA behind/under the analytics consent banner after selecting a language. | Fixed + deployed |
| QA-B-001-G-N4-L46-L50 | Grammar content | N4 lessons 46-50 needed source verification plus full detail/example/practice proof. | Fixed + deployed |
| QA-C-001 | Conjugation feature | Content DB lemma table, exact-skill SRS/mistakes, Grammar-owned hub/practice routes, Vocab detail, Grammar detail, Kanji example words, and due-queue entry points are deployed. | Connected entry points fixed + deployed |
| QA-C-002 | Vocab detail conjugation | Vocab detail exposed generated-looking but suffix-guessed forms and generic grammar CTA. | Fixed + deployed |
| QA-A-026 | Search navigation | Search top-hit cards could look tappable but fail to open detail; live `かえる` result stayed on `/#/search` after click. | Fixed + deployed |
| QA-A-027 | Lesson vocab/ghost grammar/copy | Lesson vocab flashcard had a self-attestation checkmark that seeded SRS; ghost grammar practice had `Mark as Mastered`; lesson grammar showed `v? d?`; dashboard/practice copy had machine-like Vietnamese. | Fixed + deployed |
| QA-A-028 | Home/Library copy | Daily Summary, Daily Session Card, and Library roadmap exposed machine-like or mixed Vietnamese copy (`dọn review`, `dọn hàng đợi`, `level`, `lesson`, `TÍN HIỆU LEVEL`). | Fixed + deployed |
| QA-A-029 | Vocab route | Fresh VI/N5 `/#/vocab` stayed on a spinner after 25 seconds with no Flutter exception. | Fixed + deployed |
| QA-A-030 | Grammar/Kanji routes | Fresh VI/N5 `/#/grammar` and `/#/kanji` stayed in loading states after 25-45 seconds during cold direct-route checks. | Fixed + deployed |
| QA-A-002 | Vocab copy | Vocab hub/catalog leaked English/internal status copy such as `Ready now`, `Companion`, and `Catalog`. | Fixed + deployed |
| QA-A-003 | Review copy/CTA | Review page used warehouse metaphors and needed live CTA proof. | Fixed + deployed |
| QA-A-005 | N2 lesson label | N2 next-lesson copy could expose legacy storage id `Minna No Nihongo 200001`. | Fixed + deployed |
| QA-A-008 | Grammar practice gate | Grammar detail needed a real practice gate/SRS path across N5-N1 instead of manual self-attestation. | Fixed + deployed |
| QA-A-031 | Grammar question quality | Generated transformation drills could show options that differed only by sentence-final punctuation. | Fixed + deployed |
| QA-B-003 | Grammar practice content | Authored grammar practice bank is empty; generated coverage is complete, but source-informed authored items are still content enrichment debt. | Queued |
| QA-A-030 | Vocab content | Minna app vocab still has canonical app-diff rows pending after earlier batches; batches 013-067 continued with two hundred eighty-five safe N5/N4 repairs from local sources only. Remaining N5/N4 meaning rows are now mostly nuance-sensitive, malformed, absent from local canonical coverage, app-better-than-canonical, or hidden text-hygiene cases that need manual review rather than automatic apply. | Batches 013-067 applied locally |

## Live Proof Artifacts

- `output/playwright/live-appcheck-home-proof.png`
- `output/playwright/live-n2-direct-detail-fixed-detail-top.png`
- `output/playwright/live-n2-direct-detail-fixed-detail-examples.png`
- `output/playwright/live-n2-direct-detail-fixed-practice-gate.png`
- `output/playwright/live-n4-direct-detail-fixed-detail-top.png`
- `output/playwright/live-n4-direct-detail-fixed-detail-examples.png`
- `output/playwright/live-n4-direct-detail-fixed-practice-gate.png`
- `output/playwright/live-n4-search-tokoro-fixed.png`
- `output/playwright/live-foundations-hub-vi-fixed.png`
- `output/playwright/live-kana-grid-vi-fixed.png`
- `output/playwright/live-kana-sheet-vi-fixed.png`
- `output/playwright/live-kana-quiz-from-sheet-vi-fixed.png`
- `output/playwright/live-conjugation-phase0-home-smoke.png`
- `output/playwright/live-conjugation-engine-home-smoke.png`
- `live-conjugation-lemmas-home-smoke.png`
- `output/playwright/live-conjugation-db-home.png`
- `output/playwright/live-conjugation-db-after-vi-click.png`
- `output/playwright/live-conj-srs-mistakes-hash.png`
- `output/playwright/live-conj-srs-home-nav.png`
- `output/playwright/live-conjugation-hub-vi.png`
- `output/playwright/live-conjugation-practice-vi.png`
- `output/playwright/live-conjugation-selected-vi.png`
- `output/playwright/live-conjugation-confirmed-vi.png`
- `output/playwright/live-onboarding-banner-fixed-before.png`
- `output/playwright/live-onboarding-banner-fixed-level.png`
- `output/playwright/live-onboarding-banner-fixed-home.png`
- `output/playwright/live-vocab-kaeru-detail-retry.png`
- `output/playwright/live-vocab-kaeru-after-cta-click.png`
- `output/playwright/live-vocab-kaeru-scoped-practice.png`
- `output/playwright/live-vocab-kaeru-practice-answer.png`
- `output/playwright/live-vocab-gakusei-no-conj.png`
- `output/playwright/live-search-kaeru-results.png`
- `output/playwright/live-search-kaeru-top-hit-fixed-before.png`
- `output/playwright/live-search-kaeru-top-hit-fixed-after.png`
- `output/playwright/live-grammar81-conj-cta-fixed.png`
- `output/playwright/live-grammar81-after-cta-click.png`
- `output/playwright/live-grammar81-conj-wrong-srs.png`
- `output/playwright/live-kanji-n4-grid-before-example-cta.png`
- `output/playwright/live-kanji-n4-example-cta-dialog.png`
- `output/playwright/live-kanji-n4-example-cta-practice.png`
- `output/playwright/live-kanji-n4-example-cta-question.png`
- `output/playwright/live-practice-board-conj-due.png`
- `output/playwright/live-practice-board-conj-due-question.png`
- `output/playwright/live-qa-a-027-lesson-vocab.png`
- `output/playwright/live-qa-a-027-lesson-grammar-copy.png`
- `output/playwright/live-qa-a-027-practice-copy.png`
- `output/playwright/live-qa-a-027-lesson-grammar-tab-copy.png`
- `output/playwright/live-qa-a-027-fresh-csp-home.png`
- `output/playwright/live-qa-a-001-before-profile-click.png`
- `output/playwright/live-qa-a-001-profile-after-click.png`
- `output/playwright/live-qa-a-004-n2-lesson-title-after-wait.png`
- `output/playwright/live-qa-a-004-n2-lesson-grammar-tab-live.png`
- `output/playwright/live-p1-copy-vocab-n5-after-wait.png`
- `output/playwright/live-qaa029-direct-n5-25s.png`
- `output/playwright/live-qaa029-route-___grammar.png`
- `output/playwright/live-qaa029-route-___kanji.png`
- `output/playwright/live-qaa029-grammar-45s.png`
- `output/playwright/live-qaa028-home-copy-proof.png`
- `output/playwright/live-qaa028-daily-summary-copy-proof.png`
- `output/playwright/live-qaa028-library-copy-proof.png`
- `output/playwright/live-qaa029-vocab-direct-proof.png`
- `output/playwright/live-qaa029-vocab-review-cta-proof.png`
- `output/playwright/live-qaa029-vocab-minna-cta-proof.png`
- `output/playwright/live-qaa028-qaa029-proof.json`
- `output/playwright/live-qaa030-grammar-direct.png`
- `output/playwright/live-qaa030-grammar-practice-cta.png`
- `output/playwright/live-qaa030-grammar-detail-cta.png`
- `output/playwright/live-qaa030-kanji-direct.png`
- `output/playwright/live-qaa030-kanji-write-cta.png`
- `output/playwright/live-qaa030-kanji-hanviet-cta.png`
- `output/playwright/live-qaa030-proof.json`
- `output/playwright/live-p1-backlog-cleanup-proof.json`
- `output/playwright/live-qaa002-vocab-copy.png`
- `output/playwright/live-qaa002-vocab-minna-catalog.png`
- `output/playwright/live-qaa003-review-copy.png`
- `output/playwright/live-qaa005-n2-home.png`
- `output/playwright/live-qaa005-n2-review.png`
- `output/playwright/live-qaa008-qaa031-grammar-proof.json`
- `output/playwright/live-qaa008-n5-practice-gate.png`
- `output/playwright/live-qaa008-n4-practice-gate.png`
- `output/playwright/live-qaa008-n3-practice-gate.png`
- `output/playwright/live-qaa008-n2-practice-gate.png`
- `output/playwright/live-qaa008-n1-practice-gate.png`

## Notes For Next Sweep

- Continue with full app audit before resuming feature queue work.
- Pay special attention to self-attestation buttons in Kana/Foundation and any
  "Đã học/Tôi đã thuộc" action that does not require practice.
- Re-audit Hán-Việt from the Kanji learning flow, not only from the standalone
  rule list.
- Re-audit `Kế hoạch hôm nay` and other dashboard cards for layout balance,
  untranslated copy, internal labels, and CTA destinations.
- Continue live route sweep with quoted hash routes; unquoted PowerShell `#`
  comments can invalidate the matrix command.
