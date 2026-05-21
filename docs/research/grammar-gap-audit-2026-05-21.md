# Grammar Gap Audit - 2026-05-21

Phase: Sprint 1 Phase D - Tae Kim fallback integration.

Source policy:
- Primary data remains the existing JpStudy grammar corpus.
- Tae Kim is used as a licensed fallback reference only: Tae Kim's Guide to Japanese Grammar (CC-BY-NC-SA 3.0).
- URL: https://guidetojapanese.org/learn/grammar
- No Tae Kim prose is copied into app content.

## Summary

| Metric | Before | After |
|---|---:|---:|
| Grammar items | 754 | 754 |
| Missing Directive E sections | 0 | 0 |
| Short explanation hints | 8 | 8 |
| Tae Kim fallback eligible | 708 | 708 |

## Level Coverage

| Level | Items | Tae Kim fallback eligible |
|---|---:|---:|
| N1 | 245 | 232 |
| N2 | 191 | 188 |
| N3 | 100 | 97 |
| N4 | 100 | 92 |
| N5 | 118 | 99 |

## DECISIONS_MADE

- Added a `directiveE` block to grammar payloads instead of changing DB schema; the current content DB can keep seeding stable rows while UI can opt into richer guidance later.
- Used original JpStudy wording for form/meaning/usage/humanMoment. Tae Kim is recorded as fallback reference and license attribution, not as copied prose.
- Kept existing tags unchanged, including any owner-added approval tags; script never adds `vi-human-approved`.

## OPEN_QUESTIONS

- OQ-D-001 (non-blocking): decide later whether grammar detail UI should render `directiveE` as separate tabs or as one compact study card.
