# Vocab Fix Batch - n4-minna-text-hygiene-065

- Date: 2026-06-26T14:54:40.2943031+07:00
- Scope: QA-A-030, N4 Minna stale-template text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. The polite-form
app rows `付けます`, `踊ります`, `噛みます`, and `選びます` were verified
through exact local base-form rows: `付ける`, `踊る`, `噛む`, and `選ぶ`.
`新聞社` did not have an exact row in the local canonical vocab markdown for
this Minna entry, so it was repaired without new source-verification metadata.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `新聞社` | `しんぶんしゃ` | Meaning capitalization and example repair | `tòa soạn báo` / `新聞社の前で友だちを待ちました。` / `Tôi đã đợi bạn trước tòa soạn báo.` | `Tòa soạn báo` / `兄は新聞社で働いています。` / `Anh trai tôi đang làm việc ở tòa soạn báo.` | App-only/local diff place row for this Minna entry; no new source-verification tag. |
| `付けます` | `つけます` | Meaning capitalization, metadata, and example repair | `lắp, gắn` / `朝の準備が終わったら付けます。` / `Khi chuẩn bị buổi sáng xong, tôi lắp.` | `Lắp, gắn` / `かばんに名前の札を付けます。` / `Tôi gắn thẻ tên vào cặp.` | Local base-form rows for `付ける`; `sourceConsensus`: `kanji-vocab-n3`, `mimikara-n3`, `minna-2`; ticket `QA-A-030`. |
| `踊ります` | `おどります` | Meaning capitalization, metadata, and example repair | `nhảy, khiêu vũ` / `朝の準備が終わったら踊ります。` / `Khi chuẩn bị buổi sáng xong, tôi nhảy.` | `Nhảy, khiêu vũ` / `夏祭りで友達と踊ります。` / `Tôi sẽ nhảy múa với bạn ở lễ hội mùa hè.` | Local base-form rows for `踊る`; `sourceConsensus`: `kanji-vocab-n2`, `minna-2`; ticket `QA-A-030`. |
| `噛みます` | `かみます` | Meaning, metadata, and example repair | `nhai, cắn` / `朝の準備が終わったら噛みます。` / `Khi chuẩn bị buổi sáng xong, tôi nhai.` | `Nhai` / `雑誌を読みながら、ガムを噛みます。` / `Tôi vừa đọc tạp chí vừa nhai kẹo cao su.` | Local base-form row for `噛む`; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |
| `選びます` | `えらびます` | Meaning capitalization, metadata, and example repair | `chọn` / `朝の準備が終わったら選びます。` / `Khi chuẩn bị buổi sáng xong, tôi chọn.` | `Chọn` / `旅行の前にホテルを選びます。` / `Trước chuyến du lịch, tôi chọn khách sạn.` | Local base-form rows for `選ぶ`; `sourceConsensus`: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |

## Learner-Facing Notes

- This batch removes five stale place/verb templates that gave learners
  grammatically possible but pedagogically weak contexts.
- The lesson-28 verb examples now model concrete objects and settings: dancing
  at a summer festival, chewing gum, and choosing a hotel before travel.
