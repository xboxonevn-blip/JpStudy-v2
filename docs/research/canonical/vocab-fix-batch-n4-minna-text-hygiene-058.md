# Vocab Fix Batch - n4-minna-text-hygiene-058

- Date: 2026-06-26T09:06:47.2876407+07:00
- Scope: QA-A-030, N4 Minna lesson 27 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. All five rows were
verified through exact local terms or through their base dictionary forms:
`飼う`, `建てる`, `取る`, `聞こえる`, and `昼間`.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `飼います` | `かいます` | Meaning and example repair | `nuôi (động vật)` / `きょう、飼いますつもりです。` / `Hôm nay tôi định nuôi.` | `Nuôi, chăn nuôi [động vật]` / `うちでは犬を飼っています。` / `Ở nhà tôi đang nuôi một con chó.` | Source lemma `飼う`; `sourceConsensus`: `kanji-vocab-n2`, `minna-2`; ticket `QA-A-030`. |
| `建てます` | `たてます` | Meaning capitalization and example repair | `xây, xây dựng` / `朝の準備が終わったら建てます。` / `Khi chuẩn bị buổi sáng xong, tôi xây.` | `Xây, xây dựng` / `父は田舎に家を建てます。` / `Bố tôi sẽ xây một ngôi nhà ở quê.` | Source lemma `建てる`; `sourceConsensus`: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |
| `取ります` | `とります` | Meaning and example repair | `xin (nghỉ)` / `朝の準備が終わったら取ります。` / `Khi chuẩn bị buổi sáng xong, tôi xin.` | `Xin [nghỉ]` / `来週、一日休みを取ります。` / `Tuần sau tôi sẽ xin nghỉ một ngày.` | Source lemma `取る`; kept the lesson-specific leave-taking sense; `sourceConsensus`: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |
| `聞こえます` | `きこえます` | Example and source metadata repair | `朝の準備が終わったら聞こえます。` / `Khi chuẩn bị buổi sáng xong, tôi nghe thấy.` | `隣の部屋から音楽が聞こえます。` / `Tôi nghe thấy nhạc từ phòng bên cạnh.` | Source lemma `聞こえる`; `sourceConsensus`: `kanji-vocab-n5`, `minna-2`; ticket `QA-A-030`. |
| `昼間` | `ひるま` | Meaning capitalization and example repair | `ban ngày` / `昼間から授業が始まります。` / `Lớp học bắt đầu từ ban ngày.` | `Ban ngày` / `昼間は電気をつけなくても明るいです。` / `Ban ngày thì không bật đèn cũng sáng.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n4`, `kanji-vocab-n5`; ticket `QA-A-030`. |

## Learner-Facing Notes

- Replaced broken verb templates with concrete object/context frames: keeping a
  dog, building a house, taking leave, hearing music, and daytime brightness.
- Kept `取ります` tied to `休みを取る` rather than broadening it to every sense of
  `取る`, because that is the lesson-specific learner target.
