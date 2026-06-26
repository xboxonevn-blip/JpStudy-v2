# Vocab Fix Batch - n4-minna-text-hygiene-055

- Date: 2026-06-25T22:08:51.4189938+07:00
- Scope: QA-A-030, N4 Minna lesson 26 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. `探します` and
`申し込みます` were verified through local base lemmas `探す` and `申し込む`.
`柔道` already carried source-verification metadata and only needed a
learner-facing example replacement. `学校に連絡する` was verified through local
base lemma `連絡する`; `平日` was verified through exact local canonical entries.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `探します` | `さがします` | Example and source metadata repair | `受付で探しますと伝えました。` / `Ở quầy tiếp tân, tôi đã nói "tìm".` | `なくした鍵を探しています。` / `Tôi đang tìm chiếc chìa khóa bị mất.` | Source lemma `探す`; `sourceConsensus`: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |
| `申し込みます` | `もうしこみます` | Meaning capitalization, example, and source metadata repair | `đăng ký` / `昼休みに申し込みますを注文しました。` / `Giờ nghỉ trưa tôi đã gọi đăng ký.` | `Đăng ký` / `来月の日本語クラスに申し込みます。` / `Tôi sẽ đăng ký lớp tiếng Nhật tháng sau.` | Source lemma `申し込む`; `sourceConsensus`: `kanji-vocab-n2`, `mimikara-n3`, `minna-2`; ticket `QA-A-030`. |
| `柔道` | `じゅうどう` | Example repair | `朝、柔道を通りました。` / `Sáng nay tôi đi qua Nhu đạo.` | `兄は毎週柔道を習っています。` / `Anh trai tôi học judo mỗi tuần.` | Existing source verification kept: `kanji-vocab-n2`, `minna-2`; ticket `QA-A-030`. |
| `学校に連絡する` | `がっこうにれんらくする` | Meaning capitalization, example, and source metadata repair | `liên hệ với trường học` / `二つの資料の学校に連絡するを表にまとめました。` / `Tôi tóm tắt liên hệ với trường học của hai tài liệu thành bảng.` | `Liên hệ với trường học` / `休むときは学校に連絡してください。` / `Khi nghỉ học, hãy liên hệ với trường.` | Source lemma `連絡する`; `sourceConsensus`: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |
| `平日` | `へいじつ` | Meaning and example repair | `ngày trong tuần` / `平日から授業が始まります。` / `Lớp học bắt đầu từ ngày trong tuần.` | `Ngày thường` / `平日は朝から仕事があります。` / `Ngày thường tôi có việc từ sáng.` | Exact local entries; `sourceConsensus`: `kanji-vocab-n3`, `kanji-vocab-n5`, `mimikara-n2`, `minna-2`; ticket `QA-A-030`. |

## Learner-Facing Notes

- Replaced examples where the generated sentence treated verbs as quoted
  nouns or forced the term into an unrelated template.
- Kept changes local to lesson-26 rows and only attached source-verification
  metadata where the local canonical sources support the term or base lemma.
