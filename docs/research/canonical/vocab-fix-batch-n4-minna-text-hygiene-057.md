# Vocab Fix Batch - n4-minna-text-hygiene-057

- Date: 2026-06-25T22:19:24.3848290+07:00
- Scope: QA-A-030, N4 Minna lesson 26 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. `ボランティア`,
`瓶`, and `お湯` were verified through exact local canonical rows. `缶`
already carried source-verification metadata and only needed a learner-facing
example replacement. `ガス会社` received an example-only repair and no new
source-verification metadata because exact local coverage was absent.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `ボランティア` | `ぼらんてぃあ` | Meaning capitalization, example, and source metadata repair | `tình nguyện viên` / `これはボランティアです。` / `Đây là tình nguyện viên.` | `Tình nguyện viên` / `駅でボランティアが道を案内してくれました。` / `Ở nhà ga, một tình nguyện viên đã chỉ đường cho tôi.` | Exact local row; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |
| `瓶` | `びん` | Meaning capitalization, example, and source metadata repair | `cái chai` / `これは瓶です。` / `Đây là cái chai.` | `Cái chai` / `この瓶に水を入れてください。` / `Hãy cho nước vào cái chai này.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n2`, `minna-2`; ticket `QA-A-030`. |
| `缶` | `かん` | Example repair | `これは缶です。` / `Đây là cái lon.` | `缶は燃えないごみに出してください。` / `Lon thì hãy bỏ vào rác không cháy được.` | Existing source verification kept: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |
| `お湯` | `おゆ` | Meaning capitalization, example, and source metadata repair | `nước nóng` / `昼休みにお湯を注文しました。` / `Giờ nghỉ trưa tôi đã gọi nước nóng.` | `Nước nóng` / `お湯を少しください。` / `Cho tôi một ít nước nóng.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n3`, `minna-1`; ticket `QA-A-030`. |
| `ガス会社` | `がすがいしゃ` | Example-only context repair | `ガス会社の前で友だちを待ちました。` / `Tôi đã đợi bạn trước công ty gas.` | `引っ越しの前にガス会社に連絡します。` / `Trước khi chuyển nhà, tôi sẽ liên hệ với công ty gas.` | No `sourceConsensus` added because exact local coverage is absent. |

## Learner-Facing Notes

- Replaced bare identification/place-template examples with real lesson-26
  contexts: volunteer guidance, bottles/cans, asking for hot water, and
  contacting a utility company before moving.
- Preserved existing source metadata for `缶` and avoided adding metadata to
  `ガス会社` where local source coverage was missing.
