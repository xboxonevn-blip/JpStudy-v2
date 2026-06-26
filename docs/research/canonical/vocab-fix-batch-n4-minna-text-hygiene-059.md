# Vocab Fix Batch - n4-minna-text-hygiene-059

- Date: 2026-06-26T09:12:31.5081923+07:00
- Scope: QA-A-030, N4 Minna lesson 27 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. `昔`, `～後`, and
`～しか` were verified through local exact rows. `ほかの` and `日曜日大工`
received example-only repairs and no new source-verification metadata because
exact local coverage was absent.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `昔` | `むかし` | Meaning capitalization, example, and source metadata repair | `ngày xưa` / `昔から授業が始まります。` / `Lớp học bắt đầu từ ngày xưa.` | `Ngày xưa` / `昔、この町はとても静かでした。` / `Ngày xưa, thị trấn này rất yên tĩnh.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |
| `～後` | `ご` | Example and source metadata repair | `～後から授業が始まります。` / `Lớp học bắt đầu từ sau ～.` | `授業後、図書館へ行きます。` / `Sau giờ học, tôi đi đến thư viện.` | Exact local suffix row; `sourceConsensus`: `kanji-vocab-n4`; ticket `QA-A-030`. |
| `～しか` | `しか` | Example and source metadata repair | `～しかの前で友だちを待ちました。` / `Tôi đã đợi bạn trước chỉ ～.` | `財布には千円しかありません。` / `Trong ví chỉ có 1000 yên.` | Exact local particle row; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |
| `ほかの` | `ほかの` | Example-only context repair | `これはほかのです。` / `Đây là khác.` | `ほかの色もありますか。` / `Có màu khác không?` | No `sourceConsensus` added because exact local coverage is absent. |
| `日曜日大工` | `にちようびだいく` | Example-only context repair | `日曜日大工から授業が始まります。` / `Lớp học bắt đầu từ thợ mộc cuối tuần.` | `父は日曜日大工で本棚を作りました。` / `Bố tôi tự làm một giá sách vào ngày nghỉ.` | No `sourceConsensus` added because exact local coverage is absent. |

## Learner-Facing Notes

- Replaced broken time/place templates with actual usage frames for old times,
  after-class timing, the negative-only `しか` pattern, alternatives, and
  weekend DIY.
- Kept authored-only rows clearly separate from source-verified rows.
