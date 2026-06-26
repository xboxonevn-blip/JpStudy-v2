# Vocab Fix Batch - n4-minna-text-hygiene-062

- Date: 2026-06-26T09:34:53.5774095+07:00
- Scope: QA-A-030, N4 Minna lesson 27 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources and bundled local
example corpora only. Exact local canonical rows verified `夢`, `形`, and
`ロボット`. `日曜大工` had no exact local canonical row, so it received an
example/learner-gloss repair without new source verification metadata.
`子供たち` was repaired as a learner-facing plural/example row; its base
`子供` is locally sourced, but no exact `子供たち` canonical row exists, so no
new source verification metadata was added.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `日曜大工` | `にちようだいく` | Meaning and example repair | `thợ mộc chủ nhật (làm mộc vu vơ ngày nghỉ)` / `これは日曜大工です。` / `Đây là thợ mộc chủ nhật.` | `Tự làm đồ mộc vào ngày nghỉ (DIY)` / `父は日曜大工で本棚を作りました。` / `Bố tôi tự làm một giá sách vào ngày nghỉ.` | No exact local canonical row; no new source-verification tag. |
| `夢` | `ゆめ` | Meaning capitalization, metadata, and example repair | `giấc mơ` / `これは夢です。` / `Đây là giấc mơ.` | `Giấc mơ` / `昨夜、楽しい夢を見ました。` / `Tối qua tôi đã mơ một giấc mơ vui.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n3`, `mimikara-n3`, `minna-1`; ticket `QA-A-030`. |
| `子供たち` | `こどもたち` | Meaning capitalization and example repair | `trẻ con, bọn trẻ` / `これは子供たちです。` / `Đây là trẻ con.` | `Trẻ con, bọn trẻ` / `子供たちがおもちゃで遊んでいる。` / `Bọn trẻ đang chơi với đồ chơi.` | Base `子供` has local coverage; example from bundled Tatoeba seed; no exact plural canonical row, so no new source-verification tag. |
| `形` | `かたち` | Example repair | `これは形です。` / `Đây là hình dáng.` | `この皿は丸い形をしています。` / `Cái đĩa này có hình tròn.` | Meaning/source metadata already repaired earlier; retained `sourceConsensus`: `kanji-vocab-n3`, `minna-2`. |
| `ロボット` | `ろぼっと` | Meaning, metadata, and example repair | `người máy` / `これはロボットです。` / `Đây là người máy.` | `Robot, người máy` / `ロボットなら危険な状態になっても切り抜けられる。` / `Robot có thể hoạt động trong điều kiện nguy hiểm.` | Exact local row; `sourceConsensus`: `mimikara-n3`; ticket `QA-A-030`; example from bundled Tatoeba seed. |

## Learner-Facing Notes

- Replaced five more stale `これは...です` examples with contexts that show how
  the terms behave in real sentences.
- Kept source-verification metadata truthful: exact local rows get
  `vi-source-verified`; base-derived or app-only rows do not.
