# Vocab Fix Batch - n4-minna-text-hygiene-056

- Date: 2026-06-25T22:14:31.8046830+07:00
- Scope: QA-A-030, N4 Minna lesson 26 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. `会議に間に合う`
was verified through local base lemma `間に合う`; `様` was verified through
local suffix entries `～様`. `やります`, `電子メール`, and `大阪弁（方言）`
received example/search-text repairs only and no new source-verification
metadata because exact canonical coverage was absent in the local sources.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `やります` | `やります` | Example-only context repair | `朝の準備が終わったらやります。` / `Khi chuẩn bị buổi sáng xong, tôi làm.` | `宿題は今晩やります。` / `Bài tập thì tối nay tôi sẽ làm.` | No `sourceConsensus` added because exact local coverage is absent. |
| `電子メール` | `でんしめーる` | Search normalization and example repair | `thu đien tu, email` / `これは電子メールです。` / `Đây là thư điện tử.` | `thu dien tu, email` / `電子メールで資料を送りました。` / `Tôi đã gửi tài liệu bằng email.` | No `sourceConsensus` added because exact local coverage is absent. |
| `会議に間に合う` | `かいぎにまにあう` | Meaning and example repair | `đến đúng giờ cho một cuộc họp` / `会議に間に合うから授業が始まります。` / `Lớp học bắt đầu từ đến đúng giờ cho một cuộc họp.` | `Kịp cuộc họp` / `急げば会議に間に合います。` / `Nếu nhanh lên thì sẽ kịp cuộc họp.` | Source lemma `間に合う`; `sourceConsensus`: `kanji-vocab-n4`, `kanji-vocab-n5`, `minna-2`; ticket `QA-A-030`. |
| `大阪弁（方言）` | `おおさかべん（ほうげん）` | Example-only context repair | `これは大阪弁（方言）です。` / `Đây là Phương ngữ Osaka.` | `大阪弁は大阪の方言です。` / `Osaka-ben là phương ngữ của Osaka.` | No `sourceConsensus` added because exact local coverage is absent. |
| `様` | `さま` | Meaning and example repair | `Ông/Bà. (kính trọng)` / `これは様です。` / `Đây là Ông.` | `Ngài ~, ông/bà ~ (kính trọng)` / `田中様は会議室でお待ちです。` / `Ông/Bà Tanaka đang đợi ở phòng họp.` | Source suffix `～様`; `sourceConsensus`: `kanji-vocab-n4`, `minna-2`; ticket `QA-A-030`. |

## Learner-Facing Notes

- Replaced empty-template examples with contexts that show the real grammar
  slot: doing homework, sending email, arriving in time, explaining a dialect,
  and attaching an honorific suffix to a name.
- Preserved the source boundary by leaving authored-only repairs without
  source-verification metadata.
