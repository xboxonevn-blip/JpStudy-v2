# Vocab Fix Batch - n4-minna-text-hygiene-063

- Date: 2026-06-26T09:41:57.3980730+07:00
- Scope: QA-A-030, N4 Minna lesson 27 text hygiene
- Changed rows: 6
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. Exact local rows
verified `不思議`, `例えば`, `空`, `自分`, and the attributive `不思議な`
through the local `ふしぎ[な]` canonical row. `ドラえもん` is an app-only
proper noun in the local diff, so its example was repaired without new source
verification metadata.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `不思議` | `ふしぎ` | Meaning, metadata, and example repair | `kỳ lạ, bí ẩn` / `これは不思議です。` / `Đây là kỳ lạ.` | `Kì lạ, thần bí` / `この話は少し不思議です。` / `Câu chuyện này hơi kỳ lạ.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n3`, `kanji-vocab-n4`, `minna-2`; ticket `QA-A-030`. |
| `例えば` | `たとえば` | Meaning capitalization, metadata, and example repair | `ví dụ` / `これは例えばです。` / `Đây là ví dụ.` | `Ví dụ` / `例えば、雨の日は家で本を読みます。` / `Ví dụ, ngày mưa thì tôi đọc sách ở nhà.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |
| `空` | `そら` | Meaning capitalization, metadata, and example repair | `bầu trời` / `これは空です。` / `Đây là bầu trời.` | `Bầu trời` / `今日は空がとても青いです。` / `Hôm nay bầu trời rất xanh.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n4`, `minna-2`; ticket `QA-A-030`. |
| `自分` | `じぶん` | Meaning, metadata, and example repair | `bản thân` / `これは自分です。` / `Đây là bản thân.` | `Bản thân, mình` / `自分の名前をここに書いてください。` / `Hãy viết tên của mình vào đây.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n4`, `minna-2`; ticket `QA-A-030`. |
| `ドラえもん` | `ドラえもん` | Example repair | `これはドラえもんです。` / `Đây là Doraemon.` | `子供たちはドラえもんの漫画が大好きです。` / `Bọn trẻ rất thích truyện tranh Doraemon.` | App-only proper noun; no new source-verification tag. |
| `不思議な` | `ふしぎな` | Meaning, metadata, and example repair | `bí ẩn` / `これは不思議なです。` / `Đây là bí ẩn.` | `Kì lạ, thần bí` / `昨日、不思議な話を聞きました。` / `Hôm qua tôi nghe một câu chuyện kỳ lạ.` | Local `ふしぎ[な]` row covers the attributive adjective; `sourceConsensus`: `kanji-vocab-n3`, `kanji-vocab-n4`, `minna-2`; ticket `QA-A-030`. |

## Learner-Facing Notes

- This batch clears the remaining `これは...です` stale examples in lesson 27.
- It also repairs the ungrammatical `これは不思議なです` template by using the
  adjective before a noun in a natural listening context: `不思議な話を聞きました`.
