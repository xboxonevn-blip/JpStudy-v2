# Vocab Fix Batch - n4-minna-text-hygiene-066

- Date: 2026-06-26T15:00:41.1023742+07:00
- Scope: QA-A-030, N4 Minna lesson 28 stale-template text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. Exact or
lesson-local canonical rows verified `真面目`, `形`, `色`, `味`, and
`ドラマ`. `形`, `色`, and `味` already had source-verification metadata from
earlier cleanup; this batch only replaced their stale examples.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `真面目` | `まじめ` | Meaning, metadata, and example repair | `nghiêm túc, chăm chỉ` / `これは真面目です。` / `Đây là nghiêm túc.` | `Nghiêm túc, nghiêm chỉnh` / `ワット先生は真面目で、熱心です。` / `Thầy Watt nghiêm túc và nhiệt tình.` | Local rows for `真面目` / `まじめ[な]`; `sourceConsensus`: `kanji-vocab-n5`, `minna-2`; ticket `QA-A-030`. |
| `形` | `かたち` | Example repair | `これは形です。` / `Đây là hình dáng.` | `このかばんは形がいいです。` / `Cái túi này có dáng đẹp.` | Existing source metadata kept: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |
| `色` | `いろ` | Example repair | `これは色です。` / `Đây là màu sắc.` | `このシャツは色がきれいです。` / `Cái áo này có màu đẹp.` | Existing source metadata kept: `kanji-vocab-n4`, `minna-2`; ticket `QA-A-030`. |
| `味` | `あじ` | Example repair | `これは味です。` / `Đây là vị.` | `このガムは味がいいです。` / `Kẹo cao su này có vị ngon.` | Existing source metadata kept: `kanji-vocab-n4`, `minna-2`; ticket `QA-A-030`. |
| `ドラマ` | `どらま` | Meaning, metadata, and example repair | `phim truyền hình (drama)` / `これはドラマです。` / `Đây là phim truyền hình.` | `Kịch, phim truyền hình` / `週末に日本のドラマを見ました。` / `Cuối tuần tôi đã xem phim truyền hình Nhật.` | Exact Minna-2 row; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |

## Learner-Facing Notes

- This batch removes the next five `これは...です` stale templates from lesson
  28 and replaces them with contexts that show adjective/noun usage naturally.
- The examples lean on lesson-28 grammar contexts: qualities joined with `し`,
  concrete item attributes, and everyday media viewing.
