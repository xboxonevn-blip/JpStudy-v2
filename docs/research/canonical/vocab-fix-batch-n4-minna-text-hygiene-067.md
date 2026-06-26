# Vocab Fix Batch - n4-minna-text-hygiene-067

- Date: 2026-06-26T15:07:21.5559963+07:00
- Scope: QA-A-030, N4 Minna lesson 28 stale-template and hidden text hygiene
- Changed rows: 7
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. Exact local rows
verified `娘`, `自分`, `それに`, `日にち`, `土`, and `体育館`. The phrase
`ちょっとお願いがあるんですが` is an app-only phrase row in the local diff, so
its broken example was repaired without new source-verification metadata.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `娘` | `むすめ` | Example repair | `これは娘です。` / `Đây là con gái.` | `娘は大学で日本語を勉強しています。` / `Con gái tôi đang học tiếng Nhật ở đại học.` | Existing source metadata kept: `kanji-vocab-n3`, `minna-2`; ticket `QA-A-030`. |
| `自分` | `じぶん` | Meaning, metadata, and example repair | `bản thân` / `これは自分です。` / `Đây là bản thân.` | `Bản thân, mình` / `自分の意見をノートに書きました。` / `Tôi đã viết ý kiến của mình vào vở.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n4`, `minna-2`; ticket `QA-A-030`. |
| `それに` | `それに` | Meaning, metadata, and example repair | `hơn nữa, thêm vào đó` / `契約書ではそれにの形で前の内容を受けています。` / `Trong hợp đồng, hơn nữa nối lại nội dung phía trước.` | `Thêm nữa là, thêm vào đó là` / `この店は安いです。それに、駅から近いです。` / `Cửa hàng này rẻ. Hơn nữa, nó gần ga.` | Exact Minna-2 row; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |
| `ちょっとお願いがあるんですが` | `ちょっとおねがいがあるんですが` | Meaning capitalization and example repair | `tôi có chút việc muốn nhờ` / `これはちょっとお願いがあるんですがです。` / `Đây là tôi có chút việc muốn nhờ.` | `Tôi có chút việc muốn nhờ` / `すみません、ちょっとお願いがあるんですが。` / `Xin lỗi, tôi có chút việc muốn nhờ.` | App-only phrase row; no new source-verification tag. |
| `日にち` | `ひにち` | Meaning capitalization, metadata, and example repair | `ngày` / `これは日にちです。` / `Đây là ngày.` | `Ngày` / `旅行の日にちを決めました。` / `Tôi đã quyết định ngày đi du lịch.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n5`, `minna-2`; ticket `QA-A-030`. |
| `土` | `ど` | Meaning capitalization, metadata, and example repair | `thứ bảy` / `土から授業が始まります。` / `Lớp học bắt đầu từ thứ bảy.` | `Thứ bảy` / `予定表では、土は休みです。` / `Trong lịch trình, thứ bảy là ngày nghỉ.` | Exact Minna-2 row for reading `ど`; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |
| `体育館` | `たいいくかん` | Meaning, metadata, and example repair | `nhà thi đấu, phòng tập thể dục` / `体育館の前で友だちを待ちました。` / `Tôi đã đợi bạn trước nhà thi đấu.` | `Nhà tập, nhà thi đấu thể thao` / `体育館でバスケットボールをしました。` / `Tôi đã chơi bóng rổ ở nhà thi đấu.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n4`, `kanji-vocab-n5`, `minna-2`; ticket `QA-A-030`. |

## Learner-Facing Notes

- This batch clears the next visible lesson-28 stale templates and the hidden
  broken `それに` connector example spotted during batch 066 review.
- `土` is kept source-verified only through the Minna-2 `ど` row because the
  kanji-vocab N5 exact term uses the different reading `つち` for "earth/soil".
