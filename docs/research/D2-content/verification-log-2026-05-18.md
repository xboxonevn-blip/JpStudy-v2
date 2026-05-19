# Content Verification Log

## Kanji N5 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for readings, English meanings, and Vietnamese readings where present.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese` and `kDefinition` cross-checks.

| Item | Sources | Change |
|---|---|---|
| `二` | KANJIDIC2: `vietnam=Nhị`, meaning `two`; Unihan: `kVietnamese=nhì` | Corrected Hán-Việt from `Hai` to `Nhị`; added `meaningVi=hai`, `meaningViDisplay=Nhị (hai)`, normalized search fields. |
| `三` | KANJIDIC2: `vietnam=Tam/Tám`, meaning `three`; Unihan: `kVietnamese=tam` | Corrected Hán-Việt from `Ba` to `Tam`; added `meaningVi=ba`, `meaningViDisplay=Tam (ba)`, normalized search fields. |
| `漢` | KANJIDIC2: `vietnam=Hán`, meanings `Sino-`, `China`; Unihan: `kVietnamese=hán` | Added natural Vietnamese meaning `chữ Hán; Trung Hoa` and display `Hán (chữ Hán; Trung Hoa)`. |
| `雪` | KANJIDIC2: `vietnam=Tuyết`, meaning `snow`; Unihan: `kDefinition=snow; wipe away shame, avenge` | Added `meaningVi=tuyết`, display `Tuyết (tuyết)`, and search text. |

Tagging: changed these four edited entries from `vi-human-approved` to `vi-source-verified`, because this batch was source-verified by Codex, not newly human-approved.

## Kanji N4 Related-Kanji Completeness Batch

Method: filled empty `relatedKanji` lists from visible decomposition components when present, plus obvious semantic or visual neighbors. No readings/meanings were changed in this batch.

| Item | Related set added | Rationale |
|---|---|---|
| `色` | `青`, `赤`, `白`, `黒` | Color group. |
| `予` | `定`, `約`, `先` | Prediction/preparation/time-planning neighbors. |
| `静` | `青`, `争`, `清`, `情` | Component `青` + `争`; common `青` family. |
| `危` | `厄`, `険`, `急` | Danger/risk/urgency semantic group. |
| `以` | `似`, `使`, `用` | Function/usage family for "by means of". |
| `文` | `字`, `語`, `読`, `書` | Writing/language group. |
| `死` | `亡`, `生`, `残`, `殺` | Death/life/remain/kill semantic group. |
| `飛` | `鳥`, `羽`, `風`, `機` | Flying/wing/wind/airplane group. |
| `包` | `抱`, `胞`, `砲`, `飽` | `包` phonetic/shape family. |
| `乾` | `干`, `早`, `水`, `雨` | Dryness contrast and visual/meaning neighbors. |
| `疑` | `匕`, `矢`, `疋`, `問` | Decomposition components + question/doubt neighbor. |
| `配` | `酉`, `己`, `酒`, `送` | Components plus distribution/send neighbor. |
| `参` | `大`, `加`, `産`, `形` | Components/shape plus participation/addition neighbor. |

## Kanji N3 Lesson 02 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Hán-Việt readings and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese` where present and `kDefinition` meaning cross-checks.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_02.json` for learner-facing Vietnamese wording and related-kanji grouping.

| Item | Sources | Change |
|---|---|---|
| `将` | KANJIDIC2 `Thương, Tương, Tướng`; Unihan `will, going to, future; general`; N3 theme uses `将来` | Added primary Hán-Việt `Tướng`, display `Tướng (tướng; tương lai)`, search text, and planning/future related kanji. |
| `来` | Existing Hán-Việt `Lai`; KANJIDIC2 `Lai...`; Unihan `come, coming; return` | Kept meaning/readings; added source-verified related kanji. |
| `目` | Existing Hán-Việt `Mục`; KANJIDIC2 `Mục`; Unihan `eye; division, topic` | Kept meaning/readings; added source-verified related kanji for eye/target usage. |
| `標` | KANJIDIC2 `Tiêu, Phiêu`; Unihan `mark, symbol, label, sign; standard` | Added Hán-Việt `Tiêu`, rewrote Vietnamese display to `mốc; dấu hiệu; mục tiêu`, and added target/standard related kanji. |
| `計` | KANJIDIC2 `Kế, Kê`; Unihan `plan, plot; stratagem; scheme` | Added Hán-Việt `Kế`, rewrote Vietnamese display to `kế hoạch; tính toán`, and added plan/calculation related kanji. |
| `画` | KANJIDIC2 `Hoạch`; Unihan `painting, picture, drawing; to draw`; lesson context `計画` | Added Hán-Việt `Hoạch/Họa` to cover planning and drawing senses; updated display/search and related kanji. |
| `努` | KANJIDIC2 `Nỗ`; Unihan `to exert, strive, make an effort` | Added Hán-Việt `Nỗ`, rewrote Vietnamese display to `nỗ lực; cố gắng`, and added effort-related kanji. |
| `力` | Existing Hán-Việt `Lực`; KANJIDIC2 `Lực`; Unihan `power, capability, influence` | Kept meaning/readings; added force/effort related kanji. |

Tagging: added entry-level `vi-source-verified` to the eight edited lesson-02 entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 03 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Hán-Việt readings, Japanese readings, stroke count, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_03.json`, especially the `節約`, `無駄`, `再利用`, `資源`, and `環境` resource-use cluster.

| Item | Sources | Change |
|---|---|---|
| `節` | KANJIDIC2 `Tiết/Tiệt`, meanings `node`, `season`, `period`, `joint`; Unihan `kVietnamese=tiết`, `kDefinition=knot, node, joint; section` | Added primary Hán-Việt `Tiết`, rewrote display to `Tiết (tiết; đốt; giai đoạn)`, normalized search text, and linked season/section/planning neighbors. |
| `約` | KANJIDIC2 `Ước`, meanings `promise`, `approximately`, `shrink`; Unihan `kVietnamese=ước`, `kDefinition=treaty, agreement, covenant` | Kept Hán-Việt `Ước`; rewrote Vietnamese display to `ước hẹn; khoảng; rút gọn`, matching `約束`, `約`, and shrink senses. |
| `無` | KANJIDIC2 `Vô/Mô`, meanings `nothingness`, `none`, `not`; Unihan `kVietnamese=vô`, `kDefinition=negative, no, not; lack` | Added primary Hán-Việt `Vô`, display `Vô (không; không có)`, and related negative/absence kanji. |
| `駄` | KANJIDIC2 `Đà`, meanings `burdensome`, `pack horse`, `trivial`, `worthless`; Unihan `kDefinition=a horse load; a pack-horse`; local context `無駄` | Capitalized Hán-Việt `Đà`; rewrote learner meaning to `vô ích; phí phạm`, which fits the N3 resource-use lesson context. |
| `再` | KANJIDIC2 `Tái`, meanings `again`, `twice`, `second time`; Unihan `kVietnamese=tái`, `kDefinition=again, twice, re-` | Added Hán-Việt `Tái`, display `Tái (lại; lần nữa)`, and reuse/repetition neighbors. |
| `資` | KANJIDIC2 `Tư`, meanings `assets`, `resources`, `capital`, `funds`, `data`; Unihan `kDefinition=property; wealth; capital` | Capitalized Hán-Việt `Tư`; rewrote display to `tài nguyên; vốn; tư liệu`, fitting `資源` and `資料` senses. |
| `源` | KANJIDIC2 `Nguyên`, meanings `source`, `origin`; Unihan `kVietnamese=nguồn`, `kDefinition=spring; source, head` | Added Hán-Việt `Nguyên`, display `Nguyên (nguồn; nguồn gốc)`, and source/water/origin neighbors. |
| `環` | KANJIDIC2 `Hoàn`, meanings `ring`, `circle`, `loop`; Unihan `kDefinition=jade ring or bracelet; ring`; local context `環境` | Added Hán-Việt `Hoàn`, display `Hoàn (vòng; môi trường)`, and environment/ring/circle neighbors. |

Tagging: replaced the lesson-03 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 04 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Hán-Việt readings, Japanese readings, stroke count, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_04.json`, especially the `留学`, `文化`, `言語`, and `交流` abroad-study cluster.

| Item | Sources | Change |
|---|---|---|
| `留` | KANJIDIC2 `Lưu`, meanings `detain`, `fasten`, `halt`, `stop`; Unihan `kVietnamese=lưu`, `kDefinition=stop, halt; stay, detain, keep` | Kept Hán-Việt `Lưu`; rewrote display to `ở lại; lưu giữ`, normalized search, and added study/stay/stop related kanji. |
| `学` | KANJIDIC2 `Học`, meanings `study`, `learning`, `science`; Unihan `kDefinition=learning, knowledge; school` | Kept Hán-Việt `Học`; expanded display to `học; việc học` and linked study/school/life neighbors. |
| `文` | KANJIDIC2 `Văn/Vấn`, meanings `sentence`, `literature`, `style`, `art`; Unihan `kVietnamese=văn`, `kDefinition=literature, culture, writing` | Kept primary Hán-Việt `Văn`; rewrote display to `văn hóa; chữ viết; văn chương`, fitting `文化` and language-learning context. |
| `化` | KANJIDIC2 `Hóa`, meanings `change`, `take the form of`, `-ization`; Unihan `kVietnamese=hoá`, `kDefinition=change, convert, reform; -ize` | Added Hán-Việt `Hóa`, display `Hóa (biến đổi; -hóa)`, search text, and culture/change related kanji. |
| `言` | KANJIDIC2 `Ngôn/Ngân`, meanings `say`, `word`; Unihan `kVietnamese=ngôn`, `kDefinition=words, speech; speak, say` | Added primary Hán-Việt `Ngôn`, display `Ngôn (lời nói; nói)`, and speech/language related kanji. |
| `語` | KANJIDIC2 `Ngữ/Ngứ`, meanings `word`, `speech`, `language`; Unihan `kVietnamese=ngữ`, `kDefinition=language, words; saying, expression` | Added primary Hán-Việt `Ngữ`, display `Ngữ (ngôn ngữ; từ ngữ; lời nói)`, and language/study related kanji. |
| `交` | KANJIDIC2 `Giao`, meanings `mingle`, `mixing`, `association`, `coming & going`; Unihan `kVietnamese=giao`, `kDefinition=mix; intersect; exchange, communicate` | Added Hán-Việt `Giao`, display `Giao (giao lưu; trao đổi; qua lại)`, and communication/exchange related kanji. |
| `流` | KANJIDIC2 `Lưu`, meanings `current`, `flow`; Unihan `kVietnamese=lưu`, `kDefinition=flow, circulate, drift; class` | Added Hán-Việt `Lưu`, display `Lưu (dòng chảy; lưu thông)`, and flow/exchange related kanji. |

Tagging: replaced the lesson-04 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 05 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Hán-Việt readings, Japanese readings, stroke count, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_05.json`, especially `就職`, `面接`, `給料`, and `責任`.

| Item | Sources | Change |
|---|---|---|
| `就` | KANJIDIC2 `Tựu`, meanings `settle`, `take position`, `study`; Unihan `kDefinition=just, simply; to come, go to; to approach` | Added Hán-Việt `Tựu`, rewrote display to `đảm nhận; vào vị trí`, and linked job/responsibility/study neighbors. |
| `職` | KANJIDIC2 `Chức`, meanings `post`, `employment`, `work`; Unihan `kVietnamese=chức`, `kDefinition=duty, profession; office, post` | Added Hán-Việt `Chức`, display `Chức (nghề nghiệp; chức vụ)`, and job-duty related kanji. |
| `面` | KANJIDIC2 `Diện`, meanings `mask`, `face`, `surface`; Unihan `kDefinition=face; surface; plane` | Capitalized Hán-Việt `Diện`, display `Diện (mặt; bề mặt)`, and interview/face/surface related kanji. |
| `接` | KANJIDIC2 `Tiếp`, meanings `touch`, `contact`, `adjoin`; Unihan `kVietnamese=tiếp`, `kDefinition=receive; continue; catch; connect` | Added Hán-Việt `Tiếp`, display `Tiếp (tiếp xúc; nối liền)`, and contact/connection related kanji. |
| `給` | KANJIDIC2 `Cấp`, meanings `salary`, `wage`, `grant`; Unihan `kVietnamese=cấp`, `kDefinition=give; by, for` | Added Hán-Việt `Cấp`, display `Cấp (lương; cấp phát; cung cấp)`, fitting `給料`. |
| `残` | KANJIDIC2 `Tàn`, meanings `remainder`, `leftover`, `balance`; Unihan `kDefinition=injure, spoil; oppress; broken` | Capitalized Hán-Việt `Tàn`, display `Tàn (còn lại; sót lại)`, and leftover/remain related kanji. |
| `責` | KANJIDIC2 `Trách/Trái`, meanings `blame`, `condemn`, `censure`; Unihan `kVietnamese=trách`, `kDefinition=one's responsibility, duty` | Added primary Hán-Việt `Trách`, display `Trách (trách nhiệm; trách cứ)`, fitting `責任`. |
| `任` | KANJIDIC2 `Nhâm/Nhậm`, meanings `responsibility`, `duty`, `entrust`; Unihan `kVietnamese=nhậm`, `kDefinition=trust to, rely on, appoint; duty` | Added Hán-Việt `Nhậm`, display `Nhậm (trách nhiệm; giao phó)`, and responsibility/duty related kanji. |

Tagging: replaced the lesson-05 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 06 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_06.json`, especially `注文`, `配送`, `返品`, and `評価`.

| Item | Sources | Change |
|---|---|---|
| `注` | KANJIDIC2 meanings `pour`, `concentrate on`, `notes`; Unihan `kVietnamese=chú`, `kDefinition=concentrate, focus, direct`; local context `注文` | Kept Hán-Việt `Chú`; rewrote learner display to `Chú (đặt hàng; chú ý; ghi chú)`, normalized search text, and linked order/note/question neighbors. |
| `文` | KANJIDIC2 meanings `sentence`, `literature`, `style`; Unihan `kVietnamese=văn`, `kDefinition=literature, culture, writing`; local context `注文` | Kept Hán-Việt `Văn`; rewrote display to `Văn (chữ viết; câu văn; văn chương)` and linked writing/language neighbors. |
| `配` | KANJIDIC2 meanings `distribute`, `spouse`, `rationing`; Unihan `kVietnamese=phối`, `kDefinition=match, pair; equal; blend`; local context `配送` | Kept Hán-Việt `Phối`; rewrote display to `Phối (phân phối; phân phát; sắp xếp)`, normalized search text, and linked delivery/goods neighbors. |
| `送` | KANJIDIC2 meanings `escort`, `send`; Unihan `kVietnamese=tống`, `kDefinition=see off, send off; dispatch, give`; local context `配送` | Kept Hán-Việt `Tống`; rewrote display to `Tống (gửi đi; đưa tiễn)` and linked delivery/return neighbors. |
| `返` | KANJIDIC2 meanings `return`, `answer`, `repay`; Unihan `kVietnamese=phản`, `kDefinition=return, revert to, restore`; local context `返品` | Added Hán-Việt `Phản`, display `Phản (trả lại; quay lại)`, search text, and return/answer related kanji. |
| `品` | KANJIDIC2 meanings `goods`, `refinement`, `article`; Unihan `kVietnamese=phẩm`, `kDefinition=article, product, commodity`; local context `返品` | Added Hán-Việt `Phẩm`, display `Phẩm (hàng hóa; sản phẩm; phẩm chất)`, search text, and product/value related kanji. |
| `評` | KANJIDIC2 meanings `evaluate`, `criticism`; Unihan `kVietnamese=bình`, `kDefinition=appraise, criticize, evaluate`; local context `評価` | Added Hán-Việt `Bình`, display `Bình (đánh giá; phê bình)`, search text, and review/opinion related kanji. |
| `価` | KANJIDIC2 meanings `value`, `price`; Unihan `kDefinition=price, value` for Japanese `価`; local context `評価` | Capitalized Hán-Việt `Giá`, normalized display to `Giá (giá; giá trị)`, search text, and value/price related kanji. |

Tagging: replaced the lesson-06 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 07 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_07.json`, especially `健康`, `睡眠`, `栄養`, and `治療`.

| Item | Sources | Change |
|---|---|---|
| `健` | KANJIDIC2 meanings `healthy`, `health`, `strength`; Unihan `kVietnamese=kiện`, `kDefinition=strong, robust, healthy` | Added Hán-Việt `Kiện`, display `Kiện (khỏe mạnh; sức khỏe)`, search text, and health/strength related kanji. |
| `康` | KANJIDIC2 meanings `ease`, `peace`; Unihan `kVietnamese=khang`, `kDefinition=peaceful, quiet; happy, healthy`; local context `健康` | Added Hán-Việt `Khang`, display `Khang (bình an; khỏe mạnh)`, search text, and health/peace related kanji. |
| `睡` | KANJIDIC2 meanings `drowsy`, `sleep`; Unihan `kDefinition=sleep, doze`; local context `睡眠` | Added Hán-Việt `Thụy`, display `Thụy (ngủ; buồn ngủ)`, search text, and sleep/rest related kanji. |
| `眠` | KANJIDIC2 meanings `sleep`, `sleepy`; Unihan `kVietnamese=miên`, `kDefinition=close eyes, sleep; hibernate`; local context `睡眠` | Kept Hán-Việt `Miên`; rewrote display to `Miên (ngủ; giấc ngủ)` and added sleep/rest related kanji. |
| `栄` | KANJIDIC2 meanings `flourish`, `prosperity`, `glory`; Unihan `kDefinition=glory, honor; flourish, prosper`; local context `栄養` | Added Hán-Việt `Vinh`, display `Vinh (phồn vinh; vinh quang; dinh dưỡng)`, search text, and nutrition/growth related kanji. |
| `養` | KANJIDIC2 meanings `foster`, `bring up`, `nurture`; Unihan `kVietnamese=dưỡng`, `kDefinition=raise, rear, bring up; support`; local context `栄養` | Added Hán-Việt `Dưỡng`, display `Dưỡng (nuôi dưỡng; chăm sóc)`, search text, and nutrition/care related kanji. |
| `治` | KANJIDIC2 meanings `cure`, `heal`, `rule`; Unihan `kVietnamese=trị`, `kDefinition=govern, regulate, administer`; local context `治療` | Added Hán-Việt `Trị`, display `Trị (chữa trị; cai trị)`, search text, and medicine/treatment related kanji. |
| `療` | KANJIDIC2 meanings `heal`, `cure`; Unihan `kVietnamese=liệu`, `kDefinition=be healed, cured, recover`; local context `治療` | Added Hán-Việt `Liệu`, display `Liệu (chữa lành; điều trị)`, search text, and medicine/treatment related kanji. |

Tagging: replaced the lesson-07 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 08 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_08.json`, especially `伝統`, `祭`, `季節`, `神社`, and `祖先`.

| Item | Sources | Change |
|---|---|---|
| `伝` | KANJIDIC2 meanings `transmit`, `communicate`, `tradition`; Unihan `kDefinition=summon; propagate, transmit`; local context `伝統` | Kept Hán-Việt `Truyền`; rewrote display to `Truyền (truyền đạt; truyền thống)`, normalized search text, and linked tradition/story neighbors. |
| `統` | KANJIDIC2 meanings `overall`, `ruling`, `governing`; Unihan `kVietnamese=thống`, `kDefinition=govern, command, control; unite`; local context `伝統` | Added Hán-Việt `Thống`, display `Thống (thống nhất; quản lý; hệ thống)`, search text, and governance/system related kanji. |
| `祭` | KANJIDIC2 meanings `ritual`, `offer prayers`, `celebrate`; Unihan `kVietnamese=tế`, `kDefinition=sacrifice to, worship`; local context seasonal festivals | Added Hán-Việt `Tế`, display `Tế (lễ hội; cúng tế)`, search text, and festival/ritual related kanji. |
| `季` | KANJIDIC2 meaning `seasons`; Unihan `kVietnamese=quí`, `kDefinition=quarter of year; season`; local context `季節` | Added Hán-Việt `Quý`, display `Quý (mùa; quý trong năm)`, search text, and season related kanji. |
| `節` | KANJIDIC2 meanings `season`, `period`, `joint`; Unihan `kVietnamese=tiết`, `kDefinition=knot, node, joint; section`; local context `季節` | Added Hán-Việt `Tiết`, display `Tiết (mùa; tiết; giai đoạn)`, search text, and time/season related kanji. |
| `神` | KANJIDIC2 meanings `gods`, `mind`, `soul`; Unihan `kVietnamese=thần`, `kDefinition=spirit, god, supernatural being`; local context `神社` | Added Hán-Việt `Thần`, display `Thần (thần linh; tinh thần)`, search text, and shrine/ritual related kanji. |
| `礼` | KANJIDIC2 meanings `salute`, `bow`, `ceremony`, `thanks`; Unihan `kVietnamese=lễ`, `kDefinition=social custom; manners; courtesy; rites` | Kept Hán-Việt `Lễ`; rewrote display to `Lễ (lễ nghi; lời cảm ơn)` and added ceremony/thanks related kanji. |
| `祖` | KANJIDIC2 meanings `ancestor`, `pioneer`, `founder`; Unihan `kDefinition=ancestor, forefather; grandfather`; local context ancestors/tradition | Capitalized Hán-Việt `Tổ`, display `Tổ (tổ tiên; người sáng lập)`, search text, and ancestor/tradition related kanji. |

Tagging: replaced the lesson-08 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 09 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_09.json`, especially `新聞`, `雑誌`, `放送`, `報道`, `記事`, and `論`.

| Item | Sources | Change |
|---|---|---|
| `新` | KANJIDIC2 `Tân`, meaning `new`; Unihan `kVietnamese=tân`, `kDefinition=new, recent, fresh, modern`; local context `新聞` | Kept Hán-Việt `Tân`; rewrote display to `Tân (mới; đổi mới)`, normalized search text, and linked media/news related kanji. |
| `聞` | KANJIDIC2 `Văn/Vấn/Vặn`, meanings `hear`, `ask`, `listen`; Unihan `kDefinition=hear; smell; make known; news`; local context `新聞` | Kept primary Hán-Việt `Văn`; rewrote display to `Văn (nghe; hỏi; tin tức)`, normalized search text, and linked news/record related kanji. |
| `雑` | KANJIDIC2 `Tạp`, meaning `miscellaneous`; Unihan `kDefinition=mixed, blended; mix, mingle`; local context `雑誌` | Capitalized Hán-Việt `Tạp`; rewrote display to `Tạp (tạp; hỗn hợp; linh tinh)`, normalized search text, and linked magazine/news related kanji. |
| `誌` | KANJIDIC2 `Chí`, meanings `document`, `records`; Unihan `kVietnamese=chí`, `kDefinition=write down; record; magazine`; local context `雑誌` | Added Hán-Việt `Chí`, display `Chí (tạp chí; ghi chép)`, search text, and related record/news kanji. |
| `放` | KANJIDIC2 `Phóng/Phỏng`, meanings `set free`, `release`, `emit`; Unihan `kVietnamese=phóng`, `kDefinition=put, release, free, liberate`; local context `放送` | Added primary Hán-Việt `Phóng`, display `Phóng (phát ra; thả; phóng thích)`, search text, and broadcast/news related kanji. |
| `報` | KANJIDIC2 `Báo`, meanings `report`, `news`, `reward`; Unihan `kVietnamese=báo`, `kDefinition=report, tell, announce`; local context `報道` | Added Hán-Việt `Báo`, display `Báo (báo cáo; tin tức; báo đáp)`, search text, and report/news related kanji. |
| `記` | KANJIDIC2 `Kí`, meanings `scribe`, `account`, `narrative`; Unihan `kVietnamese=kí`, `kDefinition=record; keep in mind, remember`; local context `記事` | Added Hán-Việt `Kí`, display `Kí (ghi chép; bài viết)`, search text, and record/writing related kanji. |
| `論` | KANJIDIC2 `Luận/Luân`, meanings `argument`, `discourse`; Unihan `kVietnamese=luận`, `kDefinition=debate; discuss; discourse`; local context media/opinion | Added primary Hán-Việt `Luận`, display `Luận (bàn luận; lập luận)`, search text, and discussion/writing related kanji. |

Tagging: replaced the lesson-09 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 10 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_10.json`, especially `旅行`, `観光`, `交通`, `予約`, `宿泊`, and travel/transport usage.

| Item | Sources | Change |
|---|---|---|
| `旅` | KANJIDIC2 `Lữ`, meanings `trip`, `travel`; Unihan `kVietnamese=lữ`, `kDefinition=trip, journey; travel`; local context travel | Kept Hán-Việt `Lữ`; rewrote display to `Lữ (du lịch; chuyến đi)`, normalized search text, and linked travel/transport related kanji. |
| `観` | KANJIDIC2 `Quan`, meanings `outlook`, `look`, `view`; Unihan `kDefinition=see, observe, view; appearance`; local context `観光`/travel | Added Hán-Việt `Quan`, display `Quan (xem; quan sát; quan điểm)`, search text, and view/sightseeing related kanji. |
| `交` | KANJIDIC2 `Giao`, meanings `mingle`, `association`, `coming & going`; Unihan `kVietnamese=giao`, `kDefinition=mix; intersect; exchange, communicate`; local context `交通` | Added Hán-Việt `Giao`, display `Giao (giao thông; giao nhau; trao đổi)`, search text, and transport/exchange related kanji. |
| `通` | KANJIDIC2 `Thông`, meanings `traffic`, `pass through`, `commute`; Unihan `kVietnamese=thông`, `kDefinition=pass through; common; communicate`; local context `交通` | Kept Hán-Việt `Thông`; rewrote display to `Thông (đi qua; giao thông; thông suốt)`, normalized search text, and linked transport/path related kanji. |
| `予` | KANJIDIC2 lists `Dư/Dữ`, meanings `beforehand`, `previous`; Unihan `kVietnamese=nhừ`; local Japanese compound context maps learner-facing `予` to `Dự` in `予約`/`予定` | Kept the existing pedagogic Hán-Việt `Dự` for Japanese compounds, rewrote display to `Dự (trước; dự tính; chuẩn bị)`, and documented the source mismatch instead of silently changing it. |
| `約` | KANJIDIC2 `Ước`, meanings `promise`, `approximately`, `shrink`; Unihan `kVietnamese=ước`, `kDefinition=treaty, agreement, covenant`; local context `予約` | Kept Hán-Việt `Ước`; rewrote display to `Ước (hẹn; khoảng; rút gọn)` and linked reservation/time related kanji. |
| `宿` | KANJIDIC2 `Túc/Tú`, meanings `inn`, `lodging`, `dwell`; Unihan `kVietnamese=túc`, `kDefinition=stop, rest, lodge, stay overnight`; local context lodging | Added primary Hán-Việt `Túc`, display `Túc (nhà trọ; nghỉ lại; chỗ ở)`, search text, and lodging/travel related kanji. |
| `泊` | KANJIDIC2 `Bạc/Phách`, meanings `overnight stay`, `put up at`, `ride at anchor`; Unihan `kVietnamese=bạc`, `kDefinition=anchor vessel; lie at anchor`; local context lodging | Added primary Hán-Việt `Bạc`, display `Bạc (nghỉ qua đêm; lưu trú; neo đậu)`, search text, and lodging/harbor related kanji. |

Tagging: replaced the lesson-10 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 11 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_11.json`, especially `地震`, `災害`, `避難`, `洪水`, `津波`, and warning/disaster usage.

| Item | Sources | Change |
|---|---|---|
| `震` | KANJIDIC2 `Chấn`, meanings `quake`, `shake`, `tremble`; Unihan `kDefinition=shake, quake, tremor`; local context earthquake/disaster | Capitalized Hán-Việt `Chấn`; rewrote display to `Chấn (rung chấn; động đất)`, normalized search text, and linked disaster/earthquake related kanji. |
| `災` | KANJIDIC2 `Tai`, meanings `disaster`, `calamity`; Unihan `kVietnamese=tai`, `kDefinition=calamity, disaster, catastrophe`; local context `災害` | Added Hán-Việt `Tai`, display `Tai (thiên tai; tai họa)`, search text, and disaster/harm related kanji. |
| `害` | KANJIDIC2 `Hại/Hạt`, meanings `harm`, `injury`; Unihan `kVietnamese=hại`, `kDefinition=injure, harm; destroy, kill`; local context `災害` | Added primary Hán-Việt `Hại`, display `Hại (thiệt hại; gây hại)`, search text, and harm/prevention related kanji. |
| `避` | KANJIDIC2 `Tị`, meanings `evade`, `avoid`, `avert`; Unihan `kVietnamese=tị`, `kDefinition=avoid; turn aside; escape; hide`; local context `避難` | Added Hán-Việt `Tị`, display `Tị (tránh; né; lánh)`, search text, and evacuation/safety related kanji. |
| `難` | KANJIDIC2 `Nan/Nạn`, meanings `difficult`, `trouble`, `accident`; Unihan `kVietnamese=nan`, `kDefinition=difficult, arduous, hard`; local context `避難` | Added primary disaster-context Hán-Việt `Nạn`, display `Nạn (khó khăn; tai nạn; hiểm nạn)`, search text, and disaster/difficulty related kanji. |
| `洪` | KANJIDIC2 `Hồng`, meanings `deluge`, `flood`, `vast`; Unihan `kVietnamese=hòng hồng`, `kDefinition=vast, immense; flood, deluge`; local context flood | Added Hán-Việt `Hồng`, display `Hồng (lũ lớn; nước lớn; mênh mông)`, search text, and water/flood related kanji. |
| `津` | KANJIDIC2 `Tân`, meanings `haven`, `port`, `harbor`; Unihan `kDefinition=ferry; saliva; ford`; local context `津波` | Capitalized Hán-Việt `Tân`; rewrote display to `Tân (bến cảng; bến đò)`, search text, and port/sea related kanji. |
| `警` | KANJIDIC2 `Cảnh`, meanings `admonish`, `commandment`; Unihan `kDefinition=guard, watch; alert, alarm`; local context warning/safety | Added Hán-Việt `Cảnh`, display `Cảnh (cảnh báo; cảnh giác)`, search text, and warning/prevention related kanji. |

Tagging: replaced the lesson-11 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 12 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_12.json`, especially `芸術`, `演劇`, `鑑賞`, `演奏`, and `撮影`.

| Item | Sources | Change |
|---|---|---|
| `芸` | KANJIDIC2 lists `Vân`, meanings `technique`, `art`, `craft`; Unihan `kDefinition=art, talent, ability, craft, technique`; local Japanese `芸術` context maps learner-facing `芸` to `Nghệ` | Added pedagogic Hán-Việt `Nghệ`, display `Nghệ (nghệ thuật; tài nghệ)`, and documented the Japanese-shinjitai source mismatch instead of silently using `Vân`. |
| `術` | KANJIDIC2 `Thuật`, meanings `art`, `technique`, `skill`; Unihan `kVietnamese=thuật`, `kDefinition=art, skill; method, technique`; local context `芸術` | Added Hán-Việt `Thuật`, display `Thuật (kỹ thuật; phương pháp; nghệ thuật)`, search text, and art/skill related kanji. |
| `演` | KANJIDIC2 `Diễn`, meanings `performance`, `act`, `stage`; Unihan `kVietnamese=diễn`, `kDefinition=perform, put on; exercise`; local context performance | Added Hán-Việt `Diễn`, display `Diễn (biểu diễn; trình diễn; diễn xuất)`, search text, and performance/theater related kanji. |
| `劇` | KANJIDIC2 `Kịch`, meanings `drama`, `play`; Unihan `kVietnamese=kịch`, `kDefinition=theatrical plays, opera, drama`; local context `演劇` | Added Hán-Việt `Kịch`, display `Kịch (kịch; sân khấu; vở diễn)`, search text, and theater/film related kanji. |
| `鑑` | KANJIDIC2 `Giám`, meanings `specimen`, `take warning from`, `learn from`; Unihan `kDefinition=mirror, looking glass; reflect`; local context `鑑賞` | Added Hán-Việt `Giám`, display `Giám (xem xét; thưởng thức; soi chiếu)`, search text, and appreciation/viewing related kanji. |
| `賞` | KANJIDIC2 `Thưởng`, meanings `prize`, `reward`, `praise`; Unihan `kVietnamese=thưởng`, `kDefinition=reward, grant, bestow; appreciate`; local context `鑑賞` | Added Hán-Việt `Thưởng`, display `Thưởng (giải thưởng; khen thưởng; thưởng thức)`, search text, and art/appreciation related kanji. |
| `奏` | KANJIDIC2 `Tấu`, meanings `play music`, `speak to a ruler`; Unihan `kVietnamese=tấu`, `kDefinition=memorialize emperor; report`; local context `演奏` | Added Hán-Việt `Tấu`, display `Tấu (tấu nhạc; trình tấu)`, search text, and music/performance related kanji. |
| `撮` | KANJIDIC2 `Toát`, meanings `snapshot`, `take pictures`; Unihan `kVietnamese=toát`, `kDefinition=little bit, small amount, pinch`; local context photography/filming | Added Hán-Việt `Toát`, display `Toát (chụp ảnh; quay phim; nắm lấy)`, search text, and image/recording related kanji. |

Tagging: replaced the lesson-12 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 13 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_13.json`, especially education/school-life compounds such as `教育`, `課題`, `成績`, `出席`, `卒業`, and `指導`.

| Item | Sources | Change |
|---|---|---|
| `教` | KANJIDIC2 `Giáo`, meanings `teach`, `faith`, `doctrine`; Unihan `kVietnamese=giáo`, `kDefinition=teach, class`; local context education | Kept Hán-Việt `Giáo`; rewrote display to `Giáo (dạy; giáo dục; giáo lý)`, normalized search text, and linked education related kanji. |
| `育` | KANJIDIC2 `Dục`, meanings `bring up`, `grow up`, `raise`; Unihan `kVietnamese=dục`, `kDefinition=produce, give birth to; educate`; local context `教育` | Kept Hán-Việt `Dục`; rewrote display to `Dục (nuôi dưỡng; giáo dục; lớn lên)`, normalized search text, and linked growth/education related kanji. |
| `課` | KANJIDIC2 `Khóa`, meanings `chapter`, `lesson`, `section`; Unihan `kVietnamese=khoá`, `kDefinition=lesson; course; classwork`; local context `課題` | Added Hán-Việt `Khóa`, display `Khóa (bài học; khóa học; phần bài)`, search text, and course/lesson related kanji. |
| `題` | KANJIDIC2 `Đề`, meanings `topic`, `subject`; Unihan `kDefinition=forehead; title, headline; theme`; local context `課題` | Capitalized Hán-Việt `Đề`; rewrote display to `Đề (chủ đề; đề bài; tiêu đề)`, normalized search text, and linked topic/question related kanji. |
| `績` | KANJIDIC2 `Tích`, meanings `exploits`, `achievements`; Unihan `kVietnamese=tích`, `kDefinition=spin; achievements`; local context `成績` | Added Hán-Việt `Tích`, display `Tích (thành tích; công lao; kết quả)`, search text, and achievement/evaluation related kanji. |
| `席` | KANJIDIC2 `Tịch`, meanings `seat`, `mat`, `occasion`, `place`; Unihan `kDefinition=seat; mat; take seat; banquet`; local context attendance/seat words | Capitalized Hán-Việt `Tịch`; rewrote display to `Tịch (chỗ ngồi; phiên; buổi)`, normalized search text, and linked attendance/place related kanji. |
| `卒` | KANJIDIC2 `Tốt/Tuất/Thốt`, meanings `graduate`, `soldier`, `private`, `die`; Unihan `kVietnamese=tốt`, `kDefinition=soldier; servant; at last, finally`; local context `卒業` | Added primary learner-facing Hán-Việt `Tốt`, display `Tốt (tốt nghiệp; binh lính; kết thúc)`, search text, and graduation/school related kanji. |
| `導` | KANJIDIC2 `Đạo`, meanings `guidance`, `leading`, `conduct`; Unihan `kVietnamese=đạo`, `kDefinition=direct, guide, lead, conduct`; local context `指導` | Added Hán-Việt `Đạo`, display `Đạo (dẫn dắt; hướng dẫn; chỉ đạo)`, search text, and guidance/teaching related kanji. |

Tagging: replaced the lesson-13 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 14 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_14.json`, especially family/relationship compounds such as `家族`, `親戚`, `夫婦`, `子育て`, `結婚`, `離婚`, `援助`, and `信頼`.

| Item | Sources | Change |
|---|---|---|
| `族` | KANJIDIC2 `Tộc`, meanings `tribe`, `family`; Unihan `kVietnamese=tộc`, `kDefinition=a family clan, ethnic group, tribe`; local context `家族` | Added Hán-Việt `Tộc`, display `Tộc (gia tộc; dân tộc; dòng họ)`, search text, and family/clan related kanji. |
| `戚` | KANJIDIC2 `Thích`, meanings `grieve`, `relatives`; Unihan `kVietnamese=thích`, `kDefinition=relative; be related to; sad`; local context `親戚` | Added Hán-Việt `Thích`, display `Thích (họ hàng; thân thích; buồn đau)`, search text, and kinship related kanji. |
| `婦` | KANJIDIC2 `Phụ`, meanings `lady`, `woman`, `wife`, `bride`; Unihan `kVietnamese=phụ`, `kDefinition=married women; woman; wife`; local context `夫婦` | Added Hán-Việt `Phụ`, display `Phụ (phụ nữ; vợ; cô dâu)`, search text, and spouse/woman related kanji. |
| `育` | KANJIDIC2 `Dục`, meanings `bring up`, `grow up`, `raise`; Unihan `kVietnamese=dục`, `kDefinition=produce, give birth to; educate`; local context child-raising | Kept Hán-Việt `Dục`; rewrote display to `Dục (nuôi dưỡng; giáo dục; lớn lên)`, normalized search text, and linked child/education related kanji. |
| `結` | KANJIDIC2 `Kết`, meanings `tie`, `bind`, `join`, `organize`; Unihan `kVietnamese=kết`, `kDefinition=knot, tie; join, connect`; local context `結婚` | Added Hán-Việt `Kết`, display `Kết (kết nối; thắt buộc; kết hôn)`, search text, and marriage/connection related kanji. |
| `離` | KANJIDIC2 `Ly`, meanings `detach`, `separation`, `disjoin`; Unihan `kVietnamese=li`, `kDefinition=leave, depart; separate`; local context `離婚` | Added learner-facing Hán-Việt `Ly`, display `Ly (rời xa; tách ra; ly hôn)`, search text, and separation/divorce related kanji. |
| `援` | KANJIDIC2 `Viên/Viện`, meanings `abet`, `help`, `save`; Unihan `kVietnamese=viện`, `kDefinition=aid, assist; lead; cite`; local context `援助` | Added primary learner-facing Hán-Việt `Viện`, display `Viện (hỗ trợ; cứu giúp; tiếp viện)`, search text, and support related kanji. |
| `頼` | KANJIDIC2 `Lại/Trái`, meanings `trust`, `request`; Unihan `kDefinition=rely, depend on; accuse falsely`; local context `信頼`/`依頼` | Kept Hán-Việt `Lại`; rewrote display to `Lại (nhờ cậy; tin cậy; yêu cầu)`, normalized search text, and linked trust/request related kanji. |

Tagging: replaced the lesson-14 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 15 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_15.json`, especially housing/neighborhood compounds such as `住宅`, `建築`, `家賃`, `賃貸`, `設備`, `準備`, and `住民`.

| Item | Sources | Change |
|---|---|---|
| `住` | KANJIDIC2 lists `Trụ`, meanings `dwell`, `reside`, `live`; Unihan `kVietnamese=trú`, `kDefinition=reside, live at, dwell`; local context `住民`/`住宅` | Kept learner-facing Hán-Việt `Trú` for `cư trú`, rewrote display to `Trú (sống ở; cư trú; nơi ở)`, normalized search text, and linked housing/resident related kanji. |
| `宅` | KANJIDIC2 `Trạch`, meanings `home`, `house`; Unihan `kDefinition=residence, dwelling, home`; local context housing | Kept Hán-Việt `Trạch`; rewrote display to `Trạch (nhà ở; nơi ở; tư gia)`, normalized search text, and linked home/building related kanji. |
| `築` | KANJIDIC2 `Trúc`, meanings `fabricate`, `build`, `construct`; Unihan `kVietnamese=trốc`, `kDefinition=build, erect; building`; local context `建築` | Added learner-facing Hán-Việt `Trúc`, display `Trúc (xây dựng; kiến tạo; xây đắp)`, search text, and building/construction related kanji. |
| `賃` | KANJIDIC2 `Nhẫm`, meanings `fare`, `fee`, `hire`, `rent`, `wages`; Unihan `kDefinition=rent, hire; hired person`; local context `家賃`/`賃貸` | Capitalized Hán-Việt `Nhẫm`; rewrote display to `Nhẫm (tiền thuê; phí thuê; công thuê)`, normalized search text, and linked rent/lending related kanji. |
| `貸` | KANJIDIC2 `Thải/Thắc`, meaning `lend`; Unihan `kDefinition=lend; borrow; pardon`; local context `賃貸`/lending | Kept primary Hán-Việt `Thải`; rewrote display to `Thải (cho vay; cho mượn; cho thuê)`, normalized search text, and linked rent/return related kanji. |
| `設` | KANJIDIC2 `Thiết`, meanings `establishment`, `provision`, `prepare`; Unihan `kVietnamese=thết`, `kDefinition=build; establish; display`; local context `設備` | Added Hán-Việt `Thiết`, display `Thiết (thiết lập; xây dựng; bố trí)`, search text, and equipment/building related kanji. |
| `備` | KANJIDIC2 `Bị`, meanings `equip`, `provision`, `preparation`; Unihan `kVietnamese=bị`, `kDefinition=prepare, ready, perfect`; local context `設備`/`準備` | Added Hán-Việt `Bị`, display `Bị (chuẩn bị; trang bị; dự phòng)`, search text, and preparation/equipment related kanji. |
| `民` | KANJIDIC2 `Dân`, meanings `people`, `nation`, `subjects`; Unihan `kVietnamese=dân`, `kDefinition=people, subjects, citizens`; local context `住民` | Added Hán-Việt `Dân`, display `Dân (người dân; dân chúng; quốc dân)`, search text, and resident/citizen related kanji. |

Tagging: replaced the lesson-15 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 16 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_16.json`, especially sports/competition compounds such as `試合`, `勝負`, `選手`, `練習`, `優勝`, `決勝`, and `審査`.

| Item | Sources | Change |
|---|---|---|
| `試` | KANJIDIC2 `Thí`, meanings `test`, `try`, `attempt`, `experiment`; Unihan `kVietnamese=thí`, `kDefinition=test, try, experiment`; local context `試合` | Added Hán-Việt `Thí`, display `Thí (thử; kiểm tra; thi đấu)`, search text, and test/match related kanji. |
| `勝` | KANJIDIC2 `Thắng/Thăng`, meanings `victory`, `win`, `prevail`, `excel`; Unihan `kVietnamese=thắng`, `kDefinition=victory; excel, be better than`; local context win/competition | Added learner-facing Hán-Việt `Thắng`, display `Thắng (thắng lợi; chiến thắng; vượt trội)`, search text, and competition related kanji. |
| `負` | KANJIDIC2 `Phụ`, meanings `defeat`, `negative`, `bear`, `owe`, `assume a responsibility`; Unihan `kVietnamese=phụ`, `kDefinition=load, burden; carry, bear`; local context `勝負`/losing | Added Hán-Việt `Phụ`, display `Phụ (thua; mang; chịu trách nhiệm)`, search text, and win/loss/responsibility related kanji. |
| `選` | KANJIDIC2 `Tuyển/Tuyến`, meanings `elect`, `select`, `choose`, `prefer`; Unihan `kVietnamese=tuyển`, `kDefinition=choose, select; elect; election`; local context `選手` | Kept Hán-Việt `Tuyển`; rewrote display to `Tuyển (lựa chọn; tuyển chọn; bầu chọn)`, normalized search text, and linked selection/competition related kanji. |
| `練` | KANJIDIC2 `Luyện`, meanings `practice`, `train`, `drill`, `polish`, `refine`; Unihan `kVietnamese=luyện`, `kDefinition=practice, drill, exercise, train`; local context `練習` | Added Hán-Việt `Luyện`, display `Luyện (luyện tập; rèn luyện; trau dồi)`, search text, and practice/skill related kanji. |
| `優` | KANJIDIC2 `Ưu`, meanings `tenderness`, `excel`, `surpass`, `superiority`, `gentleness`; Unihan `kDefinition=superior, excellent; actor`; local context `優勝` | Capitalized Hán-Việt `Ưu`; rewrote display to `Ưu (ưu tú; dịu dàng; vượt trội)`, normalized search text, and linked excellence/kindness related kanji. |
| `決` | KANJIDIC2 `Quyết`, meanings `decide`, `fix`, `agree upon`, `appoint`; Unihan `kVietnamese=quyết`, `kDefinition=decide, determine, judge`; local context `決勝` | Kept Hán-Việt `Quyết`; rewrote display to `Quyết (quyết định; dứt khoát; phân định)`, normalized search text, and linked decision/result related kanji. |
| `審` | KANJIDIC2 `Thẩm`, meanings `hearing`, `judge`, `trial`; Unihan `kVietnamese=thẩm`, `kDefinition=examine, investigate; judge`; local context judging/review | Added Hán-Việt `Thẩm`, display `Thẩm (xét xử; thẩm tra; đánh giá)`, search text, and judging/evaluation related kanji. |

Tagging: replaced the lesson-16 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 17 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, and English definitions.
- Unihan local cache `%TEMP%/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available; Japanese shinjitai `験`/`発` lack direct `kVietnamese`, so the traditional forms `驗`/`發` were checked for `nghiệm`/`phát`.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_17.json`, especially science/technology compounds such as `科学`, `技術`, `発明`, `実験`, `開発`, and `機械`.

| Item | Sources | Change |
|---|---|---|
| `科` | KANJIDIC2 meanings `department`, `course`, `section`; Unihan `kVietnamese=khoa`; local context `科学` | Kept Hán-Việt `Khoa`; rewrote display to `Khoa (khoa; ngành học; môn học)`, normalized search text, and linked science/course related kanji. |
| `技` | KANJIDIC2 meanings `skill`, `art`, `craft`, `ability`; Unihan `kVietnamese=kĩ`; local context `技術` | Added learner-facing Hán-Việt `Kỹ`, display `Kỹ (kỹ năng; kỹ thuật; tài nghệ)`, search text, and skill/technology related kanji. |
| `明` | KANJIDIC2 meanings `bright`, `light`; Unihan `kVietnamese=minh`; local context `発明` | Kept Hán-Việt `Minh`; rewrote display to `Minh (sáng; rõ ràng; sáng tỏ)`, normalized search text, and linked light/clarity related kanji. |
| `験` | KANJIDIC2 meanings `verification`, `effect`, `testing`; Unihan direct entry has no `kVietnamese`, traditional `驗` has `nghiệm`; local context `実験` | Capitalized Hán-Việt `Nghiệm`, display `Nghiệm (kiểm nghiệm; thử nghiệm; chứng nghiệm)`, search text, and test/verification related kanji. |
| `開` | KANJIDIC2 meanings `open`, `unfold`, `unseal`; Unihan `kVietnamese=khai`; local context `開発` | Kept Hán-Việt `Khai`; rewrote display to `Khai (mở; khai mở; bắt đầu)`, normalized search text, and linked open/start related kanji. |
| `発` | KANJIDIC2 meanings `departure`, `discharge`, `publish`, `emit`; Unihan direct entry has no `kVietnamese`, traditional `發` has `phát`; local context `開発`/`発明` | Kept Hán-Việt `Phát`; rewrote display to `Phát (phát ra; khởi hành; phát triển)`, normalized search text, and linked invention/development related kanji. |
| `機` | KANJIDIC2 meanings `loom`, `mechanism`, `machine`, `opportunity`; Unihan `kVietnamese=cơ`; local context `機械` | Kept Hán-Việt `Cơ`; rewrote display to `Cơ (máy móc; cơ chế; cơ hội)`, normalized search text, and linked machine/mechanism related kanji. |
| `械` | KANJIDIC2 meanings `contraption`, `fetter`, `machine`, `instrument`; Unihan `kVietnamese=giới`; local context `機械` | Added Hán-Việt `Giới`, display `Giới (máy móc; dụng cụ; gông cùm)`, search text, and machine/tool related kanji. |

Tagging: replaced the lesson-17 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 18 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_18.json`, especially law/rules/society compounds such as `法律`, `規則`, `犯罪`, `裁判`, and `制度`.

| Item | Sources | Change |
|---|---|---|
| `法` | KANJIDIC2 `Pháp`, meanings `method`, `law`, `rule`; Unihan `kVietnamese=pháp`, `kDefinition=law, rule, regulation, statute` | Rewrote display to `Pháp (luật pháp; phương pháp; nguyên tắc)`, normalized search text, and linked law/rule related kanji. |
| `律` | KANJIDIC2 `Luật`, meanings `rhythm`, `law`, `regulation`; Unihan `kVietnamese=luật`, `kDefinition=statute, principle, regulation`; local context `法律` | Added Hán-Việt `Luật`, display `Luật (luật lệ; quy tắc; nhịp điệu)`, search text, and rule-system related kanji. |
| `規` | KANJIDIC2 `Quy`, meanings `standard`, `measure`; Unihan `kVietnamese=qui`, `kDefinition=rules, regulations, customs, law`; local context `規則` | Added learner-facing Hán-Việt `Quy`, display `Quy (quy tắc; chuẩn mực; phép đo)`, search text, and regulation related kanji. |
| `則` | KANJIDIC2 `Tắc`, meanings `rule`, `law`, `follow`; Unihan `kVietnamese=tắc`, `kDefinition=rule, law, regulation`; local context `規則` | Added Hán-Việt `Tắc`, display `Tắc (quy tắc; noi theo; nguyên tắc)`, search text, and rule related kanji. |
| `犯` | KANJIDIC2 `Phạm`, meanings `crime`, `sin`, `offense`; Unihan `kVietnamese=phạm`, `kDefinition=commit crime, violate; criminal`; local context `犯罪` | Added Hán-Việt `Phạm`, display `Phạm (phạm tội; vi phạm; người phạm tội)`, search text, and crime/legal related kanji. |
| `罪` | KANJIDIC2 `Tội`, meanings `guilt`, `sin`, `crime`; Unihan `kVietnamese=tội`, `kDefinition=crime, sin, vice; evil`; local context `犯罪` | Added Hán-Việt `Tội`, display `Tội (tội lỗi; tội phạm; trách nhiệm)`, search text, and crime/judgment related kanji. |
| `裁` | KANJIDIC2 `Tài`, meanings `tailor`, `judge`, `decision`; Unihan `kVietnamese=trài`, `kDefinition=cut out; decrease`; local context `裁判` | Added learner-facing Hán-Việt `Tài`, display `Tài (xét xử; phán quyết; cắt may)`, search text, and judgment related kanji. |
| `制` | KANJIDIC2 `Chế`, meanings `system`, `law`, `rule`; Unihan `kVietnamese=chế`, `kDefinition=system; establish; overpower`; local context `制度` | Added Hán-Việt `Chế`, display `Chế (chế độ; kiểm soát; quy định)`, search text, and system/regulation related kanji. |

Tagging: replaced the lesson-18 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 19 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_19.json`, especially cooking/food compounds such as `料理`, `食材`, `味`, `調味料`, `保存`, and `新鮮`.

| Item | Sources | Change |
|---|---|---|
| `料` | KANJIDIC2 `Liêu/Liệu`, meanings `fee`, `materials`; Unihan `kVietnamese=liệu`, `kDefinition=consider, conjecture; materials, ingredients`; local context `料理`/`材料` | Added learner-facing Hán-Việt `Liệu`, display `Liệu (nguyên liệu; vật liệu; phí)`, search text, and food/material related kanji. |
| `理` | KANJIDIC2 `Lý`, meanings `logic`, `arrangement`, `reason`; Unihan `kVietnamese=lí`, `kDefinition=reason, logic; manage`; local context `料理` | Added Hán-Việt `Lý`, display `Lý (lý lẽ; logic; xử lý)`, search text, and cooking/handling related kanji. |
| `食` | KANJIDIC2 `Thực/Tự`, meanings `eat`, `food`; Unihan `kDefinition=eat; meal; food`; local context food vocabulary | Rewrote display to `Thực (ăn; thức ăn; thực phẩm)`, normalized search text, and linked food related kanji. |
| `材` | KANJIDIC2 `Tài`, meanings `lumber`, `materials`, `ingredients`, `talent`; Unihan `kDefinition=material, stuff; timber; talent`; local context `食材`/`材料` | Corrected Vietnamese meaning from `tài liệu` to `nguyên liệu; vật liệu; gỗ`, capitalized Hán-Việt `Tài`, and linked material/food related kanji. |
| `味` | KANJIDIC2 `Vị`, meanings `flavor`, `taste`; Unihan `kVietnamese=vị`, `kDefinition=taste, smell, odor; delicacy`; local context taste/seasoning | Rewrote display to `Vị (mùi vị; hương vị; nếm)`, normalized search text, and linked taste/food related kanji. |
| `調` | KANJIDIC2 `Điều/Điệu`, meanings include `tune`, `prepare`, `investigate`, `harmonize`; Unihan `kVietnamese=điều`, `kDefinition=transfer, move, change; tune`; local context `調味料`/`調理` | Added learner-facing Hán-Việt `Điều`, display `Điều (điều chỉnh; chuẩn bị; tra cứu)`, search text, and preparation/flavor related kanji. |
| `保` | KANJIDIC2 `Bảo`, meanings `protect`, `guarantee`, `keep`, `preserve`; Unihan `kVietnamese=bảo`, `kDefinition=protect, safeguard, defend, care`; local context food preservation | Added Hán-Việt `Bảo`, display `Bảo (bảo vệ; giữ gìn; duy trì)`, search text, and preservation related kanji. |
| `鮮` | KANJIDIC2 `Tiên/Tiển`, meanings `fresh`, `vivid`, `clear`; Unihan `kVietnamese=tiên`, `kDefinition=fresh, new, delicious; rare, few`; local context `新鮮` | Added learner-facing Hán-Việt `Tiên`, display `Tiên (tươi; rõ nét; rực rỡ)`, search text, and freshness/food related kanji. |

Tagging: replaced the lesson-19 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

## Kanji N3 Lesson 20 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme/vocab context in `assets/data/content/kanji/n3/lesson_20.json`, especially emotion/psychology compounds such as `感情`, `不安`, `緊張`, `怒る`, and `悲しい`.

| Item | Sources | Change |
|---|---|---|
| `感` | KANJIDIC2 `Cảm`, meanings `emotion`, `feeling`, `sensation`; Unihan `kVietnamese=cảm`, `kDefinition=feel, perceive, emotion`; local context `感情` | Added Hán-Việt `Cảm`, display `Cảm (cảm xúc; cảm giác; cảm nhận)`, search text, and emotion related kanji. |
| `情` | KANJIDIC2 `Tình`, meanings `feelings`, `emotion`, `passion`, `circumstances`; Unihan `kVietnamese=tình`, `kDefinition=feeling, sentiment, emotion`; local context `感情` | Added Hán-Việt `Tình`, display `Tình (tình cảm; cảm xúc; hoàn cảnh)`, search text, and emotion related kanji. |
| `不` | KANJIDIC2 `Bất` plus variants, meanings `negative`, `non-`; Unihan `kVietnamese=bất`, `kDefinition=no, not; un-; negative prefix`; local context `不安` | Rewrote display to `Bất (không; phủ định; bất lợi)`, normalized search text, and linked negative/uneasy related kanji. |
| `安` | KANJIDIC2 `An`, meanings `relax`, `cheap`, `quiet`, `peaceful`; Unihan `kVietnamese=an`, `kDefinition=peaceful, tranquil, quiet`; local context `不安`/peace of mind | Rewrote display to `An (yên ổn; rẻ; an tâm)`, normalized search text, and linked peace/rest related kanji. |
| `緊` | KANJIDIC2 `Khẩn`, meanings `tense`, `solid`, `tight`; Unihan `kVietnamese=khẩn`, `kDefinition=tense, tight, taut; firm, secure`; local context `緊張` | Added Hán-Việt `Khẩn`, display `Khẩn (căng thẳng; chặt; khẩn cấp)`, search text, and tension related kanji. |
| `張` | KANJIDIC2 `Trương/Trướng`, meanings `stretch`, `spread`, `put up`; Unihan `kVietnamese=trương`, `kDefinition=stretch, extend, expand`; local context `緊張`/trying hard | Rewrote display to `Trương (căng ra; trải rộng; cố gắng)`, normalized search text, and linked tension/effort related kanji. |
| `怒` | KANJIDIC2 `Nộ`, meanings `angry`, `be offended`; Unihan `kVietnamese=nộ`, `kDefinition=anger, rage, passion; angry`; local context anger | Rewrote display to `Nộ (giận dữ; nổi giận; phẫn nộ)`, normalized search text, and linked emotion related kanji. |
| `悲` | KANJIDIC2 `Bi`, meanings `grieve`, `sad`, `deplore`; Unihan `kVietnamese=bi`, `kDefinition=sorrow, grief; sorry, sad`; local context sadness | Rewrote display to `Bi (buồn; đau lòng; thương xót)`, normalized search text, and linked emotion related kanji. |

Tagging: replaced the lesson-20 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

Live proof after deploy: VI/N3 Kanji search for `感` opened the detail modal with `Cảm (cảm xúc; cảm giác; cảm nhận)` plus Hán-Việt `Cảm`.

## Kanji N3 Lesson 21 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme in `assets/data/content/kanji/n3/lesson_21.json`, which labels the batch as economy/finance; the current `ShinKanzen` vocab lesson-21 source ids are not economy terms, so they were not used as semantic authority for this kanji batch.

| Item | Sources | Change |
|---|---|---|
| `経` | KANJIDIC2 `Kinh`, meanings `sutra`, `longitude`, `pass thru`; Unihan `kDefinition=classic works; pass through`; local theme economy/finance via `経済` | Capitalized Hán-Việt `Kinh`, display `Kinh (trải qua; kinh sách; kinh tuyến)`, normalized search text, and linked economy/experience related kanji. |
| `済` | KANJIDIC2 `Tế/Tề`, meanings `settle`, `relieve`, `finish`; Unihan `kDefinition=help, aid, relieve`; local theme `経済` | Corrected learner-facing Hán-Việt from `tể` to `Tế`, display `Tế (xong; giải quyết; cứu giúp)`, search text, and linked completion/relief related kanji. |
| `利` | KANJIDIC2 `Lợi`, meanings `profit`, `advantage`, `benefit`; Unihan `kVietnamese=lợi`, `kDefinition=gains, advantage, profit, merit` | Expanded display to `Lợi (lợi ích; thuận lợi; lợi nhuận)`, normalized search text, and linked profit/benefit related kanji. |
| `益` | KANJIDIC2 `Ích`, meanings `benefit`, `gain`, `profit`; Unihan `kVietnamese=ích`, `kDefinition=profit, benefit; advantage` | Added Hán-Việt `Ích`, display `Ích (lợi ích; tăng thêm; có ích)`, search text, and benefit/gain related kanji. |
| `投` | KANJIDIC2 `Đầu`, meanings `throw`, `invest in`, `put in`; Unihan `kVietnamese=đầu`, `kDefinition=throw, cast, fling` | Rewrote display to `Đầu (ném; đầu tư; bỏ vào)`, normalized search text, and linked investment/put-in related kanji. |
| `収` | KANJIDIC2 `Thu/Thâu`, meanings `income`, `obtain`, `store`; Unihan `kDefinition=gather together, collect; harvest` | Added learner-facing Hán-Việt `Thu`, display `Thu (thu vào; thu nhập; cất giữ)`, search text, and income/collection related kanji. |
| `税` | KANJIDIC2 `Thuế`, meanings `tax`, `duty`; Unihan `kVietnamese=thuế`, `kDefinition=taxes` | Added Hán-Việt `Thuế`, display `Thuế (thuế; thuế vụ)`, search text, and tax/finance related kanji. |
| `財` | KANJIDIC2 `Tài`, meanings `property`, `money`, `wealth`; Unihan `kVietnamese=tài`, `kDefinition=wealth, valuables, riches` | Added Hán-Việt `Tài`, display `Tài (tài sản; của cải; tiền bạc)`, search text, and asset/finance related kanji. |

Tagging: replaced the lesson-21 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

Live proof after deploy: VI/N3 Kanji search for `財` opened the detail modal with `Tài (tài sản; của cải; tiền bạc)` plus Hán-Việt `Tài`, with console errors/warnings `0`.

## Kanji N3 Lesson 22 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme in `assets/data/content/kanji/n3/lesson_22.json`, which labels the batch as communication/expression; the current `ShinKanzen` vocab lesson-22 source ids are general nouns and were not used as semantic authority for this kanji batch.

| Item | Sources | Change |
|---|---|---|
| `説` | KANJIDIC2 `Thuyết`, meanings `opinion`, `theory`, `explanation`; Unihan `kVietnamese=thuyết`, `kDefinition=speak`; local theme communication/expression | Added Hán-Việt `Thuyết`, display `Thuyết (giải thích; học thuyết; ý kiến)`, search text, and explanation/speech related kanji. |
| `紹` | KANJIDIC2 `Thiệu`, meanings `introduce`, `inherit`, `help`; Unihan `kVietnamese=thiệu`, `kDefinition=continue, carry on; hand down; to join` | Added Hán-Việt `Thiệu`, display `Thiệu (giới thiệu; nối tiếp; giúp đỡ)`, search text, and introduction/continuation related kanji. |
| `介` | KANJIDIC2 `Giới`, meanings `mediate`, `concern oneself with`; Unihan `kVietnamese=giới`, `kDefinition=to lie between; sea shell` | Added Hán-Việt `Giới`, display `Giới (làm trung gian; giới thiệu; xen vào)`, search text, and mediation/introduction related kanji. |
| `謝` | KANJIDIC2 `Tạ`, meanings `apologize`, `thank`, `refuse`; Unihan `kVietnamese=tạ`, `kDefinition=thank; decline` | Rewrote display to `Tạ (cảm ơn; xin lỗi; từ chối)`, normalized search text, and linked apology/thanks related kanji. |
| `議` | KANJIDIC2 `Nghị`, meanings `deliberation`, `consultation`, `debate`; Unihan `kVietnamese=nghị`, `kDefinition=consult, talk over, discuss` | Added Hán-Việt `Nghị`, display `Nghị (bàn bạc; thảo luận; nghị luận)`, search text, and discussion/debate related kanji. |
| `翻` | KANJIDIC2 `Phiên`, meanings `flip`, `turn over`, `change`; Unihan `kDefinition=flip over, upset, capsize` | Capitalized Hán-Việt `Phiên`, display `Phiên (lật; đảo lại; đổi ý)`, search text, and flip/translation related kanji. |
| `訳` | KANJIDIC2 `Dịch`, meanings `translate`, `reason`, `circumstance`; Unihan `kDefinition=translate; decode; encode` | Capitalized Hán-Việt `Dịch`, display `Dịch (dịch thuật; lý do; hoàn cảnh)`, search text, and translation/reason related kanji. |
| `連` | KANJIDIC2 `Liên`, meanings `connect`, `join`, `take along`; Unihan `kVietnamese=liên`, `kDefinition=join, connect; continuous` | Expanded display to `Liên (liên kết; nối liền; dẫn theo)`, normalized search text, and linked connection/continuity related kanji. |

Tagging: replaced the lesson-22 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

Live proof after deploy: VI/N3 Kanji search for `説` opened the detail modal with `Thuyết (giải thích; học thuyết; ý kiến)` plus Hán-Việt `Thuyết`, with console errors/warnings `0`.

## Kanji N3 Lesson 23 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme in `assets/data/content/kanji/n3/lesson_23.json`, which labels the batch as history/politics; the current `ShinKanzen` vocab lesson-23 source ids are general nouns and were not used as semantic authority for this kanji batch.

| Item | Sources | Change |
|---|---|---|
| `歴` | KANJIDIC2 `Lịch`, meanings `curriculum`, `continuation`, `passage of time`; Unihan `kDefinition=take place, past, history`; local theme history/politics | Added Hán-Việt `Lịch`, display `Lịch (lịch sử; trải qua; quá trình)`, search text, and history/time related kanji. |
| `史` | KANJIDIC2 `Sử`, meanings `history`, `chronicle`; Unihan `kVietnamese=sử`, `kDefinition=history, chronicle, annals` | Added Hán-Việt `Sử`, display `Sử (lịch sử; sử ký; ghi chép)`, search text, and record/history related kanji. |
| `政` | KANJIDIC2 `Chánh`, meanings `politics`, `government`; Unihan `kVietnamese=chính`, `kDefinition=government, political affairs` | Added learner-facing Hán-Việt `Chính`, display `Chính (chính trị; chính quyền; điều hành)`, search text, and politics/government related kanji. |
| `治` | KANJIDIC2 `Trị/Trì`, meanings `rule`, `cure`, `calm`; Unihan `kVietnamese=trị`, `kDefinition=govern, regulate, administer` | Added Hán-Việt `Trị`, display `Trị (cai trị; chữa trị; ổn định)`, search text, and governance/cure related kanji. |
| `戦` | KANJIDIC2 meanings `war`, `battle`, `match`; Unihan `kDefinition=war, fighting, battle`; local theme `戦争` | Capitalized learner-facing Hán-Việt `Chiến`, display `Chiến (chiến tranh; trận đấu; chiến đấu)`, search text, and war/contest related kanji. |
| `争` | KANJIDIC2 `Tranh`, meanings `contend`, `dispute`, `argue`; Unihan `kDefinition=dispute, fight, contend, strive` | Added Hán-Việt `Tranh`, display `Tranh (tranh chấp; cạnh tranh; đấu tranh)`, search text, and conflict/debate related kanji. |
| `平` | KANJIDIC2 `Bình`, meanings `even`, `flat`, `peace`; Unihan `kVietnamese=bình`, `kDefinition=flat, level, even; peaceful` | Added Hán-Việt `Bình`, display `Bình (bằng phẳng; bình yên; ngang nhau)`, search text, and peace/equality related kanji. |
| `和` | KANJIDIC2 `Hòa`, meanings `harmony`, `Japanese style`, `peace`; Unihan `kVietnamese=hoà`, `kDefinition=harmony, peace; peaceful, calm` | Added Hán-Việt `Hòa`, display `Hòa (hòa hợp; hòa bình; kiểu Nhật)`, search text, and harmony/peace related kanji. |

Tagging: replaced the lesson-23 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

Live proof after deploy: VI/N3 Kanji search for `歴` opened the detail modal with `Lịch (lịch sử; trải qua; quá trình)` plus Hán-Việt `Lịch`, with console errors/warnings `0`.

## Kanji N3 Lesson 24 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings where present, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme in `assets/data/content/kanji/n3/lesson_24.json`, which labels the batch as fashion/personal style. The generated `sourceVocabId` links were not used as authority because ShinKanzen vocab IDs do not align with this kanji theme.

| Item | Sources | Change |
|---|---|---|
| `流` | KANJIDIC2 `Lưu`, meanings `current`, `flow`, `forfeit`; Unihan `kVietnamese=lưu`, `kDefinition=flow, circulate, drift`; local theme via `流行` | Added Hán-Việt `Lưu`, display `Lưu (dòng chảy; lưu hành; trôi)`, direct example `流行`, search text, and flow/movement related kanji. |
| `行` | KANJIDIC2 readings include `Hành/Hàng`, meanings `going`, `carry out`, `line`; Unihan `kVietnamese=hàng`, `kDefinition=go; walk; move`; local theme via `流行` | Rewrote display to `Hành (đi; thực hiện; hàng lối)`, normalized search text, direct example `流行`, and movement/action related kanji. |
| `着` | KANJIDIC2 meanings `don`, `arrive`, `wear`; Unihan has no `kVietnamese` for this codepoint; existing app N4 entry uses learner-facing `Trước` | Kept app-standard Hán-Việt `Trước`, rewrote display to `Trước (mặc; đến nơi; bám vào)`, added direct examples `着る`/`到着`, and clothing/arrival related kanji. |
| `替` | KANJIDIC2 `Thế`, meanings `exchange`, `spare`, `substitute`; Unihan `kVietnamese=thế`, `kDefinition=change, replace, substitute for` | Rewrote display to `Thế (thay thế; đổi; dự phòng)`, normalized search text, direct example `着替える`, and replacement/clothing related kanji. |
| `化` | KANJIDIC2 `Hóa`, meanings `change`, `take the form of`, `-ization`; Unihan `kVietnamese=hoá`, `kDefinition=change, convert, reform` | Added Hán-Việt `Hóa`, display `Hóa (thay đổi; biến hóa; -hóa)`, direct example `化粧`, search text, and change/adornment related kanji. |
| `粧` | KANJIDIC2 `Trang`, meanings `cosmetics`, `adorn`; Unihan `kDefinition=toilet; make-up; dress up; adorn` | Added Hán-Việt `Trang`, display `Trang (trang điểm; làm đẹp; tô điểm)`, direct example `化粧`, search text, and beauty/adornment related kanji. |
| `装` | KANJIDIC2 `Trang`, meanings `attire`, `dress`, `disguise`; Unihan `kDefinition=dress, clothes, attire` | Added Hán-Việt `Trang`, display `Trang (trang phục; ăn mặc; giả trang)`, direct example `服装`, search text, and clothing/adornment related kanji. |
| `飾` | KANJIDIC2 `Sức`, meanings `decorate`, `ornament`, `adorn`; Unihan `kDefinition=decorate, ornament, adorn` | Rewrote display to `Sức (trang trí; đồ trang sức; tô điểm)`, direct example `装飾`, search text, and decoration/beauty related kanji. |

Tagging: replaced the lesson-24 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

Live proof after deploy: VI/N3 Kanji search for `流` returned three matches; the lesson-24 `流` opened the detail modal with `Lưu (dòng chảy; lưu hành; trôi)`, Hán-Việt `Lưu`, and the QUARTET 24 fashion/personal-style mnemonic. Console errors/warnings after the interaction: `0`.

## Kanji N3 Lesson 25 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese readings, stroke count, Hán-Việt readings where present, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`/`kDefinition` cross-checks where available.
- Existing authored N3 lesson theme in `assets/data/content/kanji/n3/lesson_25.json`, which labels the batch as global issues/volunteering. The generated `sourceVocabId` links were not used as authority because ShinKanzen vocab IDs do not align with this kanji theme.

| Item | Sources | Change |
|---|---|---|
| `際` | KANJIDIC2 `Tế`, meanings `occasion`, `edge`, `time`; Unihan `kDefinition=border, boundary, juncture`; local context `国際` | Capitalized Hán-Việt `Tế`, display `Tế (dịp; ranh giới; khi)`, direct example `国際`, search text, and boundary/world related kanji. |
| `貧` | KANJIDIC2 `Bần`, meanings `poverty`, `poor`; Unihan `kVietnamese=bần`, `kDefinition=poor, impoverished, needy`; local context poverty/global issues | Added Hán-Việt `Bần`, display `Bần (nghèo; thiếu thốn; bần cùng)`, direct example `貧困`, search text, and poverty/finance related kanji. |
| `困` | KANJIDIC2 `Khốn`, meanings `quandary`, `distressed`; Unihan `kVietnamese=khốn`, `kDefinition=to surround; difficult`; local context social problems | Rewrote display to `Khốn (gặp khó; lúng túng; khốn đốn)`, direct example `困る`, search text, and difficulty/help related kanji. |
| `難` | KANJIDIC2 `Nan/Nạn`, meanings `difficult`, `trouble`, `accident`; Unihan `kVietnamese=nan`, `kDefinition=difficult, arduous, hard`; local context `困難` | Added Hán-Việt `Nan/Nạn`, display `Nan/Nạn (khó khăn; hiểm nạn; khó làm)`, direct example `困難`, search text, and disaster/help related kanji. |
| `汚` | KANJIDIC2 `Ô`, meanings `dirty`, `pollute`, `defile`; Unihan `kDefinition=filthy, dirty, impure, polluted`; local context pollution | Rewrote display to `Ô (bẩn; làm ô uế; ô nhiễm)`, direct example `汚染`, search text, and pollution/environment related kanji. |
| `染` | KANJIDIC2 `Nhiễm`, meanings `dye`, `stain`, `print`; Unihan `kVietnamese=nhuộm`, `kDefinition=dye; be contagious; infect`; local context `汚染` | Added learner-facing Hán-Việt `Nhiễm`, display `Nhiễm (nhuộm; nhiễm; thấm)`, direct example `汚染`, search text, and dye/pollution related kanji. |
| `平` | KANJIDIC2 `Bình/Biền`, meanings `even`, `flat`, `peace`; Unihan `kVietnamese=bình`, `kDefinition=flat, level, even; peaceful`; local context `平等` | Added Hán-Việt `Bình`, display `Bình (bình đẳng; bằng phẳng; hòa bình)`, direct example `平等`, search text, and equality/peace related kanji. |
| `等` | KANJIDIC2 `Đẳng`, meanings `etc.`, `class`, `equal`; Unihan `kVietnamese=đẳng`, `kDefinition=rank, grade; equal`; local context `平等` | Added Hán-Việt `Đẳng`, display `Đẳng (bình đẳng; cấp bậc; vân vân)`, direct example `平等`, search text, and equality/rank related kanji. |

Tagging: replaced the lesson-25 file-level `vi-human-approved` with `vi-source-verified` and added entry-level `vi-source-verified` to all eight edited entries. No `vi-human-approved` tag was added.

Live proof after deploy: VI/N3 Kanji search for `際` opened the lesson-25 detail modal with `Tế (dịp; ranh giới; khi)`, Hán-Việt `Tế`, and the QUARTET 25 global-issues/volunteering mnemonic. This was verified after bypassing the stale service-worker cache while preserving IndexedDB, so the existing browser DB upgraded from seed revision 25 to 26. Console errors/warnings after the interaction: `0`.

## Kanji N2 Lesson 1 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, JLPT legacy tier, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos vocabulary context in `assets/data/content/vocab/n2/ShinKanzen/tanos_n2_01.json`, used only to choose example words, not as a learner-facing translation source.

| Item | Sources | Change |
|---|---|---|
| `遭` | KANJIDIC2 readings `ソウ`, `あ.う`, meanings `encounter`, `meet`; Unihan `kVietnamese=tao`, `kDefinition=come across, meet with, encounter`; local context `遭う` | Rewrote display to `Tao (gặp phải; gặp chuyện không may)`, added readings/search text, direct example `遭う`, and related kanji. |
| `扇` | KANJIDIC2 readings `セン`, `おうぎ`, meanings `fan`, `folding fan`; Unihan `kVietnamese=phiến`, `kJapanese=セン おうぎ あおぐ`; local context `扇ぐ` | Rewrote display to `Phiến (quạt; quạt xếp)`, added `あお.ぐ` for the local verb example, normalized search text, and related kanji. |
| `青` | KANJIDIC2 readings `セイ/ショウ`, `あお`, meaning `blue`; Unihan `kVietnamese=thanh`, `kDefinition=blue, green; young`; local context `青白い` | Rewrote display to `Thanh (xanh; xanh xao; trẻ)`, direct example `青白い`, search text, and color/brightness related kanji. |
| `白` | KANJIDIC2 readings `ハク/ビャク`, `しろ`, meaning `white`; Unihan `kVietnamese=bạch`, `kDefinition=white; pure, unblemished; bright`; local context `青白い` | Rewrote display to `Bạch (trắng; sáng; tinh khiết)`, direct example `青白い`, search text, and color/brightness related kanji. |
| `明` | KANJIDIC2 readings `メイ/ミョウ/ミン`, meanings `bright`, `light`; Unihan `kVietnamese=minh`, `kDefinition=bright, light, brilliant; clear`; local context `明け方` | Rewrote display to `Minh (sáng; rõ ràng; minh bạch)`, replaced the confusing `明き` example with `明け方`, and linked light/dark related kanji. |
| `飽` | KANJIDIC2 readings `ホウ`, `あ.きる`, meanings `sated`, `tired of`, `bored`; Unihan has no `kVietnamese` for this codepoint but confirms `kDefinition=eat heartily; eat one's fill`; existing D2 spot-check had HV `Bão` | Rewrote display to `Bão (chán; no; ngấy)`, direct example `飽くまで`, search text, and food/fullness related kanji. |
| `方` | KANJIDIC2 readings `ホウ`, `かた/-がた`, meanings `direction`, `person`, `alternative`; Unihan `kVietnamese=phương`, `kDefinition=a square, rectangle; a region; local`; local context `明け方` | Rewrote display to `Phương (phương hướng; phía; cách; người)`, direct example `明け方`, search text, and direction/place related kanji. |
| `揚` | KANJIDIC2 readings `ヨウ`, `あ.げる`, meanings `raise`, `hoist`, `fry in deep fat`; Unihan `kVietnamese=dương`, `kDefinition=scatter, spread; praise`; local context `揚げる` | Rewrote display to `Dương (nâng lên; giương lên; chiên ngập dầu)`, direct example `揚げる`, search text, and movement/oil related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, replaced old `approved-by-user` metadata with `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `26` to `27` and added an N2 lesson-01 sentinel for `遭` so existing browsers reseed this metadata.

Live proof after deploy: VI/N2 Kanji grid loaded `200` entries. Opening `遭` showed `Tao (gặp phải; gặp chuyện không may)`, Hán-Việt `Tao`, on `ソウ`, kun `あ.う, あ.わせる`, and the rewritten Vietnamese mnemonic. Console errors/warnings after the interaction: `0`.

## Kanji N2 Lesson 2 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Hán-Việt readings where present, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese` cross-checks where available.
- Existing N2 ShinKanzen/Tanos vocabulary context in `assets/data/content/vocab/n2/ShinKanzen/tanos_n2_01.json`, used only to choose example words and cross-check the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `挙` | KANJIDIC2 readings `キョ`, `あ.げる/あ.がる/こぞ.る`, meanings `raise`, `plan`, `project`, `actions`; local context `挙げる` | Rewrote display to `Cử (giơ lên; nêu ra; tổ chức; hành động)`, added readings/search text, direct example `挙げる`, and related kanji. |
| `憧` | KANJIDIC2 readings `ショウ/トウ/ドウ`, `あこが.れる`, meanings `yearn after`, `long for`, `admire`; local context `憧れる` | Rewrote display to `Sung (ngưỡng mộ; khao khát; hướng tới)`, added readings/search text, direct example `憧れる`, and related kanji. |
| `足` | KANJIDIC2 `Túc`, readings `ソク`, `あし/た.りる/た.る/た.す`, meanings `leg`, `foot`, `sufficient`; Unihan `kVietnamese=túc`; local context `足跡` | Rewrote display to `Túc (chân; bàn chân; đủ)`, direct example `足跡`, search text, and foot/movement related kanji. |
| `跡` | KANJIDIC2 `Tích`, readings `セキ`, `あと`, meanings `tracks`, `mark`, `impression`; Unihan `kVietnamese=tích`; local context `足跡` | Rewrote display to `Tích (dấu vết; vết tích; dấu chân)`, direct example `足跡`, search text, and trace/mark related kanji. |
| `味` | KANJIDIC2 `Vị`, readings `ミ`, `あじ/あじ.わう`, meanings `flavor`, `taste`; Unihan `kVietnamese=vị`; local context `味わう` | Rewrote display to `Vị (vị; mùi vị; thưởng thức)`, direct example `味わう`, search text, and taste/food related kanji. |
| `預` | KANJIDIC2 `Dự`, readings `ヨ`, `あず.ける/あず.かる`, meanings `deposit`, `custody`, `entrust`; Unihan `kVietnamese=dự`; local context `預かる` | Rewrote display to `Dự (gửi giữ; nhận giữ; giao phó)`, direct example `預かる`, search text, and custody/responsibility related kanji. |
| `暖` | KANJIDIC2 `Noãn`, readings `ダン/ノン`, `あたた.か/あたた.まる/あたた.める`, meaning `warmth`; local context `暖まる` | Rewrote display to `Noãn (ấm; hơi ấm; làm ấm)`, direct example `暖まる`, search text, and warmth/weather related kanji. |
| `厚` | KANJIDIC2 `Hậu`, readings `コウ`, `あつ.い`, meanings `thick`, `kind`, `brazen`, `shameless`; local context `厚かましい` | Rewrote display to `Hậu (dày; nồng hậu; trơ trẽn)`, direct example `厚かましい`, search text, and nuance-related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, replaced old `approved-by-user` metadata with `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `27` to `28` and added an N2 lesson-02 sentinel for `挙` so existing browsers reseed this metadata.

Live proof after deploy: VI/N2 Kanji search for `挙` opened the detail modal with `Cử (giơ lên; nêu ra; tổ chức; hành động)`, Hán-Việt `Cử`, on `キョ`, kun `あ.げる, あ.がる, こぞ.る`, and the rewritten Vietnamese mnemonic. Console errors/warnings after the interaction: `0`.

## Kanji N2 Lesson 3 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Hán-Việt readings where present, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese` cross-checks where available.
- Existing N2 ShinKanzen/Tanos vocabulary context in `assets/data/content/vocab/n2/ShinKanzen/tanos_n2_01.json`, used only to choose example words and cross-check the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `圧` | KANJIDIC2 readings `アツ/エン/オウ`, `お.す/へ.す/おさ.える`, meanings `pressure`, `push`, `overwhelm`; local context `圧縮` | Rewrote display to `Áp (áp lực; nén; ép)`, added readings/search text, direct example `圧縮`, and related kanji. |
| `縮` | KANJIDIC2 `Súc`, readings `シュク`, `ちぢ.む/...`, meanings `shrink`, `contract`, `reduce`; local context `圧縮` | Rewrote display to `Súc (co lại; rút ngắn; nén lại)`, direct example `圧縮`, search text, and compression/size related kanji. |
| `宛` | KANJIDIC2 `Uyển/Uyên`, readings `エン`, `あ.てる`, meanings `address`, `just like`; Unihan `kVietnamese=uyển`; local context `宛名` | Rewrote display to `Uyển (địa chỉ; gửi đến; giống như)`, direct example `宛名`, search text, and mailing/address related kanji. |
| `名` | KANJIDIC2 `Danh`, readings `メイ/ミョウ`, `な`, meanings `name`, `reputation`; Unihan `kVietnamese=danh`; local context `宛名` | Rewrote display to `Danh (tên; danh tiếng; nổi tiếng)`, direct example `宛名`, search text, and name/record related kanji. |
| `暴` | KANJIDIC2 `Bạo/Bộc`, readings `ボウ/バク`, `あば.れる`, meanings `violence`, `force`, `outburst`; Unihan `kVietnamese=bạo`; local context `暴れる` | Rewrote display to `Bạo (bạo lực; dữ dội; nổi loạn)`, direct example `暴れる`, search text, and violence/anger related kanji. |
| `脂` | KANJIDIC2 `Chi`, readings `シ`, `あぶら`, meanings `fat`, `grease`, `lard`; local context `脂` | Rewrote display to `Chỉ (mỡ; chất béo; dầu mỡ)`, direct example `脂`, search text, and food/fat related kanji. |
| `雨` | KANJIDIC2 `Vũ/Vú`, readings `ウ`, `あめ/あま-`, meaning `rain`; local context `雨戸` | Rewrote display to `Vũ (mưa)`, direct example `雨戸`, search text, and weather/door related kanji. |
| `戸` | KANJIDIC2 `Hộ/Họ`, readings `コ`, `と`, meanings `door`, `house counter`, `door radical`; local context `雨戸` | Rewrote display to `Hộ (cửa; hộ gia đình; bộ cửa)`, direct example `雨戸`, search text, and door/house related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, replaced old `approved-by-user` metadata with `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `28` to `29` and added an N2 lesson-03 sentinel for `圧` so existing browsers reseed this metadata.

Live proof after deploy: initial verification exposed a Hosting cache regression, not a content-data miss. The deployed asset already contained `Áp (áp lực; nén; ép)`, but the browser reused an old `main.dart.js` bundle whose Kanji seed sentinels stopped before lesson 03. Commit `dff7a998` changed non-fingerprinted Flutter shell files plus content assets to `Cache-Control: no-cache` while keeping `sqlite3.wasm` and `drift_worker.js` on `public, max-age=2592000`. After redeploy, a normal reload fetched `main.dart.js` from the network and VI/N2 search for `圧` opened the detail modal with `Áp (áp lực; nén; ép)`, Hán-Việt `Áp`, on `アツ, エン, オウ`, kun `お.す, へ.す, おさ.える`, and the rewritten Vietnamese mnemonic. Console errors/warnings after the interaction: `0`.

## Kanji N2 Lesson 4 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Hán-Việt readings where present, old JLPT tier, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos vocabulary context in `assets/data/content/vocab/n2/ShinKanzen/tanos_n2_01.json`, used only to choose example words and cross-check the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `甘` | KANJIDIC2 `Cam`, readings `カン`, `あま.い/あま.える/あま.やかす/うま.い`, meanings `sweet`, `pamper`; Unihan `kVietnamese=cam`, `kDefinition=sweetness; sweet, tasty`; local context `甘やかす` | Rewrote display to `Cam (ngọt; dễ dãi; nuông chiều)`, added readings/search text, direct example `甘やかす`, and related kanji. |
| `余` | KANJIDIC2 `Dư`, readings `ヨ`, `あま.る/あま.り/あま.す/あんま.り`, meanings `too much`, `surplus`, `remainder`; Unihan `kVietnamese=dư`; local context `余る` | Rewrote display to `Dư (thừa; còn lại; phần dư)`, direct example `余る`, search text, and surplus/remainder related kanji. |
| `編` | KANJIDIC2 `Biên`, readings `ヘン`, `あ.む/-あ.み`, meanings `compilation`, `knit`, `editing`; Unihan `kVietnamese=biên`; local context `編物` | Rewrote display to `Biên (biên soạn; đan; phần sách)`, direct example `編物`, search text, and edit/knit related kanji. |
| `物` | KANJIDIC2 `Vật`, readings `ブツ/モツ`, `もの`, meanings `thing`, `object`, `matter`; Unihan `kVietnamese=vật`; local context `編物` | Corrected the wrong source gloss from `knitting, web` to `Vật (vật; đồ vật; sự vật)`, direct example `編物`, search text, and object/thing related kanji. |
| `危` | KANJIDIC2 `Nguy`, readings `キ`, `あぶ.ない/あや.うい/あや.ぶむ`, meanings `dangerous`, `fear`, `uneasy`; Unihan `kVietnamese=nguy`; local context `危うい` | Rewrote display to `Nguy (nguy hiểm; nguy cấp; bất an)`, direct example `危うい`, search text, and danger/safety related kanji. |
| `怪` | KANJIDIC2 `Quái`, readings `カイ/ケ`, `あや.しい/あや.しむ`, meanings `suspicious`, `mystery`, `apparition`; Unihan `kDefinition=strange, unusual, peculiar`; local context `怪しい` | Rewrote display to `Quái (đáng ngờ; kỳ lạ; bí ẩn)`, added readings/search text, direct example `怪しい`, and mystery/suspicion related kanji. |
| `荒` | KANJIDIC2 `Hoang`, readings `コウ`, `あ.らす/あ.れる/あら.い/すさ.ぶ/すさ.む/あ.らし`, meanings `laid waste`, `rough`, `wild`; Unihan `kVietnamese=hoang`; local context `荒い` | Rewrote display to `Hoang (hoang vu; thô bạo; dữ dội)`, direct example `荒い`, search text, and rough/wild related kanji. |
| `粗` | KANJIDIC2 `Thô`, readings `ソ`, `あら.い/あら-`, meanings `coarse`, `rough`, `rugged`; Unihan `kVietnamese=thô`; local context `粗い` | Rewrote display to `Thô (thô; sơ sài; không mịn)`, direct example `粗い`, search text, and coarse/fine related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, replaced old `approved-by-user`/`kanji-metadata-approved` metadata with `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `29` to `30` and added an N2 lesson-04 sentinel for `甘` so existing browsers reseed this metadata.

Live proof after deploy: normal reload fetched `main.dart.js` from the network, then VI/N2 Kanji search for `甘` opened the detail modal with `Cam (ngọt; dễ dãi; nuông chiều)`, Hán-Việt `Cam`, on `カン`, kun `あま.い, あま.える, あま.やかす, うま.い`, and the rewritten Vietnamese mnemonic. Console errors/warnings after the interaction: `0`.

## Kanji N2 Lesson 5 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Hán-Việt readings where present, old JLPT tier, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos vocabulary context in `assets/data/content/vocab/n2/ShinKanzen/tanos_n2_01.json`, used only to choose example words and cross-check the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `争` | KANJIDIC2 readings `ソウ`, `あらそ.う`, meanings `contend`, `dispute`, `argue`; Unihan `kVietnamese=tranh`; local context `争う` | Rewrote display to `Tranh (tranh chấp; cạnh tranh; cãi nhau)`, added on/kun readings, direct example `争う`, search text, and dispute/competition related kanji. |
| `改` | KANJIDIC2 `Cải`, readings `カイ`, `あらた.める/あらた.まる`, meanings `reformation`, `change`, `renew`; Unihan `kVietnamese=cải`; local context `改めて` | Rewrote display to `Cải (sửa đổi; cải thiện; kiểm tra lại)`, direct example `改めて`, search text, and change/improvement related kanji. |
| `著` | KANJIDIC2 `Trứ`, readings `チョ/チャク`, `あらわ.す/いちじる.しい`, meanings `renowned`, `publish`, `write`; local context `著す` | Rewrote display to `Trứ (viết; xuất bản; nổi bật)`, direct example `著す`, search text, and writing/author related kanji. |
| `有` | KANJIDIC2 `Hữu`, readings `ユウ/ウ`, `あ.る`, meanings `possess`, `have`, `exist`; Unihan `kVietnamese=hữu`; local context `有難い` | Corrected the row away from the generated `grateful` word gloss to `Hữu (có; tồn tại; sở hữu)`, direct example `有難い`, search text, and existence/opposite related kanji. |
| `難` | KANJIDIC2 `Nan`, readings `ナン`, `むずか.しい/-にく.い`, meanings `difficult`, `trouble`, `accident`; Unihan `kVietnamese=nan`; local context `有難い` | Corrected the row away from the generated `grateful` word gloss to `Nan (khó; tai nạn; vấn đề)`, direct example `有難い`, search text, and difficulty/trouble related kanji. |
| `在` | KANJIDIC2 `Tại`, readings `ザイ`, `あ.る`, meanings `exist`, `be located`; Unihan `kVietnamese=tại`; local context `在る` | Rewrote display to `Tại (ở; tồn tại; hiện diện)`, direct example `在る`, search text, and existence/place related kanji. |
| `安` | KANJIDIC2 `An`, readings `アン`, `やす.い/やす.らか`, meanings `relax`, `cheap`, `low`; Unihan `kVietnamese=an`; local context `安易` | Rewrote display to `An (yên ổn; rẻ; dễ)`, direct example `安易`, search text, and ease/safety related kanji. |
| `易` | KANJIDIC2 `Dịch`, readings `エキ/イ`, `やさ.しい/やす.い`, meanings `easy`, `simple`, `divination`; Unihan `kVietnamese=dịch`; local context `安易` | Rewrote display to `Dịch (dễ; đơn giản; bói dịch)`, direct example `安易`, search text, and easy/change/divination related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, replaced old `approved-by-user`/`kanji-metadata-approved` metadata with `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `30` to `31` and added an N2 lesson-05 sentinel for `争` so existing browsers reseed the changed metadata.

Live proof after deploy: the first already-open Playwright tab still had an old Flutter runtime in memory; a normal reload fetched the no-cache shell and triggered the revision-31 reseed. VI/N2 Kanji search for `争` then opened the detail modal with `Tranh (tranh chấp; cạnh tranh; cãi nhau)`, Hán-Việt `Tranh`, on `ソウ`, kun `あらそ.う, いか.でか`, and the rewritten Vietnamese mnemonic. Console errors/warnings after the interaction: `0`.

## Kanji N2 Lesson 6 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Hán-Việt readings where present, old JLPT tier, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos vocabulary context in `assets/data/content/vocab/n2/ShinKanzen/tanos_n2_01.json`, used only to choose example words and cross-check the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `案` | KANJIDIC2 `Án`, readings `アン`, `つくえ`, meanings `plan`, `suggestion`, `idea`; Unihan `kVietnamese=an án yên`, `kDefinition=table, bench; legal case`; local context `案外` | Rewrote display to `Án (ý tưởng; phương án; vụ việc)`, direct example `案外`, search text, and planning/expectation related kanji. |
| `外` | KANJIDIC2 `Ngoại`, readings `ガイ/ゲ`, `そと/ほか/...`, meaning `outside`; Unihan `kVietnamese=ngoại`, `kDefinition=out, outside, external; foreign`; local context `案外` | Corrected the row away from the generated `unexpectedly` word gloss to `Ngoại (bên ngoài; khác; nước ngoài)`, direct example `案外`, search text, and outside/foreign related kanji. |
| `言` | KANJIDIC2 `Ngôn`, readings `ゲン/ゴン`, `い.う/こと`, meanings `say`, `word`; Unihan `kVietnamese=ngôn`, `kDefinition=words, speech; speak, say`; local context `言い出す` | Rewrote display to `Ngôn (nói; lời nói; ngôn từ)`, direct example `言い出す`, search text, and speech related kanji. |
| `出` | KANJIDIC2 `Xuất`, readings `シュツ/スイ`, `で.る/だ.す/...`, meanings `exit`, `leave`, `put out`; Unihan `kVietnamese=xuất`; local context `言い出す` | Corrected the row away from the generated `to start talking` word gloss to `Xuất (ra; đưa ra; bắt đầu)`, direct example `言い出す`, search text, and exit/output related kanji. |
| `付` | KANJIDIC2 `Phó`, readings `フ`, `つ.ける/...`, meanings `adhere`, `attach`, `append`; Unihan `kVietnamese=phó`, `kDefinition=give, deliver, pay, hand over; entrust`; local context `言い付ける` | Rewrote display to `Phó (gắn; thêm; giao phó)`, direct example `言い付ける`, search text, and attach/order related kanji. |
| `意` | KANJIDIC2 `Ý`, reading `イ`, meanings `idea`, `mind`, `thought`; Unihan `kVietnamese=ý`; local context `意義` | Rewrote display to `Ý (ý nghĩ; ý nghĩa; ý định)`, direct example `意義`, search text, and thought/meaning related kanji. |
| `義` | KANJIDIC2 `Nghĩa`, reading `ギ`, meanings `righteousness`, `justice`, `meaning`; Unihan `kVietnamese=nghĩa`; local context `意義` | Rewrote display to `Nghĩa (nghĩa lý; chính nghĩa; đạo nghĩa)`, direct example `意義`, search text, and justice/meaning related kanji. |
| `生` | KANJIDIC2 `Sinh`, readings `セイ/ショウ`, many life/birth kun readings, meanings `life`, `birth`; Unihan `kVietnamese=sinh`; local context `生き生き` | Corrected the row away from the generated `vividly/lively` word gloss to `Sinh (sống; sinh ra; sự sống)`, direct example `生き生き`, search text, and life/death related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, replaced old `approved-by-user`/`kanji-metadata-approved` metadata with `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `31` to `32` and added an N2 lesson-06 sentinel for `案` so existing browsers reseed the changed metadata.

Live proof after deploy: normal reload fetched the no-cache shell and triggered the revision-32 reseed. VI/N2 Kanji search for `案` opened the detail modal with `Án (ý tưởng; phương án; vụ việc)`, Hán-Việt `Án`, on `アン`, kun `つくえ`, and the rewritten Vietnamese mnemonic. Console errors/warnings after the interaction: `0`.

## Kanji N2 Lesson 7 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, old JLPT tier, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos vocabulary context in `assets/data/content/vocab/n2/ShinKanzen/tanos_n2_01.json`, used only to choose example words and cross-check the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `育` | KANJIDIC2 `Dục`, readings `イク`, `そだ.つ/そだ.ち/そだ.てる/はぐく.む`, meanings `bring up`, `grow up`; Unihan `kVietnamese=dục`; local context `育児` | Corrected the row away from generated `childcare` word-gloss fallback to `Dục (nuôi dạy; phát triển; giáo dục)`, added readings/search text, direct example `育児`, and related kanji. |
| `児` | KANJIDIC2 `Nhi`, readings `ジ/ニ/ゲイ`, meanings `newborn babe`, `child`; Unihan `kVietnamese=nhi`; local context `育児` | Rewrote display to `Nhi (trẻ em; trẻ nhỏ; nhi đồng)`, added readings/search text, direct example `育児`, and child/family related kanji. |
| `幾` | KANJIDIC2 `Kỷ`, readings `キ`, `いく-`, meanings `how many`, `some`; Unihan `kVietnamese=kỷ`; local context `幾分` | Rewrote display to `Kỷ (bao nhiêu; vài; phần nào)`, added readings/search text, direct example `幾分`, and quantity related kanji. |
| `分` | KANJIDIC2 `Phân`, readings `ブン/フン/ブ`, `わ.ける/...`, meanings `part`, `minute`, `degree`; Unihan `kVietnamese=phân`; local context `幾分` | Corrected the row away from the generated `somewhat` word gloss to `Phân (phần; chia; phút)`, added readings/search text, direct example `幾分`, and part/time related kanji. |
| `花` | KANJIDIC2 `Hoa`, readings `カ/ケ`, `はな`, meaning `flower`; Unihan `kVietnamese=hoa`; local context `生け花` | Rewrote display to `Hoa (hoa; bông hoa)`, added readings/search text, direct example `生け花`, and art/nature related kanji. |
| `以` | KANJIDIC2 `Dĩ`, reading `イ`, meanings `by means of`, `because`, `compared with`; Unihan `kVietnamese=dĩ`; local context `以後` | Rewrote display to `Dĩ (lấy làm mốc; từ đó; bằng)`, added readings/search text, direct example `以後`, and boundary/time related kanji. |
| `後` | KANJIDIC2 `Hậu`, readings `ゴ/コウ`, `のち/うし.ろ/あと/...`, meanings `behind`, `afterwards`; Unihan `kVietnamese=hậu`; local context `以後` | Corrected the row away from generated `after this` word-gloss fallback to `Hậu (sau; phía sau; về sau)`, added readings/search text, direct example `以後`, and time/order related kanji. |
| `降` | KANJIDIC2 `Giáng`, readings `コウ/ゴ`, `お.りる/ふ.る`, meanings `descend`, `rain`, `surrender`; Unihan `kVietnamese=giáng`; local context `以降` | Rewrote display to `Giáng (xuống; rơi; đầu hàng)`, added readings/search text, direct example `以降`, and movement/weather related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `32` to `33` and added an N2 lesson-07 sentinel for `育` so existing browsers reseed the changed metadata.

Live proof after deploy: the already-open Playwright tab initially reused stale cached lesson data, so `育` showed the generated `育児` fallback. With cache disabled and a fresh live `content` IndexedDB, VI/N2 Kanji search for `育` opened the detail modal with `Dục (nuôi dạy; phát triển; giáo dục)`, Hán-Việt `Dục`, on `イク`, kun `そだ.つ, そだ.ち, そだ.てる, はぐく.む`, and the rewritten Vietnamese mnemonic. Console errors/warnings after the interaction: `0`.

## Kanji N2 Lesson 8 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, old JLPT tier, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese` when present, `kDefinition`, and Japanese-reading cross-checks.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `勇ましい`, `衣食住`, `意地悪`, and `一応`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.
- Existing source-verified JpStudy lower-level kanji rows for continuity where Unihan lacks a direct `kVietnamese` value on the Japanese codepoint (`食`); `応` cross-checked through traditional variant `應`.

| Item | Sources | Change |
|---|---|---|
| `勇` | KANJIDIC2 readings `ユウ`, `いさ.む`, meanings `courage`, `bravery`; Unihan `kVietnamese=dũng`, `kDefinition=brave, courageous, fierce`; local context `勇ましい` | Rewrote display to `Dũng (dũng cảm; can đảm; khí phách)`, added readings/search text, direct example `勇ましい`, and courage-related kanji. |
| `衣` | KANJIDIC2 readings `イ/エ`, `ころも/きぬ/-ぎ`, meanings `garment`, `clothes`; Unihan `kVietnamese=y`, `kDefinition=clothes, clothing`; local context `衣食住` | Rewrote display to `Y (áo quần; y phục; lớp phủ)`, added readings/search text, direct example `衣食住`, and clothing/life-necessity related kanji. |
| `食` | KANJIDIC2 readings `ショク/ジキ`, `く.う/く.らう/た.べる/は.む`, meanings `eat`, `food`; Unihan `kDefinition=eat; meal; food`; local source-verified content keeps Hán-Việt `Thực`; local context `衣食住` | Rewrote display to `Thực (ăn; thức ăn; bữa ăn)`, added readings/search text, direct example `衣食住`, and food-related kanji. |
| `住` | KANJIDIC2 readings `ジュウ/ヂュウ/チュウ`, `す.む/す.まう/-ず.まい`, meanings `dwell`, `reside`; Unihan `kVietnamese=trú`, `kDefinition=reside, live at`; local context `衣食住` | Rewrote display to `Trú (sống; cư trú; ở)`, added readings/search text, direct example `衣食住`, and housing-related kanji. |
| `地` | KANJIDIC2 readings `チ/ジ`, meanings `ground`, `earth`; Unihan `kVietnamese=địa`, `kDefinition=earth; soil, ground; region`; local context `意地悪` | Corrected the row away from generated `malicious` word-gloss fallback to `Địa (đất; mặt đất; vùng đất)`, normalized no-accent search text, and added land/idiom related kanji. |
| `悪` | KANJIDIC2 readings `アク/オ`, `わる.い/...`, meanings `bad`, `evil`, `wrong`; Unihan `kVietnamese=ác`, `kDefinition=evil, wicked, bad`; local context `意地悪` | Rewrote display to `Ác (xấu; ác; sai trái)`, added readings/search text, direct example `意地悪`, and polarity/morality related kanji. |
| `一` | KANJIDIC2 readings `イチ/イツ`, `ひと-/ひと.つ`, meanings `one`; Unihan `kVietnamese=nhất`, `kDefinition=one; a, an; alone`; local context `一応` | Corrected the row away from generated `tentatively` word-gloss fallback to `Nhất (một; đầu tiên; thống nhất)`, added readings/search text, direct example `一応`, and number/initial related kanji. |
| `応` | KANJIDIC2 readings `オウ/ヨウ/-ノウ`, `あた.る/まさに/こた.える`, meanings `apply`, `answer`, `reply`; Unihan direct codepoint has `kDefinition=should, ought to, must`, traditional variant `應` has `kVietnamese=ứng`; local context `一応` | Rewrote display to `Ứng (đáp lại; thích ứng; ứng với)`, added readings/search text, direct example `一応`, and response/interaction related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, kept `vi-editorial-codex-pass`, removed old approval markers, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `33` to `34` and added an N2 lesson-08 sentinel for `勇` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `144` to `136`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed `54`, and full `flutter test` passed (`2340`).

Live proof after deploy: after `c297667f` was deployed to Firebase Hosting, a cache-busted VI/N2 `/#/kanji` session loaded the N2 grid, filtering `勇` showed a single result, and opening it showed `Dũng (dũng cảm; can đảm; khí phách)`, Hán-Việt `Dũng`, on `ユウ`, kun `いさ.む`, and the rewritten Vietnamese mnemonic. Screenshot artifacts captured the filtered card and detail modal. Console note: the long-lived MCP browser had stale `Cache-Control`/CanvasKit noise from an earlier failed verification attempt, and a separate fresh headless context produced a generic Flutter `pageerror` while still seeding, so this entry claims visible deployed-content correctness, not a clean-console proof.

## Kanji N2 Lesson 9 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, old JLPT tier, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `一段と`, `一流`, `佚`, `一昨日`, `一昨年`, `一斉`, and `一旦`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.
- Wiktionary cross-check for the common Hán-Việt reading of `年` as `niên` (`https://en.wiktionary.org/wiki/%E5%B9%B4`, `https://en.wiktionary.org/wiki/ni%C3%AAn`), because Unihan currently lists `nên`, which is less useful for learner-facing Vietnamese compounds.

| Item | Sources | Change |
|---|---|---|
| `段` | KANJIDIC2 readings `ダン/タン`, meanings `grade`, `steps`, `stairs`; Unihan `kVietnamese=đoạn`, `kDefinition=section, piece, division`; local context `一段と` | Corrected the row away from generated `greater, more` word-gloss fallback to `Đoạn (bậc; đoạn; cấp độ)`, added readings/search text, direct example `一段と`, and level/step related kanji. |
| `流` | KANJIDIC2 readings `リュウ/ル`, `なが.れる/...`, meanings `current`, `flow`; Unihan `kVietnamese=lưu`, `kDefinition=flow, circulate, drift; class`; local context `一流` plus existing source-verified N3 `流` | Kept the verified kanji meaning `Lưu (dòng chảy; lưu hành; trôi)`, added class/rank usage in mnemonic, direct example `一流`, and flow/route related kanji. |
| `佚` | KANJIDIC2 readings `イツ/テツ`, `たのし.む/のが.れる`, meanings `lost`, `hide`, `peace`; Unihan `kVietnamese=dật`, `kDefinition=indulge in pleasures; flee`; local context `佚` | Rewrote display to `Dật (thất lạc; ẩn đi; nhàn tản)`, added readings/search text, direct example `佚`, and lost/escape related kanji. |
| `昨` | KANJIDIC2 reading `サク`, meanings `yesterday`, `previous`; Unihan `kDefinition=yesterday; in former times, past`; local context `一昨日` | Corrected the row away from generated `day before yesterday` word-gloss fallback to `Tạc (hôm qua; trước đó; quá khứ)`, direct example `一昨日`, search text, and time related kanji. |
| `日` | KANJIDIC2 readings `ニチ/ジツ`, `ひ/-び/-か`, meanings `day`, `sun`, `Japan`; Unihan `kVietnamese=nhật`; local lower-level source-verified row | Corrected the row away from generated `day before yesterday` word-gloss fallback to `Nhật (ngày; mặt trời; Nhật Bản)`, direct example `一昨日`, search text, and day/time related kanji. |
| `年` | KANJIDIC2 reading `ネン`, `とし`, meanings `year`, `counter for years`; Unihan `kDefinition=year; new-years; person's age`; Wiktionary Hán-Việt `niên`; local context `一昨年` | Corrected Hán-Việt display from `Nên` to learner-facing `Niên`, rewrote display to `Niên (năm; tuổi; niên đại)`, direct example `一昨年`, search text, and year/time related kanji. |
| `斉` | KANJIDIC2 readings `セイ/サイ`, `そろ.う/ひと.しい/...`, meanings `adjusted`, `alike`, `equal`; Unihan `kDefinition=even, uniform, of equal length`; local context `一斉` | Rewrote display to `Tề (đồng đều; ngang nhau; cùng lúc)`, added readings/search text, direct example `一斉`, and equality/order related kanji. |
| `旦` | KANJIDIC2 readings `タン/ダン`, morning-related kun readings, meanings `daybreak`, `dawn`, `morning`; Unihan `kVietnamese=đán`; local context `一旦` | Corrected the row away from generated `once, temporarily` word-gloss fallback to `Đán (bình minh; buổi sáng; một lúc)`, direct example `一旦`, search text, and morning/time related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `34` to `35` and added an N2 lesson-09 sentinel for `段` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `136` to `128`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed `54`, and full `flutter test` passed (`2340`).

Live proof after deploy: after `cfe2184e` was deployed to Firebase Hosting, the first normal Playwright reload still used the cached old Flutter runtime and showed stale lesson-09 readings. With CDP HTTP cache disabled (no global `Cache-Control` request header), a cache-busted VI/N2 `/#/kanji` session loaded the revision-35 metadata, filtering `段` showed the N2 lesson-09 card with on `ダン, タン`, and opening it showed `Đoạn (bậc; đoạn; cấp độ)`, Hán-Việt `Đoạn`, on `ダン, タン`, stroke count `9`, and the rewritten Vietnamese mnemonic. Console warnings/errors after the interaction: `0`.

## Kanji N2 Lesson 10 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Vietnamese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `一定`, `移転`, `井戸`, `緯度`, and `従姉妹`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `定` | KANJIDIC2 readings `テイ/ジョウ`, `さだ.める/さだ.まる/さだ.か`, meanings `determine`, `fix`, `establish`, `decide`; Unihan `kVietnamese=định`, `kDefinition=decide, settle, fix`; local context `一定` | Rewrote display to `Định (quyết định; cố định; ổn định)`, added readings/search text, direct example `一定`, and decision/stability related kanji. |
| `移` | KANJIDIC2 readings `イ`, `うつ.る/うつ.す`, Vietnamese `Di/Dị/Sỉ`; Unihan `kVietnamese=dời`, `kDefinition=change place, shift; move about`; local context `移転` | Corrected Hán-Việt from the meaning gloss `Dời` to learner-facing `Di`, rewrote display to `Di (di chuyển; chuyển dời; thay đổi)`, added readings/search text, direct example `移転`, and movement/change related kanji. |
| `転` | KANJIDIC2 reading `テン`, movement/turning kunyomi, Vietnamese `Chuyển`; Unihan `kDefinition=shift, move, turn`; local context `移転` plus existing N5 `転` | Rewrote display to `Chuyển (xoay; chuyển đổi; chuyển chỗ)`, added readings/search text, direct example `移転`, and vehicle/turn/change related kanji. |
| `井` | KANJIDIC2 readings `セイ/ショウ`, `い`, Vietnamese `Tỉnh`; Unihan `kVietnamese=tỉnh`, `kDefinition=well, mine shaft, pit`; local context `井戸` | Rewrote display to `Tỉnh (giếng; hầm; miệng giếng)`, added readings/search text, direct example `井戸`, and water/well related kanji. |
| `緯` | KANJIDIC2 stroke count `16`, reading `イ`, `よこいと/ぬき`, Vietnamese `Vĩ`; Unihan `kVietnamese=vĩ`, `kDefinition=woof; parallels of latitude`; local context `緯度` | Corrected stroke count from `15` to `16`, rewrote display to `Vĩ (vĩ tuyến; sợi ngang; chiều ngang)`, added readings/search text, direct example `緯度`, and latitude/thread related kanji. |
| `度` | KANJIDIC2 readings `ド/ト/タク`, `たび/-た.い`, Vietnamese `Độ/Đạc`; Unihan `kVietnamese=độ`, `kDefinition=degree, system; manner; to consider`; local context `緯度` | Corrected the row away from whole-word `latitude` fallback to `Độ (mức độ; lần; đo lường)`, added readings/search text, direct example `緯度`, and measure/degree related kanji. |
| `従` | KANJIDIC2 readings `ジュウ/ショウ/ジュ`, `したが.う/したが.える/より`, Vietnamese `Tòng/Tùng/Tường`; Unihan `kDefinition=from, by, since, whence, through`; local context `従姉妹` | Corrected the row away from whole-word `female cousin` fallback to `Tòng (đi theo; tuân theo; phụ thuộc)`, added readings/search text, direct example `従姉妹`, and follow/subordinate related kanji. |
| `姉` | KANJIDIC2 reading `シ`, `あね/はは`, Vietnamese `Tỉ/Tỷ/Chị`; Unihan `kVietnamese=chị`, `kDefinition=elder sister`; local lower-level source keeps learner-facing `Tỷ` | Corrected Hán-Việt display from plain `Chị` to `Tỷ`, rewrote display to `Tỷ (chị gái; người chị)`, added readings/search text, direct example `従姉妹`, and sibling/female related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `35` to `36` and added an N2 lesson-10 sentinel for `定` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `128` to `120`, focused DB/reachability/taxonomy/upper-JLPT tests passed after updating the upper-JLPT integrity guard to accept the newer `source-verified` import status, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), and full `flutter test` passed (`2340`).

Live proof after deploy: after `da2242bc` was deployed to Firebase Hosting, a CDP cache-disabled VI/N2 `/#/kanji` session loaded the revision-36 metadata. Filtering `定` showed the N2 lesson-10 card with Hán-Việt `Định` and on `テイ, ジョウ`; opening it showed `Định (quyết định; cố định; ổn định)`, Hán-Việt `Định`, on `テイ, ジョウ`, kun `さだ.める, さだ.まる, さだ.か`, stroke count `8`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal: `0`.

## Kanji N2 Lesson 11 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Vietnamese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `従姉妹`, `威張る`, `嫌がる`, `煎る`, `入れ物`, and `引力`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `妹` | KANJIDIC2 reading `マイ`, `いもうと`, Vietnamese `Muội`, meaning `younger sister`; Unihan `kVietnamese=muội`; local context `従姉妹` plus existing N5 `妹` | Corrected the row away from whole-word `female cousin` fallback to `Muội (em gái; người em nữ)`, added readings/search text, direct example `従姉妹`, and sibling/female related kanji. |
| `威` | KANJIDIC2 reading `イ`, `おど.す/おど.し/おど.かす`, meanings `intimidate`, `dignity`, `majesty`; Unihan `kVietnamese=uy`, `kDefinition=pomp, power; powerful`; local context `威張る` | Corrected the row away from whole-word `to be proud, to swagger` fallback to `Uy (uy thế; oai nghiêm; đe dọa)`, added readings/search text, direct example `威張る`, and authority/threat related kanji. |
| `張` | KANJIDIC2 reading `チョウ`, `は.る/-は.り/-ば.り`, meanings `stretch`, `spread`, `put up`; Unihan `kVietnamese=trương`; local context `威張る` plus source-verified N3 `張` | Reused the verified kanji-level meaning family and rewrote display to `Trương (căng ra; trải rộng; dựng lên)`, added readings/search text, direct example `威張る`, and bow/stretch related kanji. |
| `嫌` | KANJIDIC2 readings `ケン/ゲン`, `きら.う/きら.い/いや`, meanings `dislike`, `detest`, `hate`; Unihan `kVietnamese=hiềm`; local context `嫌がる` | Rewrote display to `Hiềm (ghét; chán ghét; không ưa)`, added readings/search text, direct example `嫌がる`, and dislike/emotion related kanji. |
| `煎` | KANJIDIC2 reading `セン`, `せん.じる/い.る/に.る`, Vietnamese `Tiên/Tiễn`, meanings `broil`, `parch`, `roast`, `boil`; Unihan `kDefinition=fry in fat or oil; boil in water`; local context `煎る` | Rewrote display to `Tiên (rang; sao; sắc thuốc)`, added readings/search text, direct example `煎る`, and heat/cooking related kanji. |
| `炒` | KANJIDIC2 readings `ソウ/ショウ`, `い.る/いた.める`, Vietnamese `Sao`, meanings `broil`, `parch`, `roast`, `fry`; Unihan `kVietnamese=sao`, `kDefinition=fry, saute, roast`; lesson context `炒る` | Filled the previously empty meaning row with `Sao (xào; rang; sao)`, added readings/search text, direct example `炒る`, and heat/cooking related kanji. |
| `入` | KANJIDIC2 readings `ニュウ/ジュ`, `い.る/い.れる/はい.る`, meanings `enter`, `insert`; Unihan `kVietnamese=nhập`; local context `入れ物` plus existing N5 `入` | Corrected the row away from whole-word `container` fallback to `Nhập (vào; cho vào; nhận vào)`, added readings/search text, direct example `入れ物`, and enter/inside related kanji. |
| `引` | KANJIDIC2 reading `イン`, `ひ.く/ひ.ける`, meanings `pull`, `draw`, `quote`; Unihan `kVietnamese=dẫn`; local context `引力` plus existing N5 `引` | Corrected the row away from whole-word `gravity` fallback to `Dẫn (kéo; dẫn; trích dẫn)`, added readings/search text, direct example `引力`, and pull/force related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `36` to `37` and added an N2 lesson-11 sentinel for `妹` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `120` to `112`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), and full `flutter test` passed (`2340`).

Live proof after deploy: after `fadf79fb` was deployed to Firebase Hosting, a CDP cache-disabled VI/N2 `/#/kanji` session loaded the revision-37 metadata. Filtering `妹` showed the updated N2 lesson-11 card; opening it showed `Muội (em gái; người em nữ)`, Hán-Việt `Muội`, on `マイ`, kun `いもうと`, stroke count `8`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 12 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Vietnamese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos vocabulary context for `引力`, `植木`, `飢える`, `浮ぶ`, `承る`, and `受取`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `力` | KANJIDIC2 readings `リョク/リキ`, `ちから`, Vietnamese `Lực`, meanings `power`, `strength`; Unihan `kVietnamese=lực`, `kDefinition=power, capability, influence`; local context `引力` | Corrected the row away from whole-word `gravity` fallback to `Lực (sức mạnh; lực; năng lực)`, added readings/search text, direct example `引力`, and power/force related kanji. |
| `植` | KANJIDIC2 reading `ショク`, `う.える/う.わる`, Vietnamese `Thực/Trĩ`, meaning `plant`; Unihan `kVietnamese=thực`, `kDefinition=plant, trees, plants; grow`; local context `植木` | Corrected the row away from whole-word `garden shrubs, trees, potted plant` fallback to `Thực (trồng; cây trồng; thực vật)`, added readings/search text, direct example `植木`, and plant/tree related kanji. |
| `木` | KANJIDIC2 readings `ボク/モク`, `き/こ-`, Vietnamese `Mộc`, meanings `tree`, `wood`; Unihan `kVietnamese=mộc`, `kDefinition=tree; wood`; local context `植木` plus lower-level `木` | Corrected the row away from whole-word `garden shrubs, trees, potted plant` fallback to `Mộc (cây; gỗ; thân cây)`, added readings/search text, direct example `植木`, and tree/wood related kanji. |
| `飢` | KANJIDIC2 reading `キ`, `う.える`, Vietnamese `Cơ`, meanings `hungry`, `starve`; Unihan `kVietnamese=cơ`, `kDefinition=hunger, starving; hungry; a famine`; local context `飢える` | Rewrote display to `Cơ (đói; đói khát; nạn đói)`, added readings/search text, direct example `飢える`, and hunger/food related kanji. |
| `浮` | KANJIDIC2 reading `フ`, `う.く/う.かれる/う.かぶ/う.かべる`, Vietnamese `Phù`, meanings `floating`, `float`, `rise to surface`; Unihan `kVietnamese=phù`, `kDefinition=to float, drift, waft`; local context `浮ぶ` | Rewrote display to `Phù (nổi; trôi; hiện lên)`, added readings/search text, direct example `浮ぶ`, and water/float related kanji. |
| `承` | KANJIDIC2 readings `ショウ/ジョウ`, `うけたまわ.る/う.ける`, Vietnamese `Thừa`, meanings `acquiesce`, `hear`, `receive`; Unihan `kVietnamese=thừa`, `kDefinition=inherit, receive; succeed`; local context `承る` | Corrected the row away from whole-word humble-gloss fallback to `Thừa (tiếp nhận; thừa nhận; kính nghe)`, added readings/search text, direct example `承る`, and receive/acknowledge related kanji. |
| `受` | KANJIDIC2 reading `ジュ`, `う.ける/う.かる`, Vietnamese `Thụ`, meanings `accept`, `undergo`, `receive`; Unihan `kVietnamese=thụ`, `kDefinition=receive, accept, get; bear, stand`; local context `受取` | Corrected the row away from whole-word `receipt` fallback to `Thụ (nhận; tiếp nhận; chịu)`, added readings/search text, direct example `受取`, and receive/pass related kanji. |
| `取` | KANJIDIC2 reading `シュ`, `と.る`, Vietnamese `Thủ`, meanings `take`, `fetch`, `take up`; Unihan `kVietnamese=thủ`, `kDefinition=take, receive, obtain; select`; local context `受取` | Corrected the row away from whole-word `receipt` fallback to `Thủ (lấy; nhận; chọn)`, added readings/search text, direct example `受取`, and take/receive related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `37` to `38` and added an N2 lesson-12 sentinel for `力` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `112` to `104`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), and full `flutter test` passed (`2340`).

Live proof after deploy: after `ce8ff3a6` was deployed to Firebase Hosting, a CDP cache-disabled and service-worker-bypassed VI/N2 `/#/kanji` session loaded the revision-38 metadata. Filtering `承` showed the updated N2 lesson-12 card; opening it showed `Thừa (tiếp nhận; thừa nhận; kính nghe)`, Hán-Việt `Thừa`, on `ショウ, ジョウ`, kun `うけたまわ.る, う.ける`, stroke count `8`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 13 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Vietnamese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos vocabulary context for `持つ`, `薄い`, `暗い`, `打つ`, `合う`, `消える`, `討つ`, and `映る`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `持` | KANJIDIC2 readings `ジ`, `も.つ/-も.ち/も.てる`, Vietnamese `Trì`, meanings `hold`, `have`; Unihan `kVietnamese=trì`, `kDefinition=sustain, support; hold, grasp`; local context `持つ` | Corrected the row away from whole-word fallback to `Trì (cầm; giữ; mang; duy trì)`, added readings/search text, direct example `持つ`, and hand/hold related kanji. |
| `薄` | KANJIDIC2 reading `ハク`, `うす.い/うす-/-うす/うす.める/うす.まる/うす.らぐ/うす.ら-`, Vietnamese `Bạc`, meanings `dilute`, `thin`, `weak`; Unihan `kVietnamese=bạc`, `kDefinition=thin, slight, weak`; local context `薄い` | Rewrote display to `Bạc (mỏng; nhạt; yếu)`, added readings/search text, direct example `薄い`, and thin/weak related kanji. |
| `暗` | KANJIDIC2 reading `アン`, `くら.い/くら.む/くれ.る`, Vietnamese `Ám`, meanings `darkness`, `disappear`, `shade`; Unihan `kVietnamese=ám`, `kDefinition=dark, obscure`; local context `暗い` | Rewrote display to `Ám (tối; u ám; không rõ)`, added readings/search text, direct example `暗い`, and dark/light related kanji. |
| `打` | KANJIDIC2 reading `ダ/ダース`, `う.つ/う.ち-/ぶ.つ`, Vietnamese `Đả`, meanings `strike`, `hit`; Unihan `kVietnamese=đả`, `kDefinition=strike, hit, beat`; local context `打つ` | Rewrote display to `Đả (đánh; gõ; tấn công)`, added readings/search text, direct example `打つ`, and hand/action related kanji. |
| `合` | KANJIDIC2 readings `ゴウ/ガッ/カッ`, `あ.う/-あ.う/あ.い/あい-/あ.わす/あ.わせる/-あ.わせる`, Vietnamese `Hợp`, meanings `fit`, `suit`, `join`; Unihan `kVietnamese=hợp`, `kDefinition=combine, unite, join`; local context `合う` | Corrected the row away from whole-word context to `Hợp (hợp; kết hợp; phù hợp)`, added readings/search text, direct example `合う`, and join/fit related kanji. |
| `消` | KANJIDIC2 reading `ショウ`, `き.える/け.す`, Vietnamese `Tiêu`, meanings `extinguish`, `turn off`, `cancel`; Unihan `kVietnamese=tiêu`, `kDefinition=vanish, die out; melt away`; local context `消える` | Rewrote display to `Tiêu (biến mất; dập tắt; xóa đi)`, added readings/search text, direct example `消える`, and vanish/remove related kanji. |
| `討` | KANJIDIC2 reading `トウ`, `う.つ`, Vietnamese `Thảo`, meanings `chastise`, `attack`, `defeat`; Unihan `kVietnamese=thảo`, `kDefinition=to discuss; ask for, demand; beg`; local context `討つ` | Rewrote display to `Thảo (đánh dẹp; thảo phạt; bàn luận)`, added readings/search text, direct example `討つ`, and attack/discuss related kanji. |
| `映` | KANJIDIC2 reading `エイ`, `うつ.る/うつ.す/は.える/-ば.え`, Vietnamese `Ánh`, meanings `reflect`, `projection`; Unihan `kVietnamese=ánh`, `kDefinition=project; reflect light`; local context `映る` | Rewrote display to `Ánh (phản chiếu; chiếu hình; nổi bật)`, added readings/search text, direct example `映る`, and light/image related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `38` to `39` and added an N2 lesson-13 sentinel for `持` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `104` to `96`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), and full `flutter test` passed (`2340`). Release web build succeeded before deploy.

Live proof after deploy: after `0601e111` was deployed to Firebase Hosting, a CDP cache-disabled and service-worker-bypassed VI/N2 `/#/kanji` session loaded the revision-39 metadata. Filtering `持` showed the updated N2 lesson-13 card; opening it showed `Trì (cầm; giữ; mang; duy trì)`, Hán-Việt `Trì`, on `ジ`, kun `も.つ, -も.ち, も.てる`, stroke count `9`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 14 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Vietnamese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `写る`, `有無`, `埋める`, `敬う`, `裏返す`, `裏口`, and `占う`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `写` | KANJIDIC2 readings `シャ/ジャ`, `うつ.す/うつ.る/うつ-/うつ.し`, Vietnamese `Tả`, meanings `copy`, `be photographed`, `describe`; Unihan `kDefinition=write; draw, sketch; compose`; local context `写る` | Corrected the row away from whole-word `to be photographed` fallback to `Tả (chụp lại; sao chép; phản chiếu)`, added readings/search text, direct example `写る`, and image/reflection related kanji. |
| `無` | KANJIDIC2 readings `ム/ブ`, `な.い`, Vietnamese `Vô/Mô`, meanings `nothingness`, `none`, `not`; Unihan `kVietnamese=vô`; local context `有無` plus source-verified N3 `無` | Reused the verified meaning family and rewrote display to `Vô (không; không có; vô)`, added readings/search text, direct example `有無`, and absence/opposition related kanji. |
| `埋` | KANJIDIC2 reading `マイ`, bury/fill kunyomi, Vietnamese `Mai`, meanings `bury`, `be filled up`, `embedded`; Unihan `kVietnamese=mai`, `kDefinition=bury, secrete, conceal`; local context `埋める` | Rewrote display to `Mai (chôn; lấp; bị vùi)`, added readings/search text, direct example `埋める`, and earth/bury related kanji. |
| `敬` | KANJIDIC2 readings `ケイ/キョウ`, `うやま.う`, Vietnamese `Kính`, meanings `awe`, `respect`, `honor`, `revere`; Unihan `kVietnamese=kính`; local context `敬う` | Rewrote display to `Kính (kính trọng; tôn trọng; kính cẩn)`, added readings/search text, direct example `敬う`, and respect/politeness related kanji. |
| `裏` | KANJIDIC2 reading `リ`, `うら`, Vietnamese `Lý`, meanings `back`, `reverse`, `inside`, `lining`; Unihan `kDefinition=inside, interior, within`; local context `裏返す` | Corrected the row away from whole-word `turn inside out` fallback to `Lý (mặt sau; bên trong; lớp lót)`, added readings/search text, direct example `裏返す`, and back/inside related kanji. |
| `返` | KANJIDIC2 reading `ヘン`, `かえ.す/かえ.る`, Vietnamese `Phản`, meanings `return`, `answer`, `repay`; Unihan `kVietnamese=phản`; local context `裏返す` plus source-verified N3 `返` | Corrected the row away from whole-word `turn inside out` fallback to `Phản (trả lại; quay lại; đáp lại)`, added readings/search text, direct example `裏返す`, and return/answer related kanji. |
| `口` | KANJIDIC2 readings `コウ/ク`, `くち`, Vietnamese `Khẩu`, meaning `mouth`; Unihan `kVietnamese=khẩu`, `kDefinition=mouth; open end; entrance, gate`; local context `裏口` plus lower-level `口` | Corrected the row away from whole-word `backdoor` fallback to `Khẩu (miệng; cửa vào; lối vào)`, added readings/search text, direct example `裏口`, and mouth/entrance related kanji. |
| `占` | KANJIDIC2 reading `セン`, `し.める/うらな.う`, Vietnamese `Chiêm/Chiếm`, meanings `fortune-telling`, `forecasting`, `occupy`; Unihan `kVietnamese=chiêm`; local context `占う` | Rewrote display to `Chiêm (bói; dự đoán; chiếm giữ)`, added readings/search text, direct example `占う`, and divination/forecast related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `39` to `40` and added an N2 lesson-14 sentinel for `写` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `96` to `88`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.

Live proof after deploy: after `133d038d` was deployed to Firebase Hosting, a CDP cache-disabled and service-worker-bypassed VI/N2 `/#/kanji` session loaded the revision-40 metadata. Filtering `写` showed the updated N2 lesson-14 card; opening it showed `Tả (chụp lại; sao chép; phản chiếu)`, Hán-Việt `Tả`, on `シャ, ジャ`, kun `うつ.す, うつ.る, うつ-, うつ.し`, stroke count `5`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 15 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, Vietnamese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` for `kVietnamese`, `kDefinition`, and Japanese-reading cross-checks where available.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `恨み`, `羨ましい`, `売上`, `売り切れ`, `売行き`, and `運河`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `恨` | KANJIDIC2 reading `コン`, `うら.む/うら.めしい`, Vietnamese `Hận`, meanings `regret`, `bear a grudge`, `resentment`, `hatred`; Unihan `kVietnamese=hận`, `kDefinition=hatred, dislike; resent, hate`; local context `恨み` | Rewrote display to `Hận (oán hận; thù hằn; nỗi hận)`, added readings/search text, direct example `恨み`, and emotion/resentment related kanji. |
| `羨` | KANJIDIC2 readings `セン/エン`, `うらや.む/あまり`, Vietnamese `Tiện`, meanings `envious`, `jealous`, `covet`; Unihan `kDefinition=envy, admire; praise; covet`; local context `羨ましい` | Rewrote display to `Tiện (ghen tị; ao ước; thèm muốn)`, added readings/search text, direct example `羨ましい`, and envy/desire related kanji. |
| `売` | KANJIDIC2 reading `バイ`, `う.る/う.れる`, Vietnamese `Mại`, meaning `sell`; Unihan `kDefinition=sell`; local context `売上` plus source-verified lower-level `売` | Corrected the row away from whole-word `amount sold, proceeds` fallback to `Mại (bán; buôn bán)`, added readings/search text, direct example `売上`, and commerce related kanji. |
| `上` | KANJIDIC2 readings `ジョウ/ショウ/シャン`, upper/up kunyomi, Vietnamese `Thượng`, meanings `above`, `up`; Unihan `kVietnamese=thượng`, `kDefinition=top; superior, highest; go up`; local context `売上` | Corrected the row away from whole-word `amount sold, proceeds` fallback to `Thượng (trên; lên; tăng)`, added readings/search text, direct example `売上`, and up/down related kanji. |
| `切` | KANJIDIC2 readings `セツ/サイ`, cut-off kunyomi, Vietnamese `Thiết`, meanings `cut`, `cutoff`, `sharp`; Unihan `kVietnamese=thiết`, `kDefinition=cut, mince, slice, carve`; local context `売り切れ` | Corrected the row away from whole-word `sold-out` fallback to `Thiết (cắt; đứt; sắc bén)`, added readings/search text, direct example `売り切れ`, and cut/end related kanji. |
| `行` | KANJIDIC2 readings `コウ/ギョウ/アン`, go/carry-out kunyomi, Vietnamese `Hành/Hàng`, meanings `going`, `journey`, `carry out`, `line`; Unihan `kDefinition=go; walk; move, travel`; local context `売行き` plus source-verified N3/N5 `行` | Corrected the row away from whole-word `sales` fallback to learner-facing `Hành (đi; thực hiện; hàng lối)`, added readings/search text, direct example `売行き`, and movement/route related kanji. |
| `運` | KANJIDIC2 reading `ウン`, `はこ.ぶ`, Vietnamese `Vận`, meanings `carry`, `luck`, `transport`, `advance`; Unihan `kVietnamese=vận`, `kDefinition=luck, fortune; ship, transport`; local context `運河` plus source-verified lower-level `運` | Corrected the row away from whole-word `canal` fallback to `Vận (vận chuyển; vận may; chuyển động)`, added readings/search text, direct example `運河`, and transport/path related kanji. |
| `河` | KANJIDIC2 reading `カ`, `かわ`, Vietnamese `Hà`, meaning `river`; Unihan `kVietnamese=hà`, `kDefinition=river; stream; the Yellow River`; local context `運河` | Corrected the row away from whole-word `canal` fallback to `Hà (sông; dòng sông)`, added readings/search text, direct example `運河`, and river/water related kanji. |

Tagging: added file-level and entry-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `40` to `41` and added an N2 lesson-15 sentinel for `恨` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `88` to `80`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.

Live proof after deploy: after `8d39fa0c` was deployed to Firebase Hosting, a CDP cache-disabled and service-worker-bypassed VI/N2 `/#/kanji` session loaded the revision-41 metadata. Filtering `恨` showed the updated N2 lesson-15 card; opening it showed `Hận (oán hận; thù hằn; nỗi hận)`, Hán-Việt `Hận`, on `コン`, kun `うら.む, うら.めしい`, stroke count `9`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 16 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, Japanese-reading cross-checks, and `kTotalStrokes`.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `英文`, `英和`, `液体`, `絵の具`, and `偉い`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.
- Wiktionary spot-check for `液` (`https://en.wiktionary.org/wiki/%E6%B6%B2`, `https://ja.wiktionary.org/wiki/%E6%B6%B2`, `https://vi.wiktionary.org/wiki/%E6%B6%B2`): the open entries list Vietnamese/Hán-Nôm readings including `giá` and `dịch`; this resolved the learner-facing Hán-Việt label to `Dịch` despite Unihan's `kVietnamese=giá`.

| Item | Sources | Change |
|---|---|---|
| `英` | KANJIDIC2 reading `エイ`, `はなぶさ`, meanings `England`, `English`, `hero`, `outstanding`; Unihan `kVietnamese=anh`; local context `英文` | Corrected the row away from whole-word `sentence in English` fallback to `Anh (Anh; nước Anh; tiếng Anh; ưu tú)`, added readings/search text, direct example `英文`, and English/language related kanji. |
| `文` | KANJIDIC2 readings `ブン/モン`, `ふみ/あや`, meanings `sentence`, `literature`, `writing`; Unihan `kVietnamese=văn`; local context `英文` | Rewrote display to `Văn (văn; chữ viết; câu văn; văn chương)`, added readings/search text, direct example `英文`, and writing/language related kanji. |
| `和` | KANJIDIC2 readings `ワ/オ/カ`, harmony/Japanese-style kunyomi, meanings `harmony`, `Japanese style`, `peace`, `Japan`; Unihan `kVietnamese=hoà`; local context `英和` | Corrected the row away from whole-word `English-Japanese dictionary` fallback to `Hoà (hòa; hòa hợp; Nhật Bản; kiểu Nhật)`, added readings/search text, direct example `英和`, and Japan/harmony related kanji. |
| `液` | KANJIDIC2 reading `エキ`, meanings `fluid`, `liquid`, `juice`, `sap`; Unihan `kTotalStrokes=11`; Wiktionary cross-check for learner-facing `Dịch`; local context `液体` | Corrected the row away from English `liquid, fluid` and Unihan-only `Giá` to learner-facing `Dịch (dịch; chất lỏng; chất dịch)`, added readings/search text, direct example `液体`, and liquid/water related kanji. |
| `体` | KANJIDIC2 readings `タイ/テイ`, `からだ/かたち`, meanings `body`, `substance`, `object`; Unihan `kVietnamese=thể`; local context `液体` | Corrected the row away from whole-word `liquid, fluid` fallback to `Thể (thể; thân thể; cơ thể; vật thể)`, added readings/search text, direct example `液体`, and body/form related kanji. |
| `絵` | KANJIDIC2 readings `カイ/エ`, meanings `picture`, `drawing`, `painting`; Unihan Japanese reading cross-check; local context `絵の具` | Rewrote display to `Hội (hội; tranh; hình vẽ; hội họa)`, added readings/search text, direct example `絵の具`, and picture/color related kanji. |
| `具` | KANJIDIC2 reading `グ`, `そな.える/つぶさ.に`, meanings `tool`, `utensil`, `means`, `ingredients`; Unihan `kVietnamese=cụ`; local context `絵の具` | Corrected the row away from whole-word `colors, paints` fallback to `Cụ (cụ; dụng cụ; thành phần; phương tiện)`, added readings/search text, direct example `絵の具`, and tool/use related kanji. |
| `偉` | KANJIDIC2 reading `イ`, `えら.い`, meanings `admirable`, `great`, `remarkable`, `famous`; Unihan `kVietnamese=vĩ`, `kTotalStrokes=11`; local context `偉い` | Rewrote display to `Vĩ (vĩ; vĩ đại; nổi bật; đáng nể)`, added readings/search text, direct example `偉い`, and greatness/person related kanji. |

Tagging: added entry-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `41` to `42` and added an N2 lesson-16 sentinel for `英` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `80` to `72`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.

Live proof after deploy: after `1f97e53b` was deployed to Firebase Hosting, a CDP cache-disabled and service-worker-bypassed VI/N2 `/#/kanji` session loaded the revision-42 metadata. Filtering `英` showed the updated N2 lesson-16 card with `Học chữ 英, Hán-Việt Anh, âm On エイ, âm Kun はなぶさ`; opening it showed `Anh (Anh; nước Anh; tiếng Anh; ưu tú)`, Hán-Việt `Anh`, on `エイ`, kun `はなぶさ`, stroke count `8`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 17 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for stroke counts, Japanese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `宴会`, `園芸`, `演劇`, and `円周`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `宴` | KANJIDIC2 reading `エン`, `うたげ`, meanings `banquet`, `feast`, `party`; Unihan `kVietnamese=yến`; local context `宴会` | Corrected the row away from whole-word `party, banquet` fallback to `Yến (yến; tiệc; yến tiệc; tiệc rượu)`, added readings/search text, direct example `宴会`, and banquet-related kanji. |
| `会` | KANJIDIC2 readings `カイ/エ`, meeting/meet kunyomi, Vietnamese `Hội`, meanings `meeting`, `meet`, `party`, `association`; Unihan `kVietnamese=hội`; local context `宴会` | Corrected the row away from whole-word banquet fallback to `Hội (hội; gặp gỡ; cuộc họp; hội nhóm)`, added readings/search text, direct example `宴会`, and gathering-related kanji. |
| `園` | KANJIDIC2 reading `エン`, `その`, Vietnamese `Viên`, meanings `park`, `garden`, `yard`, `farm`; Unihan `kVietnamese=viên`; local context `園芸` | Corrected the row away from whole-word horticulture fallback to `Viên (viên; vườn; công viên; khu vườn)`, added readings/search text, direct example `園芸`, and garden-related kanji. |
| `芸` | KANJIDIC2 readings `ゲイ/ウン`, technique/art/craft meanings, Vietnamese `Nghệ`; Unihan cross-check; local context `園芸` | Rewrote display to `Nghệ (nghệ; nghệ thuật; kỹ nghệ; kỹ thuật)`, added readings/search text, direct example `園芸`, and art/technique related kanji. |
| `演` | KANJIDIC2 reading `エン`, meanings `performance`, `act`, `play`; Unihan `kVietnamese=diễn`; local context `演劇` | Corrected the row away from whole-word theatrical-play fallback to `Diễn (diễn; biểu diễn; diễn xuất; trình bày)`, added readings/search text, direct example `演劇`, and performance-related kanji. |
| `劇` | KANJIDIC2 reading `ゲキ`, Vietnamese `Kịch`, meanings `drama`, `play`, `theatre`; Unihan `kVietnamese=kịch`; local context `演劇` | Corrected the row away from whole-word theatrical-play fallback to `Kịch (kịch; sân khấu; vở kịch)`, added readings/search text, direct example `演劇`, and theatre-related kanji. |
| `円` | KANJIDIC2 reading `エン`, round/circle/yuan/yen meanings, Vietnamese `Viên`; Unihan `kVietnamese=viên`; local context `円周` | Corrected the row away from whole-word circumference fallback to `Viên (viên; tròn; đồng yên; vòng tròn)`, added readings/search text, direct example `円周`, and circle/money related kanji. |
| `周` | KANJIDIC2 reading `シュウ`, `まわ.り`, Vietnamese `Chu`, meanings `circumference`, `circuit`, `lap`; Unihan `kVietnamese=chu`; local context `円周` | Corrected the row away from whole-word circumference fallback to `Chu (chu; chu vi; vòng quanh; xung quanh)`, added readings/search text, direct example `円周`, and around/circuit related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `42` to `43` and added an N2 lesson-17 sentinel for `宴` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `72` to `64`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.

Live proof after deploy: after `88aca79a` was deployed to Firebase Hosting, VI/N2 `/#/kanji` loaded the Kanji explore surface. Filtering `宴` showed the updated two-card keyword result (`宴`, `会`); opening `宴` showed `Yến (yến; tiệc; yến tiệc; tiệc rượu)`, Hán-Việt `Yến`, on `エン`, kun `うたげ`, stroke count `10`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 18 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, Vietnamese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and stroke cross-checks.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `遠足`, `延長`, `煙突`, `追い掛ける`, and `追い越す`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `遠` | KANJIDIC2 readings `エン/オン`, `とお.い`, Vietnamese `Viễn/Viển`, meanings `distant`, `far`; Unihan `kVietnamese=viễn`; local context `遠足` | Corrected the row away from whole-word `trip, hike, picnic` fallback to `Viễn (viễn; xa; xa xôi; cách xa)`, added readings/search text, direct example `遠足`, and distance/travel related kanji. |
| `延` | KANJIDIC2 reading `エン`, stretch/prolong kunyomi, Vietnamese `Duyên`, meanings `prolong`, `stretching`; Unihan has divergent `kVietnamese=dang`, so the learner-facing label follows KANJIDIC2; local context `延長` | Corrected `Dang` and whole-word extension fallback to `Duyên (duyên; kéo dài; gia hạn; duỗi ra)`, corrected stroke count to KANJIDIC2 Japanese count `8`, added readings/search text, direct example `延長`, and extend/time related kanji. |
| `長` | KANJIDIC2 reading `チョウ`, `なが.い/おさ`, Vietnamese `Trường/Trưởng/Trướng`, meanings `long`, `leader`, `senior`; Unihan `kVietnamese=trường`; local context `延長` | Corrected the row away from whole-word extension fallback to `Trường (trường; dài; độ dài; người đứng đầu)`, added readings/search text, direct example `延長`, and long/short related kanji. |
| `煙` | KANJIDIC2 reading `エン`, smoke kunyomi, Vietnamese `Yên`, meaning `smoke`; Unihan `kDefinition=smoke, soot; opium; tobacco, cigarettes`; local context `煙突` | Corrected the row away from whole-word `chimney` fallback to `Yên (yên; khói; khói thuốc)`, added readings/search text, direct example `煙突`, and smoke/fire related kanji. |
| `突` | KANJIDIC2 reading `トツ`, `つ.く`, Vietnamese `Đột`, meanings `thrust`, `pierce`, `sudden`; Unihan stroke cross-check differs, so the Japanese learner count follows KANJIDIC2 `8`; local context `煙突` | Corrected the row away from whole-word `chimney` fallback to `Đột (đột; đâm; lao vào; đột ngột)`, added readings/search text, direct example `煙突`, and protrude/collision related kanji. |
| `追` | KANJIDIC2 reading `ツイ`, `お.う`, Vietnamese `Truy`, meanings `chase`, `follow`, `pursue`; Unihan `kVietnamese=truy`; local context `追い掛ける` | Corrected the row away from whole-word chase verb fallback to `Truy (truy; đuổi theo; truy đuổi; theo sau)`, added readings/search text, direct example `追い掛ける`, and chase/movement related kanji. |
| `掛` | KANJIDIC2 readings `カイ/ケイ`, hang/suspend kunyomi, Vietnamese `Quải`; Unihan lists `quẩy`, so the learner-facing label follows KANJIDIC2; local context `追い掛ける` | Corrected `Quẩy` and whole-word chase verb fallback to `Quải (quải; treo; móc; bắt đầu làm)`, added readings/search text, direct example `追い掛ける`, and hand/hang related kanji. |
| `越` | KANJIDIC2 readings `エツ/オツ`, `こ.す/こ.える`, Vietnamese `Việt/Hoạt`, meanings `surpass`, `cross over`, `exceed`; Unihan `kVietnamese=việt`; local context `追い越す` | Corrected the row away from whole-word passing verb fallback to `Việt (việt; vượt qua; băng qua; vượt hơn)`, added readings/search text, direct example `追い越す`, and surpass/crossing related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `43` to `44` and added an N2 lesson-18 sentinel for `遠` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `64` to `56`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.

Live proof after deploy: after `1dc4252f` was deployed to Firebase Hosting, VI/N2 `/#/kanji` loaded the Kanji explore surface. Filtering `遠` showed the updated one-card keyword result; opening `遠` showed `Viễn (viễn; xa; xa xôi; cách xa)`, Hán-Việt `Viễn`, on `エン, オン`, kun `とお.い`, stroke count `13`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 19 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, Vietnamese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and stroke cross-checks.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `応援`, `王女`, `応接`, `応対`, `往復`, and `欧米`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `援` | KANJIDIC2 reading `エン`, Vietnamese `Viên/Viện`, meanings `abet`, `help`, `save`; Unihan `kVietnamese=viện`; local context `応援` | Corrected the row away from whole-word `aid, assistance, help, reinforcement` fallback to `Viện (viện; hỗ trợ; viện trợ; cứu giúp)`, added readings/search text, direct example `応援`, and support-related kanji. |
| `王` | KANJIDIC2 readings `オウ/-ノウ`, Vietnamese `Vương/Vượng`, meanings `king`, `rule`, `magnate`; Unihan `kVietnamese=vương`; local context `王女` | Corrected the row away from whole-word `princess` fallback to `Vương (vương; vua; hoàng gia; người cai trị)`, added readings/search text, direct example `王女`, and royal-related kanji. |
| `女` | KANJIDIC2 readings `ジョ/ニョ/ニョウ`, `おんな/め`, learner-facing Vietnamese `Nữ`; Unihan lists a less useful `nữa`; local context `王女` | Corrected `Nữa` and whole-word princess fallback to `Nữ (nữ; phụ nữ; con gái; giống cái)`, added readings/search text, direct example `王女`, and female/family related kanji. |
| `接` | KANJIDIC2 readings `セツ/ショウ`, `つ.ぐ`, Vietnamese `Tiếp`, meanings `touch`, `contact`, `adjoin`, `piece together`; Unihan `kVietnamese=tiếp`; local context `応接` | Corrected the row away from whole-word `reception` fallback to `Tiếp (tiếp; tiếp xúc; nối liền; tiếp đãi)`, added readings/search text, direct example `応接`, and contact-related kanji. |
| `対` | KANJIDIC2 readings `タイ/ツイ`, Vietnamese `Đối`, meanings `vis-a-vis`, `opposite`, `versus`, `compare`; local context `応対` | Corrected the row away from whole-word `receiving, dealing with` fallback to `Đối (đối; đối diện; đối với; so sánh)`, added readings/search text, direct example `応対`, and comparison/opposition related kanji. |
| `往` | KANJIDIC2 reading `オウ`, `ゆ.く/い.く/いにしえ`, Vietnamese `Vãng`, meanings `journey`, `travel`, `going`, `formerly`; Unihan `kVietnamese=vãng`; local context `往復` | Corrected the row away from whole-word round-trip fallback to `Vãng (vãng; đi; đi qua; quá khứ)`, added readings/search text, direct example `往復`, and travel/return related kanji. |
| `復` | KANJIDIC2 reading `フク`, `また`, Vietnamese `Phục/Phúc`, meanings `restore`, `return to`, `resume`; local context `往復` | Corrected the row away from whole-word round-trip fallback to `Phục (phục; trở lại; khôi phục; lặp lại)`, added readings/search text, direct example `往復`, and return/restore related kanji. |
| `欧` | KANJIDIC2 reading `オウ`, Vietnamese `Âu`, meaning `Europe`; local context `欧米` | Corrected the row away from whole-word `Europe and America, the West` fallback to `Âu (Âu; châu Âu; phương Tây)`, added readings/search text, direct example `欧米`, and West/Europe related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `44` to `45` and added an N2 lesson-19 sentinel for `援` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `56` to `48`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.

Live proof after deploy: after `6e758b11` was deployed to Firebase Hosting, VI/N2 `/#/kanji` loaded the Kanji explore surface. Filtering `援` showed the updated one-card keyword result; opening `援` showed `Viện (viện; hỗ trợ; viện trợ; cứu giúp)`, Hán-Việt `Viện`, on `エン`, stroke count `12`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 20 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, Vietnamese readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and stroke cross-checks.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `欧米`, `応用`, `大通り`, `大凡`, `お帰り`, `拝む`, and `お代わり`, used only to choose example words and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `米` | KANJIDIC2 readings `ベイ/マイ/メエトル`, `こめ/よね`, Vietnamese `Mễ`, meanings `rice`, `USA`, `metre`; Unihan `kDefinition=hulled or husked uncooked rice`; local context `欧米` | Corrected the row away from whole-word `Europe and America, the West` fallback to `Mễ (mễ; gạo; lúa gạo; Hoa Kỳ)`, added readings/search text, direct example `欧米`, and rice/USA related kanji. |
| `用` | KANJIDIC2 reading `ヨウ`, `もち.いる`, Vietnamese `Dụng`, meanings `utilize`, `use`, `employ`; Unihan `kVietnamese=dụng`; local context `応用` | Corrected the row away from whole-word `application, put to practical use` fallback to `Dụng (dụng; dùng; sử dụng; công dụng)`, added readings/search text, direct example `応用`, and use/application related kanji. |
| `大` | KANJIDIC2 readings `ダイ/タイ`, large/big kunyomi, Vietnamese `Đại/Thái`, meanings `large`, `big`; Unihan `kVietnamese=đại`; local context `大通り` | Corrected the row away from whole-word `main street` fallback to `Đại (đại; lớn; to; rộng)`, added readings/search text, direct example `大通り`, and size/street related kanji. |
| `通` | KANJIDIC2 readings `ツウ/ツ`, pass-through kunyomi, Vietnamese `Thông`, meanings `traffic`, `pass through`, `avenue`, `commute`; Unihan `kVietnamese=thông`; local context `大通り` | Corrected the row away from whole-word `main street` fallback to `Thông (thông; đi qua; lưu thông; đường phố)`, added readings/search text, direct example `大通り`, and traffic/road related kanji. |
| `凡` | KANJIDIC2 readings `ボン/ハン`, `およ.そ/おうよ.そ/すべ.て`, Vietnamese `Phàm`, meanings `ordinary`, `commonplace`, `mediocre`; Unihan `kVietnamese=phàm`; local context `大凡` | Corrected the row away from whole-word approximate fallback to `Phàm (phàm; bình thường; đại khái; nói chung)`, added readings/search text, direct example `大凡`, and ordinary/general related kanji. |
| `帰` | KANJIDIC2 reading `キ`, return kunyomi, Vietnamese `Quy`, meanings `homecoming`, `arrive at`, `lead to`; Unihan `kDefinition=return; return to, revert to`; local context `お帰り` | Corrected the row away from whole-word greeting fallback to `Quy (quy; trở về; quay lại; quy về)`, added readings/search text, direct example `お帰り`, and return/home related kanji. |
| `拝` | KANJIDIC2 reading `ハイ`, `おが.む/おろが.む`, Vietnamese source variant `Bài`; Unihan `kDefinition=do obeisance, bow, kowtow`; local context `拝む` | Kept learner-facing `Bái` for the Japanese shinjitai of `拜`, corrected the row away from whole-word verb fallback to `Bái (bái; lễ bái; cúi lạy; cầu xin)`, added readings/search text, direct example `拝む`, and prayer/respect related kanji. |
| `代` | KANJIDIC2 readings `ダイ/タイ`, substitute/generation kunyomi, Vietnamese `Đại`, meanings `substitute`, `replace`, `generation`, `fee`; Unihan `kVietnamese=đại`; local context `お代わり` | Corrected the row away from whole-word second-helping fallback to `Đại (đại; thay thế; đời; thế hệ)`, added readings/search text, direct example `お代わり`, and replacement/generation related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `45` to `46` and added an N2 lesson-20 sentinel for `米` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, no false approval/draft tags remained in the file, coverage audit reduced N2 incomplete current entries from `48` to `40`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), and release web build succeeded.

Live proof after deploy: after `1ed515fd` was deployed to Firebase Hosting, VI/N2 `/#/kanji` loaded the Kanji explore surface. Filtering `米` showed keyword results; opening `米` showed `Mễ (mễ; gạo; lúa gạo; Hoa Kỳ)`, Hán-Việt `Mễ`, on `ベイ, マイ, メエトル`, kun `こめ, よね`, stroke count `6`, and the rewritten mnemonic. Console warnings/errors after opening the detail modal in the current tab: `0`.

## Kanji N2 Lesson 21 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `仮` and `怠` have no Unihan `kVietnamese`, so the learner-facing Hán-Việt values keep established local readings.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `補う`, `屋外`, `送り仮名`, `怠る`, `押える`, `納める`, and `治める`, used only to choose examples and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `補` | KANJIDIC2 reading `ホ`, `おぎな.う`, meanings `supplement`, `supply`, `compensate`; Unihan `kVietnamese=bổ`; local context `補う` | Corrected the row away from whole-word `to compensate for` fallback to `Bổ (bổ sung; bù đắp; hỗ trợ)`, added readings/search text, direct example `補う`, and supplement/supply related kanji. |
| `屋` | KANJIDIC2 reading `オク`, `や`, meanings `roof`, `house`, `shop`; Unihan `kVietnamese=ốc`; local context `屋外` | Corrected the row away from whole-word `outdoors` fallback to `Ốc (nhà; cửa hàng; mái nhà)`, added readings/search text, direct example `屋外`, and house/outside related kanji. |
| `送` | KANJIDIC2 reading `ソウ`, `おく.る`, meanings `escort`, `send`; Unihan `kVietnamese=tống`; local context `送り仮名` | Corrected the row away from whole-word okurigana fallback to `Tống (gửi đi; đưa tiễn; chuyển đi)`, added readings/search text, direct example `送り仮名`, and send/return/kana related kanji. |
| `仮` | KANJIDIC2 readings `カ/ケ`, `かり/かり-`, meanings `sham`, `temporary`, `interim`, `informal`; Unihan has no `kVietnamese`; local context `送り仮名` | Rewrote display to `Giả (tạm; giả định; không chính thức)`, added readings/search text, direct example `送り仮名`, and kana-related neighbors. |
| `怠` | KANJIDIC2 reading `タイ`, `おこた.る/なま.ける`, meanings `neglect`, `laziness`; Unihan has no `kVietnamese`; local context `怠る` | Corrected the row away from overlong English verb fallback to `Đãi (lơ là; sao nhãng; lười biếng)`, added readings/search text, direct example `怠る`, and attention/effort related kanji. |
| `押` | KANJIDIC2 reading `オウ`, press/push kunyomi, meanings `push`, `stop`, `check`, `subdue`; Unihan `kVietnamese=áp`; local context `押える` | Corrected the row away from whole-word verb fallback to `Áp (ấn; đẩy; đè xuống; kìm giữ)`, added readings/search text, direct example `押える`, and hand/pressure related kanji. |
| `納` | KANJIDIC2 readings `ノウ/ナッ/ナ/ナン/トウ`, `おさ.める/おさ.まる`, meanings `settlement`, `obtain`, `pay`, `supply`, `store`; Unihan `kVietnamese=nạp`; local context `納める` | Corrected the row away from whole-word verb fallback to `Nạp (nộp; thu nhận; cất giữ; chấp nhận)`, added readings/search text, direct example `納める`, and collect/tax/supply related kanji. |
| `治` | KANJIDIC2 readings `ジ/チ`, govern/heal kunyomi, meanings `rule`, `cure`, `heal`, `calm down`; Unihan `kVietnamese=trị`; local context `治める` | Corrected the row away from whole-word govern verb fallback to `Trị (cai trị; chữa trị; ổn định)`, added readings/search text, direct example `治める`, and politics/treatment related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `46` to `47` and added an N2 lesson-21 sentinel for `補` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit reduced N2 incomplete current entries from `40` to `32`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `3de785e8` was deployed to Firebase Hosting, a VI/N2 production browser session loaded `/#/kanji` without Kanji data failure. A no-store browser fetch of the deployed asset `/assets/assets/data/content/kanji/n2/lesson_21.json` returned `importStatus=source-verified`; `補` showed `Bổ (bổ sung; bù đắp; hỗ trợ)`, Hán-Việt `Bổ`, on `ホ`, kun `おぎな.う`, stroke count `12`, and example `補う` = `bù đắp; bổ sung`. Current-tab console warnings/errors: `0`.

## Kanji N2 Lesson 22 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `父` has no Unihan `kVietnamese`, so the learner-facing Hán-Việt value keeps the established Sino-Vietnamese reading.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `惜しい`, `御辞儀`, `伯父さん`, `小父さん`, and `叔父さん`, used only to choose examples and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `惜` | KANJIDIC2 reading `セキ`, `お.しい/お.しむ`, meanings `pity`, `regret`, `be sparing of`; Unihan `kVietnamese=tiếc`; local context `惜しい` | Corrected the row away from the whole-word adjective fallback to `Tiếc (đáng tiếc; trân trọng; không nỡ)`, added readings/search text, direct example `惜しい`, and regret/heart related kanji. |
| `御` | KANJIDIC2 readings `ギョ/ゴ`, honorific prefix meanings; Unihan `kVietnamese=ngự`; local context `御辞儀` | Corrected the row away from whole-word `bow` fallback to `Ngự (kính ngữ; điều khiển; cai quản)`, added readings/search text, direct example `御辞儀`, and polite/ritual related kanji. |
| `辞` | KANJIDIC2 reading `ジ`, word/resign meanings; Unihan `kVietnamese=từ`; local context `御辞儀` | Corrected the row away from whole-word `bow` fallback to `Từ (lời nói; thuật ngữ; từ chức)`, added readings/search text, direct example `御辞儀`, and language/expression related kanji. |
| `儀` | KANJIDIC2 reading `ギ`, ceremony/rite meanings; Unihan `kVietnamese=nghi`; local context `御辞儀` | Corrected the row away from whole-word `bow` fallback to `Nghi (nghi lễ; phép tắc; nghi thức)`, added readings/search text, direct example `御辞儀`, and ritual/manners related kanji. |
| `伯` | KANJIDIC2 reading `ハク`, chief/earl/uncle meanings; Unihan `kVietnamese=bá`; local context `伯父さん` | Corrected the row away from whole-word `uncle` fallback to `Bá (bác trai; bậc trưởng; tước bá)`, added readings/search text, direct example `伯父さん`, and family/rank related kanji. |
| `父` | KANJIDIC2 reading `フ`, `ちち`, meaning `father`; no Unihan `kVietnamese`; local context `伯父さん` | Corrected the row away from whole-word `uncle` fallback to `Phụ (cha; bố)`, added readings/search text, direct example `伯父さん`, and parent/family related kanji. |
| `小` | KANJIDIC2 reading `ショウ`, small kunyomi, meanings `little`, `small`; Unihan `kVietnamese=tiểu`; local context `小父さん` | Corrected the row away from whole-word `middle-aged gentleman` fallback to `Tiểu (nhỏ; bé; ít)`, added readings/search text, direct example `小父さん`, and size/child related kanji. |
| `叔` | KANJIDIC2 reading `シュク`, uncle/youth meanings; Unihan `kVietnamese=thúc`; local context `叔父さん` | Corrected the row away from whole-word `uncle` fallback to `Thúc (chú; em trai của cha; trẻ tuổi)`, added readings/search text, direct example `叔父さん`, and younger-family related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `47` to `48` and added an N2 lesson-22 sentinel for `惜` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit reduced N2 incomplete current entries from `32` to `24`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `5dd4c6e0` and the QA-A-017 header redeploy were on Firebase Hosting, a VI/N2 production browser session loaded `/#/kanji` without Kanji data failure. A normal-cache browser fetch of deployed `/assets/assets/data/content/kanji/n2/lesson_22.json` returned `Cache-Control: no-cache`, `lessonId=22`, and `count=8`; `惜` showed `Tiếc (đáng tiếc; trân trọng; không nỡ)`, Hán-Việt `Tiếc`, on `セキ`, kun `お.しい/お.しむ`, stroke count `11`, and example `惜しい` = `đáng tiếc; phí; quý giá`. The same proof confirmed `main.dart.js`, `flutter_bootstrap.js`, `flutter.js`, `AssetManifest`, and content JSON all revalidate with `no-cache`, while `sqlite3.wasm` and `drift_worker.js` keep `public, max-age=2592000`. Current-tab console warnings/errors: `0`.

## Kanji N2 Lesson 23 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `着` lacks Unihan `kVietnamese`, and `伝` lacks Unihan `kVietnamese`, so both keep established learner-facing Hán-Việt readings from existing verified app data.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `教わる`, `落着く`, `御手洗`, `お手伝いさん`, `驚かす`, and `各々`, used only to choose examples and verify the already editorial Vietnamese vocab glosses.

| Item | Sources | Change |
|---|---|---|
| `教` | KANJIDIC2 reading `キョウ`, `おし.える/おそ.わる`, meanings `teach`, `faith`, `doctrine`; Unihan `kVietnamese=giáo`; local context `教わる` | Corrected the row away from whole-word `to be taught` fallback to `Giáo (dạy; giáo dục; giáo lý)`, added readings/search text, direct example `教わる`, and education-related kanji. |
| `落` | KANJIDIC2 reading `ラク`, fall/drop meanings; Unihan `kVietnamese=lạc`; local context `落着く` | Corrected the row away from whole-word calm-down fallback to `Lạc (rơi; rụng; lắng xuống)`, added readings/search text, direct example `落着く`, and fall/settle related kanji. |
| `着` | KANJIDIC2 readings `チャク/ジャク`, wearing/arriving meanings; Unihan has no `kVietnamese`; local verified rows use `Trước`; local context `落着く` | Corrected the row away from whole-word calm-down fallback to `Trước (mặc; đến nơi; bám vào)`, corrected stroke count to KANJIDIC2 Japanese count `12`, added readings/search text, direct example `落着く`, and clothing/arrival related kanji. |
| `手` | KANJIDIC2 readings `シュ/ズ`, `て`, meaning `hand`; Unihan `kVietnamese=thủ`; local context `御手洗` | Corrected the row away from whole-word purification-font fallback to `Thủ (tay; người làm; kỹ năng)`, added readings/search text, direct example `御手洗`, and hand/action related kanji. |
| `洗` | KANJIDIC2 reading `セン`, `あら.う`, wash/probe meanings; Unihan `kVietnamese=tẩy`; local context `御手洗` | Corrected the row away from whole-word purification-font fallback to `Tẩy (rửa; gột; làm sạch)`, added readings/search text, direct example `御手洗`, and water/cleaning related kanji. |
| `伝` | KANJIDIC2 readings `デン/テン`, transmit/communicate/tradition meanings; Unihan has no `kVietnamese`; local verified rows use `Truyền`; local context `お手伝いさん` | Corrected the row away from whole-word `maid` fallback to `Truyền (truyền đạt; truyền lại; truyền thống)`, added readings/search text, direct example `お手伝いさん`, and communication/tradition related kanji. |
| `驚` | KANJIDIC2 reading `キョウ`, surprise/fright meanings; Unihan `kVietnamese=kinh`; local context `驚かす` | Corrected the row away from whole-word causative verb fallback to `Kinh (ngạc nhiên; kinh sợ; làm giật mình)`, added readings/search text, direct example `驚かす`, and surprise/fear related kanji. |
| `各` | KANJIDIC2 reading `カク`, `おのおの`, each/every meanings; Unihan `kVietnamese=các`; local context `各々` | Corrected the row away from long English list fallback to `Các (mỗi; từng; mỗi người)`, added readings/search text, direct example `各々`, and each/all related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `48` to `49` and added an N2 lesson-23 sentinel for `教` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit reduced N2 incomplete current entries from `24` to `16`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `00cd8047` was deployed to Firebase Hosting, a VI/N2 production browser session loaded `/#/kanji` without Kanji data failure. A normal-cache browser fetch of deployed `/assets/assets/data/content/kanji/n2/lesson_23.json` returned `Cache-Control: no-cache`, `lessonId=23`, and `count=8`; `教` showed `Giáo (dạy; giáo dục; giáo lý)`, Hán-Việt `Giáo`, on `キョウ`, kun `おし.える/おそ.わる`, stroke count `11`, and example `教わる` = `được dạy`. The same proof confirmed `main.dart.js` and content JSON revalidate with `no-cache`, while `sqlite3.wasm` and `drift_worker.js` keep `public, max-age=2592000`. Current-tab console warnings/errors: `0`.

## Kanji N2 Lesson 24 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `込` is kokuji and keeps the KANJIDIC2 Vietnamese reading because Unihan has no `kVietnamese`.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `伯母さん`, `お参り`, `思い掛けない`, `思い込む`, `重たい`, `親指`, and `卸す`, used only to choose examples and verify learner-facing glosses.

| Item | Sources | Change |
|---|---|---|
| `母` | KANJIDIC2 reading `ボ`, `はは/も`, meaning `mother`; Unihan `kVietnamese=mẫu`; local context `伯母さん` | Corrected the row away from whole-word aunt fallback to `Mẫu (mẹ; mẫu thân; bậc nữ lớn tuổi)`, added readings/search text, direct example `伯母さん`, and family related kanji. |
| `参` | KANJIDIC2 readings `サン/シン`, `まい.る`, meanings `participate`, `worship`; Unihan `kVietnamese=tham`; local context `お参り` | Rewrote to `Tham (tham gia; đi lễ; viếng thăm)`, added readings/search text, direct example `お参り`, and visit/ritual related kanji. |
| `思` | KANJIDIC2 reading `シ`, `おも.う`, meanings `think`, `consider`; Unihan `kVietnamese=tư`; local context `思い掛けない` | Corrected the row away from whole-word unexpected fallback to `Tư (nghĩ; suy nghĩ; ý nghĩ)`, added readings/search text, direct example `思い掛けない`, and thought related kanji. |
| `込` | KANJIDIC2 kunyomi `こ.む/こ.める`, meanings `crowded`, `included`; no Unihan `kVietnamese`; local context `思い込む` | Corrected the row away from `Nhập`/whole-word convinced fallback to `Liêu (đi vào; chen vào; đầy ắp)`, added readings/search text, direct example `思い込む`, and inside/crowding related kanji. |
| `重` | KANJIDIC2 readings `ジュウ/チョウ`, heavy/important meanings; Unihan `kVietnamese=trọng`; local context `重たい` | Rewrote to `Trọng (nặng; quan trọng; chồng lên)`, added readings/search text, direct example `重たい`, and weight/importance related kanji. |
| `親` | KANJIDIC2 reading `シン`, parent/intimacy meanings; Unihan `kVietnamese=thân`; local context `親指` | Corrected the row away from whole-word thumb fallback to `Thân (cha mẹ; người thân; thân thiết)`, added readings/search text, direct example `親指`, and family/finger related kanji. |
| `指` | KANJIDIC2 reading `シ`, `ゆび/さ.す`, meanings `finger`, `point to`; Unihan `kVietnamese=chỉ`; local context `親指` | Corrected the row away from whole-word thumb fallback to `Chỉ (ngón tay; chỉ ra; hướng dẫn)`, added readings/search text, direct example `親指`, and hand/pointing related kanji. |
| `卸` | KANJIDIC2 reading `シャ`, `おろ.す`, meanings `wholesale`, `unload`; Unihan `kVietnamese=tá`; local context `卸す` | Rewrote to `Tá (bán buôn; hạ xuống; gỡ xuống)`, added readings/search text, direct example `卸す`, and commerce/unload related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `49` to `50` and added an N2 lesson-24 sentinel for `母` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit reduced N2 incomplete current entries from `16` to `8`, focused DB/reachability/taxonomy/upper-JLPT tests passed, release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `af3776a4` was deployed to Firebase Hosting, a VI/N2 production browser session loaded `/#/kanji` without Kanji data failure. A normal-cache browser fetch of deployed `/assets/assets/data/content/kanji/n2/lesson_24.json` returned `Cache-Control: no-cache`; `母` showed `Mẫu (mẹ; mẫu thân; bậc nữ lớn tuổi)`, Hán-Việt `Mẫu`, on `ボ`, kun `はは/も`, stroke count `5`, and example `伯母さん` = `cô; dì; bác gái`. Current-tab console warnings/errors: `0`.

## Kanji N2 Lesson 25 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `恵` and `帯` have no Unihan `kVietnamese`, so the learner-facing Hán-Việt values keep established readings.
- Existing N2 ShinKanzen/Tanos and Hajimete vocabulary context for `恩恵`, `温室`, `温泉`, `温帯`, `御中`, and `女の人`, used only to choose examples and verify learner-facing glosses.

| Item | Sources | Change |
|---|---|---|
| `恩` | KANJIDIC2 reading `オン`, meanings `grace`, `kindness`, `favor`; Unihan `kVietnamese=ân`; local context `恩恵` | Corrected the row away from whole-word grace/favor fallback to `Ân (ơn nghĩa; lòng tốt; ân huệ)`, added readings/search text, direct example `恩恵`, and grace/kindness related kanji. |
| `恵` | KANJIDIC2 readings `ケイ/エ`, `めぐ.む/めぐ.み`, meanings `favor`, `blessing`, `kindness`; no Unihan `kVietnamese`; local context `恩恵` | Rewrote to `Huệ (ban ơn; ân huệ; phúc lành)`, added readings/search text, direct example `恩恵`, and blessing related kanji. |
| `温` | KANJIDIC2 reading `オン`, warm kunyomi, meaning `warm`; Unihan `kVietnamese=ồn`, but learner-facing Sino-Vietnamese is `Ôn`; local contexts `温室`, `温泉`, `温帯` | Corrected the row away from whole-word greenhouse fallback to `Ôn (ấm; làm ấm; ôn hòa)`, added readings/search text, direct example `温室`, and warmth-related kanji. |
| `室` | KANJIDIC2 reading `シツ`, `むろ`, meanings `room`, `chamber`, `greenhouse`; Unihan `kVietnamese=thất`; local context `温室` | Corrected the row away from whole-word greenhouse fallback to `Thất (phòng; buồng; nhà kính)`, added readings/search text, direct example `温室`, and room/building related kanji. |
| `泉` | KANJIDIC2 reading `セン`, `いずみ`, meanings `spring`, `fountain`; Unihan `kVietnamese=tuyền`; local context `温泉` | Corrected the row away from whole-word onsen fallback to `Tuyền (suối; nguồn nước; suối nóng)`, added readings/search text, direct example `温泉`, and water-source related kanji. |
| `帯` | KANJIDIC2 reading `タイ`, `お.びる/おび`, meanings `belt`, `sash`, `zone`; no Unihan `kVietnamese`; local context `温帯` | Corrected the row away from whole-word temperate-zone fallback to `Đới (đai; dải; vùng/đới)`, added readings/search text, direct example `温帯`, and zone/climate related kanji. |
| `中` | KANJIDIC2 reading `チュウ`, `なか/うち/あた.る`, meanings `middle`, `inside`, `center`; Unihan `kVietnamese=trung`; local context `御中` | Corrected the row away from whole-word address suffix fallback to `Trung (giữa; bên trong; trung tâm)`, added readings/search text, direct example `御中`, and inside/middle related kanji. |
| `人` | KANJIDIC2 readings `ジン/ニン`, `ひと/-り/-と`, meaning `person`; Unihan `kVietnamese=nhân`; local context `女の人` | Corrected the row away from whole-word woman fallback to `Nhân (người; con người)`, added readings/search text, direct example `女の人`, and people-related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `50` to `51` and added an N2 lesson-25 sentinel for `恩` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit reduced N2 incomplete current entries from `8` to `0`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `3448965e` was deployed to Firebase Hosting, a VI/N2 production browser session loaded `/#/kanji` without Kanji data failure. A normal-cache browser fetch of deployed `/assets/assets/data/content/kanji/n2/lesson_25.json` returned `Cache-Control: no-cache` and `importStatus=source-verified`; `恩` showed `Ân (ơn nghĩa; lòng tốt; ân huệ)`, Hán-Việt `Ân`, on `オン`, stroke count `10`, and example `恩恵` = `ân huệ; lợi ích; phúc lành`. Current-tab console warnings/errors: `0`.

## Kanji N1 Lesson 1 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `変`, `愛`, and `対` have no Unihan `kVietnamese`, so learner-facing Hán-Việt keeps established readings.
- Existing N1 ShinKanzen/Tanos and Hajimete vocabulary context for `嗚呼`, `相変わらず`, `愛想`, `相対`, and `間柄`, used only to choose examples and verify learner-facing glosses.

| Item | Sources | Change |
|---|---|---|
| `嗚` | KANJIDIC2 readings `ウ/オ`, `ああ`, meanings `weep`, `ah`, `alas`; Unihan `kVietnamese=ô`; local context `嗚呼` | Rewrote to `Ô (than khóc; tiếng kêu than; chao ôi)`, added readings/search text, direct example `嗚呼`, and exclamation/crying related kanji. |
| `呼` | KANJIDIC2 reading `コ`, `よ.ぶ`, meanings `call`, `invite`; Unihan `kVietnamese=hô`; local context `嗚呼` | Rewrote to `Hô (gọi; hô lên; mời gọi)`, added readings/search text, direct example `嗚呼`, and calling related kanji. |
| `相` | KANJIDIC2 readings `ソウ/ショウ`, `あい-`, meanings `mutual`, `together`, `aspect`; Unihan `kVietnamese=tương`; local contexts `相変わらず`, `相対` | Kept learner meaning but added source-backed readings, example glosses, and related kanji. |
| `変` | KANJIDIC2 reading `ヘン`, change/strange meanings; no Unihan `kVietnamese`; local context `相変わらず` | Rewrote display to `Biến (thay đổi; biến đổi; khác thường)`, fixed no-accent search text, added readings, example gloss, and change-related kanji. |
| `愛` | KANJIDIC2 reading `アイ`, love/affection meanings; no Unihan `kVietnamese`; local context `愛想` | Rewrote to `Ái (yêu; yêu mến; tình cảm)`, added readings/search text, direct example `愛想`, and affection related kanji. |
| `想` | KANJIDIC2 readings `ソウ/ソ`, `おも.う`, meanings `idea`, `thought`; Unihan `kVietnamese=tưởng`; local context `愛想` | Rewrote to `Tưởng (ý nghĩ; tưởng tượng; suy tưởng)`, added readings/search text, direct example `愛想`, and thought related kanji. |
| `対` | KANJIDIC2 readings `タイ/ツイ`, opposition/comparison meanings; no Unihan `kVietnamese`; local context `相対` | Rewrote to `Đối (đối nhau; đối diện; so sánh/chống lại)`, added readings/search text, direct example `相対`, and comparison/opposition related kanji. |
| `間` | KANJIDIC2 readings `カン/ケン`, `あいだ/ま/あい`, meanings `interval`, `space`; Unihan `kVietnamese=gian`; local context `間柄` | Rewrote display to `Gian (khoảng giữa; không gian; quan hệ)`, added readings/search text, direct example `間柄`, and relation/interval related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `51` to `52` and added an N1 lesson-1 sentinel for `嗚` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit reduced N1 incomplete current entries from `200` to `192`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `dbc11327` was deployed to Firebase Hosting, a VI/N1 production browser session loaded `/#/kanji` without Kanji data failure. A normal-cache browser fetch of deployed `/assets/assets/data/content/kanji/n1/lesson_01.json` returned `Cache-Control: no-cache` and `importStatus=source-verified`; `嗚` showed `Ô (than khóc; tiếng kêu than; chao ôi)`, Hán-Việt `Ô`, on `ウ/オ`, kun `ああ`, stroke count `13`, and example `嗚呼` = `ôi; chao ôi; than ôi`. Current-tab console warnings/errors: `0`.

## Kanji N1 Lesson 2 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `憎` has no Unihan `kVietnamese`, and KANJIDIC2 Japanese stroke counts are used where they differ from Unihan.
- Existing N1 ShinKanzen/Tanos and Hajimete vocabulary context for `間柄`, `愛憎`, `合間`, `曖昧`, `敢えて`, `仰ぐ`, and `垢`, used only to choose examples and verify learner-facing glosses.

| Item | Sources | Change |
|---|---|---|
| `柄` | KANJIDIC2 reading `ヘイ`, `がら/え/つか`, meanings `pattern`, `nature`, `handle`; Unihan `kVietnamese=bính`; local context `間柄` | Corrected the generated row to `Bính (hoa văn; tính chất; tay cầm)`, added readings/search text, direct example `間柄`, and relation/pattern related kanji. |
| `憎` | KANJIDIC2 reading `ゾウ`, hate/detest meanings, stroke count `14`; no Unihan `kVietnamese`; local context `愛憎` | Kept learner Hán-Việt `Tăng`, corrected stroke count and wrong `愛憎` reading from `あいにく` to `あいぞう`, added readings, example gloss, and emotion related kanji. |
| `合` | KANJIDIC2 readings `ゴウ/ガッ/カッ`, join/fit meanings; Unihan `kVietnamese=hợp`; local context `合間` | Rewrote to `Hợp (hợp; kết hợp; khớp)`, added readings/search text, direct example `合間`, and join/fit related kanji. |
| `曖` | KANJIDIC2 reading `アイ`, `くら.い`, ambiguous/dim meanings; Unihan `kVietnamese=áy`; local context `曖昧` | Rewrote to `Áy (mờ tối; không rõ; mơ hồ)`, added readings/search text, example `曖昧`, and ambiguity related kanji. |
| `昧` | KANJIDIC2 readings `マイ/バイ`, dark/foolish meanings; Unihan `kVietnamese=muội`; local context `曖昧` | Rewrote to `Muội (mờ tối; ngu muội; không rõ)`, added readings/search text, example `曖昧`, and related kanji. |
| `敢` | KANJIDIC2 reading `カン`, daring/brave meanings, stroke count `12`; Unihan `kVietnamese=cám`; local context `敢えて` | Corrected stroke count and rewrote to `Cám (dám; can đảm; táo bạo)`, added readings/search text, example `敢えて`, and courage/decision related kanji. |
| `仰` | KANJIDIC2 readings `ギョウ/コウ`, look-up/respect/depend meanings; Unihan `kVietnamese=ngưỡng`; local context `仰ぐ` | Added source-backed readings, corrected no-accent search text, direct example `仰ぐ`, and respect/dependence related kanji. |
| `垢` | KANJIDIC2 readings `コウ/ク`, `あか/はじ`, dirt/grime meanings; Unihan `kVietnamese=cáu`; local context `垢` | Rewrote to `Cáu (bụi bẩn; cáu bẩn; vết bẩn)`, added readings/search text, direct example `垢`, and cleanliness/dirt related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `52` to `53` and added an N1 lesson-2 sentinel for `柄` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `192` to `184`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `5a9620ac` was deployed to Firebase Hosting, a production browser using normal cache fetched `/main.dart.js`, `/flutter_bootstrap.js`, `/flutter.js`, `/assets/AssetManifest.bin.json`, and `/assets/assets/data/content/kanji/n1/lesson_02.json`; all shell/content responses returned `Cache-Control: no-cache`, while `/sqlite3.wasm` and `/drift_worker.js` kept `public, max-age=2592000`. The deployed lesson returned `importStatus=source-verified`; `柄` showed `Bính (hoa văn; tính chất; tay cầm)`, Hán-Việt `Bính`, on `ヘイ`, kun `がら/え/つか`, stroke count `9`, and example `間柄` = `mối quan hệ`.

## Kanji N1 Lesson 3 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `亜` has no Unihan `kVietnamese`, so the learner-facing Hán-Việt value keeps the established `Á` reading.
- Existing N1 ShinKanzen/Tanos and Hajimete vocabulary context for `亜科`, `銅`, `証`, `赤字`, `明かす`, and `明白`, used only to choose examples and verify learner-facing glosses. The existing `明白` example reading was corrected to `めいはく` for the kanji example.

| Item | Sources | Change |
|---|---|---|
| `亜` | KANJIDIC2 reading `ア`, `つ.ぐ`, meanings `Asia`, `rank next`, `-ous`; Unihan `kDefinition=Asia; second`; local context `亜科` | Rewrote to `Á (châu Á; thứ hai; phụ/á)`, added readings/search text, direct example `亜科`, and category/rank related kanji. |
| `科` | KANJIDIC2 reading `カ`, meanings `department`, `course`, `section`; Unihan `kVietnamese=khoa`; local context `亜科` | Rewrote to `Khoa (khoa; ngành; bộ môn; mục)`, added readings/search text, direct example `亜科`, and study/category related kanji. |
| `銅` | KANJIDIC2 reading `ドウ`, `あかがね`, meaning `copper`; Unihan `kVietnamese=đồng`; local context `銅` | Added source-backed readings, natural Vietnamese meaning, direct example, and metal related kanji. |
| `証` | KANJIDIC2 reading `ショウ`, `あかし`, meanings `evidence`, `proof`, `certificate`; Unihan `kVietnamese=chứng`; local context `証` | Rewrote to `Chứng (bằng chứng; chứng nhận; xác minh)`, added readings/search text, direct example, and proof/recognition related kanji. |
| `赤` | KANJIDIC2 readings `セキ/シャク`, red meanings; Unihan `kVietnamese=xích`; local context `赤字` | Rewrote to `Xích (đỏ; màu đỏ; thâm hụt)`, added readings/search text, example `赤字`, and color/contrast related kanji. |
| `字` | KANJIDIC2 reading `ジ`, character/letter meanings; Unihan `kVietnamese=tự`; local context `赤字` | Rewrote to `Tự (chữ; ký tự; tên chữ)`, added readings/search text, example `赤字`, and writing related kanji. |
| `明` | KANJIDIC2 readings `メイ/ミョウ/ミン`, bright/light meanings; Unihan `kVietnamese=minh`; local context `明かす` | Rewrote to `Minh (sáng; rõ ràng; làm sáng tỏ)`, fixed the example gloss for `明かす`, and added source-backed readings/related kanji. |
| `白` | KANJIDIC2 readings `ハク/ビャク`, white meanings; Unihan `kVietnamese=bạch`; local context `明白` | Rewrote to `Bạch (trắng; trong sạch; rõ ràng)`, corrected the example reading to `めいはく`, and added source-backed readings/related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `53` to `54` and added an N1 lesson-3 sentinel for `亜` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `184` to `176`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `8610360c` was deployed to Firebase Hosting, a production browser using normal cache fetched `/main.dart.js`, `/flutter_bootstrap.js`, `/flutter.js`, `/assets/AssetManifest.bin.json`, and `/assets/assets/data/content/kanji/n1/lesson_03.json`; all shell/content responses returned `Cache-Control: no-cache`, while `/sqlite3.wasm` and `/drift_worker.js` kept `public, max-age=2592000`. The deployed lesson returned `importStatus=source-verified`; `亜` showed `Á (châu Á; thứ hai; phụ/á)`, Hán-Việt `Á`, on `ア`, kun `つ.ぐ`, stroke count `7`, and example `亜科` = `phân họ; nhóm phân loại phụ`. Console errors/warnings: `0`.

## Kanji N1 Lesson 4 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `諦` and `悪` have no Unihan `kVietnamese`, so learner-facing Hán-Việt keeps established readings.
- Existing N1 ShinKanzen/Tanos and Hajimete vocabulary context for `上がり`, `商人`, `空間`, `諦め`, `呆れる`, `悪`, and `灰皿`, used only to choose examples and verify learner-facing glosses. Generated fallback readings for `空間` and `灰` were corrected where they came from word-level import drift.

| Item | Sources | Change |
|---|---|---|
| `上` | KANJIDIC2 readings `ジョウ/ショウ/シャン`, `うえ/あ.がる/のぼ.る`; Unihan `kVietnamese=thượng`; local context `上がり` | Rewrote to `Thượng (trên; lên; tăng)`, added source-backed readings, example gloss, and related kanji. |
| `商` | KANJIDIC2 reading `ショウ`, `あきな.う`; Unihan `kVietnamese=thương`; local context `商人` | Rewrote to `Thương (buôn bán; thương mại; thương nhân)`, added readings/search text, example `商人`, and commerce related kanji. |
| `人` | KANJIDIC2 readings `ジン/ニン`, `ひと`; Unihan `kVietnamese=nhân`; local context `商人` | Aligned with verified lower-level row as `Nhân (người; con người)`, added readings and example context. |
| `空` | KANJIDIC2 reading `クウ`, empty/sky meanings; Unihan `kVietnamese=không`; local context `空間` | Rewrote to `Không (trống; bầu trời; không gian)`, corrected example reading to `くうかん`, and added source-backed readings/related kanji. |
| `諦` | KANJIDIC2 readings `テイ/タイ`, truth/clarity/abandon meanings; no Unihan `kVietnamese`; local context `諦め` | Rewrote to `Đế (chân lý; sáng tỏ; từ bỏ)`, added readings/search text, and example `諦め`. |
| `呆` | KANJIDIC2 reading `ホウ`, amazed/shocked meanings; Unihan `kVietnamese=ngốc`; local context `呆れる` | Rewrote to `Ngốc (ngốc; đờ đẫn; sửng sốt)`, added readings/search text, and natural example gloss. |
| `悪` | KANJIDIC2 readings `アク/オ`, bad/evil meanings; no Unihan `kVietnamese`; existing verified N2 row | Aligned to `Ác (xấu; ác; sai trái)`, added readings/search text, direct example `悪`, and related kanji. |
| `灰` | KANJIDIC2 reading `カイ`, `はい`, ash meanings; Unihan `kVietnamese=hôi`; local context `灰皿` | Rewrote to `Hôi (tro; bụi tro; nước tro)`, corrected example from `灰/あく` fallback to `灰皿/はいざら`, and added related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `54` to `55` and added an N1 lesson-4 sentinel for `上` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `176` to `168`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `b27a84cd` was deployed to Firebase Hosting, a production browser using normal cache fetched `/main.dart.js`, `/flutter_bootstrap.js`, `/flutter.js`, `/assets/AssetManifest.bin.json`, and `/assets/assets/data/content/kanji/n1/lesson_04.json`; all shell/content responses returned `Cache-Control: no-cache`, while `/sqlite3.wasm` and `/drift_worker.js` kept `public, max-age=2592000`. The deployed lesson returned `importStatus=source-verified`; `上` showed `Thượng (trên; lên; tăng)`, Hán-Việt `Thượng`, on `ジョウ/ショウ/シャン`, stroke count `3`, and `灰` showed example `灰皿/はいざら` = `cái gạt tàn`. Console errors/warnings: `0`.

## Kanji N1 Lesson 5 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `憧`, `顎`, and `寝` have no Unihan `kVietnamese`, so learner-facing Hán-Việt keeps established values.
- Existing N1 ShinKanzen/Tanos and Hajimete vocabulary context for `明後日`, `憧れ`, `顎`, `麻`, and `朝寝坊`, used only to choose examples and verify learner-facing glosses. The suspicious generated `悪日/あくび` example was not reused for `日`.

| Item | Sources | Change |
|---|---|---|
| `日` | KANJIDIC2 readings `ニチ/ジツ`, `ひ/-び/-か`, meanings `day`, `sun`, `Japan`; Unihan `kVietnamese=nhật`; local context `明後日` | Rewrote to `Nhật (ngày; mặt trời; Nhật Bản)`, replaced the suspicious `悪日/あくび` example with `明後日`, and added readings/related kanji. |
| `憧` | KANJIDIC2 readings `ショウ/トウ/ドウ`, `あこが.れる`, meanings `yearn after`, `long for`, `admire`; no Unihan `kVietnamese`; existing verified N2 row | Aligned to `Sung (ngưỡng mộ; khao khát; hướng tới)`, added source-backed readings/components, and example `憧れ`. |
| `顎` | KANJIDIC2 reading `ガク`, `あご/あぎと`, meanings `jaw`, `chin`; no Unihan `kVietnamese`; local context `顎` | Rewrote display to `Ngạc (cằm; hàm)`, added readings/components, direct example, and face-related kanji. |
| `麻` | KANJIDIC2 readings `マ/マア`, `あさ`, meanings `hemp`, `flax`, `numb`; Unihan `kVietnamese=ma`; local context `麻`, `麻痺` | Rewrote to `Ma (gai dầu; lanh; tê)`, added readings/search text, and related kanji. |
| `後` | KANJIDIC2 readings `ゴ/コウ`, `のち/うし.ろ/あと/おく.れる`; Unihan `kVietnamese=hậu`; local context `明後日` | Rewrote to `Hậu (sau; phía sau; muộn)`, replaced word-level `あさって` as a kanji reading with source-backed readings, and kept `明後日` as example. |
| `朝` | KANJIDIC2 reading `チョウ`, `あさ`; Unihan `kVietnamese=triều`; local context `朝寝坊` | Rewrote to `Triều (buổi sáng; triều đại)`, replaced word-level `あさねぼう` as a kanji reading with `あさ`, and added time-related kanji. |
| `寝` | KANJIDIC2 reading `シン`, `ね.る/ね.かす/い.ぬ/みたまや/や.める`; no Unihan `kVietnamese`; local context `朝寝坊` | Rewrote to `Tẩm (ngủ; nằm nghỉ; phòng ngủ)`, added source-backed readings/components, and example `朝寝坊`. |
| `坊` | KANJIDIC2 readings `ボウ/ボッ`, meanings `boy`, `priest's residence`, `priest`; Unihan `kVietnamese=phường`; local context `朝寝坊` | Rewrote to `Phường (nhà sư; cậu bé; phường)`, replaced word-level `あさねぼう` as a kanji reading with source-backed on-readings, and added related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `55` to `56` and added an N1 lesson-5 sentinel for `日` so existing browsers reseed the changed metadata.

Verification: JSON parse passed, coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `168` to `160`, focused DB/reachability/taxonomy/upper-JLPT tests passed, `flutter analyze lib test` was clean, UI string guard reported `0`, content status report machine/open-review counts stayed `0`, node research tooling passed (`54`), full `flutter test` passed (`2340`), release web build succeeded, and Firebase Hosting deploy completed.

Live proof after deploy: after `69a404f9` was deployed to Firebase Hosting, a production browser using normal cache fetched `/main.dart.js`, `/flutter_bootstrap.js`, `/flutter.js`, `/assets/AssetManifest.bin.json`, and `/assets/assets/data/content/kanji/n1/lesson_05.json`; all shell/content responses returned `Cache-Control: no-cache`, while `/sqlite3.wasm` and `/drift_worker.js` kept `public, max-age=2592000`. The deployed lesson returned `importStatus=source-verified`; `日` showed `Nhật (ngày; mặt trời; Nhật Bản)`, Hán-Việt `Nhật`, on `ニチ/ジツ`, kun `ひ/-び/-か`, stroke count `4`, and example `明後日/あさって` = `ngày mốt`. `顎` showed `Ngạc (cằm; hàm)` and `寝` showed `Tẩm (ngủ; nằm nghỉ; phòng ngủ)`. Console errors/warnings: `0`.

## Kanji N1 Lesson 6 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `浅`, `笑`, and `焦` have no Unihan `kVietnamese`, so learner-facing values use established source-checked readings.
- Existing N1 ShinKanzen/Tanos and Hajimete vocabulary context for `浅ましい`, `欺く`, `鮮やか`, `あざ笑う`, `味わい`, `東`, `焦る`, and `彼`, used only to choose examples and verify learner-facing glosses.

| Item | Sources | Change |
|---|---|---|
| `浅` | KANJIDIC2 reading `セン`, `あさ.い`, stroke count `9`; local context `浅ましい` | Corrected stroke count from `8` to `9`, rewrote to `Thiển (nông; cạn; hời hợt)`, added readings/components/related kanji, and kept `浅ましい` as the example. |
| `欺` | KANJIDIC2 reading `ギ`, `あざむ.く`; Unihan `kVietnamese=khi`; local context `欺く` | Rewrote to `Khi (lừa dối; đánh lừa)`, added readings/search text/components, and translated the example as `lừa dối`. |
| `鮮` | KANJIDIC2 reading `セン`, `あざ.やか`; Unihan `kVietnamese=tiên`; local context `鮮やか` | Rewrote to `Tiên (tươi; rực rỡ; rõ nét)`, added readings/components/related kanji, and translated the example naturally. |
| `笑` | KANJIDIC2 reading `ショウ`, `わら.う/え.む`; local context `あざ笑う` | Rewrote to `Tiếu (cười)`, replaced word-level `あざわらう` as a kanji reading with source-backed readings, and translated the example as `chế nhạo; cười nhạo`. |
| `味` | KANJIDIC2 reading `ミ`, `あじ/あじ.わう`; Unihan `kVietnamese=vị`; local context `味わい` | Rewrote to `Vị (vị; hương vị; ý nghĩa)`, added source-backed readings/components, and translated `味わい` as `hương vị; ý nghĩa; tầm quan trọng`. |
| `東` | KANJIDIC2 reading `トウ`, `ひがし`; Unihan includes the historical `đang đông` reading; local context `東/あずま` | Normalized learner-facing Hán-Việt to `Đông`, added source-backed readings/components, and explained the older `あずま` example as eastern Japan. |
| `焦` | KANJIDIC2 reading `ショウ`, scorch/impatient meanings; local context `焦る` | Rewrote to `Tiêu (cháy sém; nôn nóng; sốt ruột)`, added readings/components/related kanji, and translated `焦る` as `nôn nóng; sốt ruột; vội vàng`. |
| `彼` | KANJIDIC2 reading `ヒ`, `かれ/かの`; Unihan `kVietnamese=bỉ`; local context previously used awkward `彼処` | Rewrote to `Bỉ (anh ấy; người kia; phía bên kia)`, used the basic `彼/かれ` example, and added pronoun/distance related kanji. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `56` to `57` and added an N1 lesson-6 sentinel for `浅` so existing browsers reseed the changed metadata.

Verification: coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `160` to `152`; focused DB/reachability/taxonomy/upper-JLPT tests passed; `flutter analyze lib test` was clean; release web build succeeded; and Firebase Hosting deploy completed.

Live proof after deploy: after `95534f80` was deployed to Firebase Hosting, a production browser using normal cache fetched `/main.dart.js`, `/flutter_bootstrap.js`, `/flutter.js`, and `/assets/assets/data/content/kanji/n1/lesson_06.json`; all shell/content responses returned `Cache-Control: no-cache`, while `/sqlite3.wasm` and `/drift_worker.js` kept `public, max-age=2592000`. The deployed lesson returned `importStatus=source-verified`; `浅` showed `Thiển (nông; cạn; hời hợt)`, on `セン`, kun `あさ.い`, stroke count `9`, and `vi-source-verified`. Console errors/warnings: `0`.

## Kanji N1 Lesson 7 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `処` and `当` have no Unihan `kVietnamese`, so learner-facing Hán-Việt uses established readings.
- Existing N1 and lower-level vocabulary context for `処理`, `値`, `私`, `当たり`, `当たり前`, `他人`, `方法`, and `此れ`, used only to choose examples and verify learner-facing glosses.

| Item | Sources | Change |
|---|---|---|
| `処` | KANJIDIC2 reading `ショ`, `ところ/-こ/お.る`; local lower-level `処理` | Rewrote to `Xử (xử lý; giải quyết; nơi chốn)`, replaced the sensitive/awkward `彼処` example with `処理`, and added source-backed readings/components/related kanji. |
| `値` | KANJIDIC2 reading `チ`, `ね/あたい`; Unihan `kVietnamese=trị`; local context `値` | Rewrote display to `Trị (giá trị; giá cả)`, added readings/components/related kanji, and translated the example as `giá trị; giá cả; công lao`. |
| `私` | KANJIDIC2 reading `シ`, `わたくし/わたし`; Unihan `kVietnamese=tư`; local context `私/あたし` | Rewrote display to `Tư (riêng tư; tôi)`, replaced word-level `あたし` as a kanji reading with source-backed readings, and kept `あたし` only as the example reading. |
| `当` | KANJIDIC2 reading `トウ`, hit/right meanings; local context `当たり` | Rewrote to `Đương (trúng; đúng; phù hợp; đảm nhận)`, added readings/components/related kanji, and translated `当たり` naturally. |
| `前` | KANJIDIC2 reading `ゼン`, `まえ/-まえ`; Unihan `kVietnamese=tiền`; local context `当たり前` | Rewrote display to `Tiền (trước; phía trước)`, replaced word-level `あたりまえ` as a kanji reading with source-backed readings, and translated the example as `bình thường; hiển nhiên; hợp lý`. |
| `他` | KANJIDIC2 reading `タ`, `ほか`; Unihan `kVietnamese=tha`; local context `他人` | Rewrote display to `Tha (khác; người khác)`, corrected the example reading to the common `たにん`, and added readings/components/related kanji. |
| `方` | KANJIDIC2 reading `ホウ`, `かた/-かた/-がた`; Unihan `kVietnamese=phương`; lower-level context `方法` | Rewrote to `Phương (phương hướng; cách; người)`, replaced the ateji `彼方此方` example with `方法`, and added source-backed readings/relations. |
| `此` | KANJIDIC2 reading `シ`, `これ/この/ここ`; Unihan `kVietnamese=thử`; local context `此れ` | Rewrote display to `Thử (này; đây)`, replaced word-level `あちこち` as a kanji reading with source-backed readings, and used `此れ/これ` as the example. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `57` to `58` and added an N1 lesson-7 sentinel for `処` so existing browsers reseed the changed metadata.

Verification: coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `152` to `144`; focused DB/reachability/taxonomy/upper-JLPT tests passed; `flutter analyze lib test` was clean; UI string guard reported `0`; content status report machine/open-review counts stayed `0`; full `flutter test` passed (`2340`); release web build succeeded; and Firebase Hosting deploy completed.

Live proof after deploy: after `191e6db2` was deployed to Firebase Hosting, a production browser using normal cache fetched `/main.dart.js`, `/flutter_bootstrap.js`, and `/assets/assets/data/content/kanji/n1/lesson_07.json`; all shell/content responses returned `Cache-Control: no-cache`, while `/sqlite3.wasm` and `/drift_worker.js` kept `public, max-age=2592000`. The deployed lesson returned `importStatus=source-verified`; `処` showed `Xử (xử lý; giải quyết; nơi chốn)`, on `ショ`, kun `ところ/-こ/お.る`, stroke count `5`, and example `処理/しょり = xử lý`. Console errors/warnings: `0`.

## Kanji N1 Lesson 8 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, and English definitions.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `気`, `圧`, and `誂` have no Unihan `kVietnamese`, so learner-facing Hán-Việt values use established readings.
- Existing verified duplicate kanji rows for `化`, `口`, and `圧`, plus N1 vocabulary context for `悪化`, `呆気ない`, `悪口`, `圧迫`, `扱い`, `集まる`, and `誂える`.

| Item | Sources | Change |
|---|---|---|
| `化` | KANJIDIC2 readings `カ/ケ`, `ば.ける/ば.かす/ふ.ける/け.する`; existing verified N3 row | Aligned to `Hóa (biến đổi; biến hóa; -hóa)`, replaced word-level `あっか` as a kanji reading with source-backed readings, and translated `悪化` naturally. |
| `気` | KANJIDIC2 readings `キ/ケ`, `いき/き`; no Unihan `kVietnamese`; local context `呆気ない` | Rewrote to `Khí (khí; tinh thần; tâm trạng)`, added readings/components/related kanji, and translated `呆気ない` as `hụt hẫng; chóng vánh; không thỏa đáng`. |
| `口` | KANJIDIC2 readings `コウ/ク`, `くち`; existing verified N2 row | Aligned to `Khẩu (miệng; cửa vào; lối vào)`, replaced word-level `あっこう` as a kanji reading, and translated `悪口` as `nói xấu; xúc phạm; vu khống`. |
| `圧` | KANJIDIC2 readings `アツ/エン/オウ`; existing verified N2 row | Aligned to `Áp (áp lực; nén; ép)`, added readings/components/related kanji, and kept `圧迫` as the example. |
| `迫` | KANJIDIC2 reading `ハク`, `せま.る`; Unihan `kVietnamese=bách`; local context `圧迫` | Rewrote to `Bách (bức bách; ép buộc; cận kề)`, added readings/components/related kanji, and translated `圧迫` consistently. |
| `扱` | KANJIDIC2 readings `ソウ/キュウ`, `あつか.い/あつか.う/あつか.る/こ.く`; Unihan `kVietnamese=gắp`; local context `扱い` | Rewrote display to `Gắp (xử lý; đối xử; tiếp nhận)`, added readings/components/related kanji, and translated `扱い` as `cách xử lý; cách đối xử; dịch vụ`. |
| `集` | KANJIDIC2 reading `シュウ`, `あつ.まる/あつ.める/つど.う`; Unihan `kVietnamese=tập`; local context `集まる` | Rewrote to `Tập (tập hợp; thu thập; tụ họp)`, added source-backed readings/components, and translated `集まる` as `tập hợp; tụ lại`. |
| `誂` | KANJIDIC2 reading `チョウ`, `あつら.える/いど.む`; no Unihan `kVietnamese`; local context `誂える` | Corrected the misleading English `tempt` gloss to order/made-to-order, kept learner-facing `Điệu`, and translated `誂える` as `đặt làm riêng; đặt hàng`. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `58` to `59` and added an N1 lesson-8 sentinel for `化` so existing browsers reseed the changed metadata.

Verification: coverage audit kept N2 incomplete current entries at `0` and reduced N1 incomplete current entries from `144` to `136`; focused DB/reachability/taxonomy/upper-JLPT tests passed; `flutter analyze lib test` was clean; UI string guard reported `0`; content status report machine/open-review counts stayed `0`; full `flutter test` passed (`2340`); release web build succeeded; and Firebase Hosting deploy completed.

Live proof after deploy: after `57cdbac4` was deployed to Firebase Hosting, a production browser using normal cache fetched `/main.dart.js`, `/flutter_bootstrap.js`, and `/assets/assets/data/content/kanji/n1/lesson_08.json`; all shell/content responses returned `Cache-Control: no-cache`, while `/sqlite3.wasm` and `/drift_worker.js` kept `public, max-age=2592000`. The deployed lesson returned `importStatus=source-verified`; `化` showed `Hóa (biến đổi; biến hóa; -hóa)`, on `カ/ケ`, kun `ば.ける/ば.かす/ふ.ける/け.する`, stroke count `4`, and example `悪化/あっか = sự xấu đi; trở nên nghiêm trọng hơn`. Console errors/warnings: `0`.

## Kanji N1 Lesson 9 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, English definitions, and Vietnamese readings where Unihan was absent or unsuitable for learner-facing Hán-Việt.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `継` and `溢` have no Unihan `kVietnamese`, and `女` is normalized to KANJIDIC2 learner-facing `Nữ` instead of Unihan `Nữa`.
- Existing verified duplicate rows for `力`, `宛`, `跡`, and `女`, plus N1 vocabulary context for `圧力`, `跡継ぎ`, `後回し`, `貴い`, `女性`, and `溢れる`.

| Item | Sources | Change |
|---|---|---|
| `力` | KANJIDIC2 readings `リョク/リキ/リイ`, `ちから`; Unihan `kVietnamese=lực`; existing verified N2 row | Rewrote to `Lực (sức mạnh; lực; năng lực)`, replaced word-level `あつりょく` as a kanji reading with source-backed readings, and translated `圧力` as `áp lực; sức ép`. |
| `宛` | KANJIDIC2 reading `エン`, `あ.てる/-あて/-づつ/あたか.も`; Unihan `kVietnamese=uyển`; existing verified N2 row | Rewrote to `Uyển (địa chỉ; gửi đến; giống như)`, replaced bare `宛/あて` example with `宛名/あてな`, and filled readings/components/related kanji. |
| `跡` | KANJIDIC2 reading `セキ`, `あと`; Unihan `kVietnamese=tích`; existing verified N2 row | Rewrote to `Tích (dấu vết; vết tích; dấu chân)`, replaced word-level `あとつぎ` as a kanji reading, and used `足跡/あしあと` as the clearer learner example. |
| `継` | KANJIDIC2 reading `ケイ`, `つ.ぐ/まま-`; no Unihan `kVietnamese`; local context `跡継ぎ` | Rewrote to `Kế (kế tục; nối tiếp; thừa kế)`, replaced word-level `あとつぎ` as a kanji reading, and kept `跡継ぎ` as the usage example. |
| `回` | KANJIDIC2 readings `カイ/エ`, `まわ.る/.../か.える`; Unihan `kVietnamese=hồi`; local context `後回し` | Rewrote to `Hồi (lần; vòng; quay)`, replaced word-level `あとまわし` as a kanji reading, and translated `後回し` as `để sau; trì hoãn`. |
| `貴` | KANJIDIC2 reading `キ`, `たっと.い/とうと.い/たっと.ぶ/とうと.ぶ`; Unihan `kVietnamese=quý` | Rewrote to `Quý (quý giá; đáng trọng; cao quý)`, replaced the `貴女/あなた` word-reading example with `貴い/たっとい`, and filled source-backed readings. |
| `女` | KANJIDIC2 readings `ジョ/ニョ/ニョウ`, `おんな/め`; existing verified row uses `Nữ` | Corrected learner-facing Hán-Việt from `Nữa` to `Nữ`, replaced word-level `あなた` as a kanji reading, and used `女性/じょせい` as the example. |
| `溢` | KANJIDIC2 reading `イツ`, `こぼ.れる/あふ.れる/み.ちる`; no Unihan `kVietnamese`; local context `溢れる` | Rewrote to `Dật (tràn; tràn ngập; đầy ắp)`, added source-backed readings/components/related kanji, and translated `溢れる` naturally. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `59` to `60` and added an N1 lesson-9 sentinel for `力` so existing browsers reseed the changed metadata.

Verification: the owner cache audit was rechecked first. Current `firebase.json` and live Hosting return `Cache-Control: no-cache` for `main.dart.js`, `flutter_bootstrap.js`, `flutter.js`, `assets/AssetManifest*`, and `assets/assets/data/content/**`; `sqlite3.wasm` and `drift_worker.js` remain `public, max-age=2592000`. The hosting cache guard test passed. Coverage audit reduced N1 incomplete current entries from `136` to `128`; focused DB/reachability/taxonomy/upper-JLPT tests passed; `flutter analyze lib test` was clean; UI string guard reported `0`; content status report machine/open-review counts stayed `0`; full `flutter test` passed (`2340`); release web build succeeded; and Firebase Hosting deploy completed.

Live proof after deploy: after `e35ae6ac` was deployed to Firebase Hosting, a production browser using normal cache fetched `/assets/assets/data/content/kanji/n1/lesson_09.json` from page context with `Cache-Control: no-cache`. The deployed lesson returned `importStatus=source-verified`; `力` showed `Lực (sức mạnh; lực; năng lực)`, on `リョク/リキ/リイ`, kun `ちから`, and `vi-source-verified`. `main.dart.js` and `AssetManifest.json` returned `no-cache`, while `sqlite3.wasm` returned `public, max-age=2592000`. Console errors/warnings for the current live page: `0`.

## Kanji N1 Lesson 10 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, English definitions, and Vietnamese readings where Unihan was absent or unsuitable.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `油` is normalized to learner-facing `Du` even though Unihan also lists the vernacular Vietnamese form `dầu`, and `絵`, `炙`, and `雨` rely on KANJIDIC2 Vietnamese readings.
- Existing verified duplicate rows for `甘`, `雨`, `絵`, and `具`, plus N1 vocabulary context for `油絵`, `炙る`, `甘える`, `雨具`, `天地`, and `網`.

| Item | Sources | Change |
|---|---|---|
| `油` | KANJIDIC2 readings `ユ/ユウ`, `あぶら`; Unihan `kTotalStrokes=8`; local context `油絵` | Rewrote to `Du (dầu; chất béo; sơn dầu)`, replaced word-level `あぶらえ` as a kanji reading, and translated `油絵` as `tranh sơn dầu`. |
| `絵` | KANJIDIC2 readings `カイ/エ`; existing verified N2 row; local context `油絵` | Rewrote to `Hội (tranh; hình vẽ; hội họa)`, kept source-backed on readings with no fake kun reading, and translated the shared `油絵` example. |
| `炙` | KANJIDIC2 readings `シャ/セキ`, `あぶ.る`; local context `炙る` | Rewrote to `Chích (nướng; hơ lửa; làm cháy sém)`, added readings/components/related kanji, and translated `炙る` as `hơ lửa; nướng; làm cháy sém`. |
| `甘` | KANJIDIC2 reading `カン`, `あま.い/あま.える/あま.やかす/うま.い`; existing verified N2 row | Aligned to `Cam (ngọt; dễ dãi; nuông chiều)`, replaced word-level `あまえる` as a kanji reading, and translated `甘える` naturally. |
| `雨` | KANJIDIC2 reading `ウ`, `あめ/あま-/-さめ`; existing verified N2 row; local context `雨具` | Aligned to `Vũ (mưa)`, replaced word-level `あまぐ` as a kanji reading, and translated `雨具` as `đồ đi mưa`. |
| `具` | KANJIDIC2 reading `グ`, `そな.える/つぶさ.に`; Unihan `kVietnamese=cụ`; existing verified N2 row | Rewrote to `Cụ (dụng cụ; thành phần; phương tiện)`, replaced word-level `あまぐ` as a kanji reading, and used `雨具` as the example. |
| `天` | KANJIDIC2 reading `テン`, `あまつ/あめ/あま-`; Unihan `kVietnamese=thiên`; local context `天地` | Rewrote to `Thiên (trời; bầu trời; thiên/hoàng gia)`, replaced bare `天/あまつ` with clearer `天地/あめつち`, and added related sky/earth kanji. |
| `網` | KANJIDIC2 reading `モウ`, `あみ`; Unihan `kVietnamese=võng`; local context `網` | Rewrote to `Võng (lưới; mạng lưới)`, added source-backed readings/components/related kanji, and translated the example as `lưới; mạng lưới`. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `60` to `61` and added an N1 lesson-10 sentinel for `油` so existing browsers reseed the changed metadata.

Verification: coverage audit reduced N1 incomplete current entries from `128` to `120`; focused DB/reachability/taxonomy/upper-JLPT tests passed; `flutter analyze lib test` was clean; UI string guard reported `0`; content status report machine/open-review counts stayed `0`; hosting cache guard passed; full `flutter test` passed (`2340`); release web build succeeded; and Firebase Hosting deploy completed.

Live proof after deploy: after `ac75b039` was deployed to Firebase Hosting, a production browser using normal cache fetched `/assets/assets/data/content/kanji/n1/lesson_10.json` from page context with `Cache-Control: no-cache`. The deployed lesson returned `importStatus=source-verified`; `油` showed `Du (dầu; chất béo; sơn dầu)`, on `ユ/ユウ`, kun `あぶら`, and `vi-source-verified`. `main.dart.js` and `AssetManifest.json` returned `no-cache`, while `sqlite3.wasm` returned `public, max-age=2592000`. Console errors/warnings for the current live page: `0`.

## Kanji N1 Lesson 11 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, English definitions, and Vietnamese readings where Unihan was absent or unsuitable.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `操`, `誤`, and `歩` have no Unihan `kVietnamese`, and `予` keeps the existing learner-facing `Dự` instead of Unihan `nhừ`.
- Existing verified duplicate rows for `地`, `危`, `荒`, `歩`, and `予`, plus N1 vocabulary context for `天地`, `操る`, `危ぶむ`, `過ち`, `誤る`, `歩み`, `予め`, and `荒らす`.

| Item | Sources | Change |
|---|---|---|
| `地` | KANJIDIC2 readings `チ/ジ`; Unihan `kVietnamese=địa`; existing verified N2/N5 rows | Rewrote to `Địa (đất; mặt đất; vùng đất)`, replaced word-level `あめつち` as a kanji reading, and translated `天地` as `trời đất; vũ trụ; tự nhiên`. |
| `操` | KANJIDIC2 readings `ソウ/サン`, `みさお/あやつ.る`; local context `操る` | Rewrote to `Thao (điều khiển; thao túng; vận hành)`, filled source-backed readings/components, and translated `操る` as `điều khiển; thao túng; vận hành`. |
| `危` | KANJIDIC2 reading `キ`, `あぶ.ない/あや.うい/あや.ぶむ`; Unihan `kVietnamese=nguy`; existing verified N2 row | Aligned to `Nguy (nguy hiểm; bất an; đáng lo)`, replaced word-level `あやぶむ` as a kanji reading, and translated `危ぶむ` naturally. |
| `過` | KANJIDIC2 reading `カ`, `す.ぎる/.../あやま.ち`; Unihan `kVietnamese=quá`; local context `過ち` | Rewrote to `Quá (vượt quá; đi qua; lỗi lầm)`, used Japanese stroke count `12`, and translated `過ち` as `lỗi lầm; sai sót; lỡ lầm`. |
| `誤` | KANJIDIC2 reading `ゴ`, `あやま.る`; local context `誤る` | Rewrote to `Ngộ (sai; nhầm lẫn; mắc lỗi)`, filled source-backed readings/components, and translated `誤る` as `mắc lỗi; phạm sai lầm; nhầm lẫn`. |
| `歩` | KANJIDIC2 readings `ホ/ブ/フ`, `ある.く/あゆ.む`; existing verified N5 row | Rewrote to `Bộ (bước; đi bộ; tiến triển)`, replaced word-level `あゆみ` as a kanji reading, and translated `歩み` as `bước đi; tiến trình`. |
| `予` | KANJIDIC2 readings `ヨ/シャ`, `あらかじ.め`; existing verified N3 row; local context `予め` | Corrected learner-facing Hán-Việt from generated `Nhừ` to `Dự`, kept source-backed readings, and translated `予め` as `trước; từ trước; trước đó`. |
| `荒` | KANJIDIC2 reading `コウ`, `あ.らす/...`; Unihan `kVietnamese=hoang`; existing verified N2 row | Aligned to `Hoang (hoang vu; thô bạo; dữ dội)`, replaced word-level `あらす` as a kanji reading, and translated `荒らす` as `tàn phá; làm hư hại; quấy phá`. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `61` to `62` and added an N1 lesson-11 sentinel for `予` so existing browsers reseed the changed metadata.

Verification: coverage audit reduced N1 incomplete current entries from `120` to `112`; focused DB/reachability/taxonomy/upper-JLPT tests passed; `flutter analyze lib test` was clean; UI string guard reported `0`; content status report machine/open-review counts stayed `0`; hosting cache guard passed; full `flutter test` passed (`2340`); release web build succeeded; and Firebase Hosting deploy completed.

Live proof after deploy: after `f04728a9` was deployed to Firebase Hosting, a production browser using normal cache fetched `/assets/assets/data/content/kanji/n1/lesson_11.json` from page context with `Cache-Control: no-cache`. The deployed lesson returned `importStatus=source-verified`; all eight entries had `vi-source-verified`; `予` showed `Dự (trước; dự tính; chuẩn bị)`, on `ヨ/シャ`, kun `あらかじ.め`, and example `予め/あらかじめ = trước; từ trước; trước đó`. Current page console errors/warnings: `0`.

## Kanji N1 Lesson 12 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, English definitions, and Vietnamese readings where Unihan was absent or unsuitable.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `筋` uses learner-facing KANJIDIC2 `Cân` instead of Unihan vernacular `gân`.
- Existing verified duplicate rows for `粗`, `争`, `改`, `凡`, `有`, and `難`, plus vocabulary examples for `粗筋`, `争い`, `改まる`, `凡ゆる`, `現われ`, `有無`, and `困難`.

| Item | Sources | Change |
|---|---|---|
| `粗` | KANJIDIC2 reading `ソ`, `あら.い/あら-`; Unihan `kVietnamese=thô`; existing verified N2 row | Aligned to `Thô (thô; sơ sài; thô ráp)`, replaced word-level `あらすじ` as a kanji reading, and translated `粗筋` as `tóm tắt; cốt truyện khái quát`. |
| `筋` | KANJIDIC2 reading `キン`, `すじ`; local context `粗筋` | Corrected Hán-Việt from vernacular `Gân` to learner-facing `Cân`, added source-backed readings/components/related kanji, and kept `粗筋` as the example. |
| `争` | KANJIDIC2 reading `ソウ`, `あらそ.う/いか.でか`; existing verified N2/N3 rows | Aligned to `Tranh (tranh chấp; cạnh tranh; cãi nhau)`, replaced word-level `あらそい` as a kanji reading, and translated `争い` naturally. |
| `改` | KANJIDIC2 reading `カイ`, `あらた.める/あらた.まる`; existing verified N2 row | Aligned to `Cải (sửa đổi; cải thiện; kiểm tra lại)`, replaced word-level `あらたまる` as a kanji reading, and translated `改まる` as `được đổi mới; trở nên trang trọng`. |
| `凡` | KANJIDIC2 readings `ボン/ハン`, `およ.そ/おうよ.そ/すべ.て`; Unihan `kVietnamese=phàm`; existing verified N2 row | Rewrote to `Phàm (phàm; bình thường; nói chung)`, replaced word-level `あらゆる` as a kanji reading, and translated `凡ゆる` as `mọi; tất cả`. |
| `現` | KANJIDIC2 reading `ゲン`, `あらわ.れる/あらわ.す/うつつ/うつ.つ`; Unihan `kVietnamese=hiện` | Rewrote to `Hiện (hiện tại; thực tế; xuất hiện)`, replaced word-level `あらわれ` as a kanji reading, and translated `現われ` as `biểu hiện; sự hiện ra`. |
| `有` | KANJIDIC2 readings `ユウ/ウ`, `あ.る`; Unihan `kVietnamese=hữu`; existing verified N2 row | Aligned to `Hữu (có; tồn tại; sở hữu)`, replaced ateji `有難う` with clearer `有無/うむ`, and added source-backed readings. |
| `難` | KANJIDIC2 reading `ナン`, `かた.い/.../-にく.い`; Unihan `kVietnamese=nan`; existing verified N2/N3 rows | Aligned to `Nan (khó; gian nan; tai nạn)`, replaced ateji `有難う` with clearer `困難/こんなん`, and kept repo-standard stroke count `19`. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `62` to `63` and added an N1 lesson-12 sentinel for `粗` so existing browsers reseed the changed metadata.

Verification: coverage audit reduced N1 incomplete current entries from `112` to `104`; focused DB/reachability/taxonomy/upper-JLPT tests passed; `flutter analyze lib test` was clean; UI string guard reported `0`; content status report machine/open-review counts stayed `0`; hosting cache guard passed; full `flutter test` passed (`2340`); release web build succeeded; and Firebase Hosting deploy completed.

Live proof after deploy: after `13164fac` was deployed to Firebase Hosting, a production browser using normal cache fetched `/assets/assets/data/content/kanji/n1/lesson_12.json` from page context with `Cache-Control: no-cache`. The deployed lesson returned `importStatus=source-verified`; all eight entries had `vi-source-verified`; `粗` showed `Thô (thô; sơ sài; thô ráp)`, on `ソ`, kun `あら.い/あら-`, and example `粗筋/あらすじ = tóm tắt; cốt truyện khái quát`. Current page console errors/warnings: `0`.

## Kanji N1 Lesson 13 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, English definitions, and Vietnamese readings where Unihan was absent or unsuitable.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, and `kTotalStrokes`; `示` and `案` keep learner-facing KANJIDIC2/app readings instead of bundled multi-reading Unihan phrases.
- Existing verified duplicate rows plus N1 vocabulary examples for `有様`, `或る`, `慌ただしい`, `暗殺`, `暗算`, `暗示`, and `案`.

| Item | Sources | Change |
|---|---|---|
| `様` | KANJIDIC2 readings `ヨウ/ショウ`, `さま/さん`; local context `有様` | Rewrote to `Dạng (dáng vẻ; kiểu; tình trạng)`, replaced word-derived fallback reading, and translated `有様` as `tình trạng; hoàn cảnh; thực trạng`. |
| `或` | KANJIDIC2 readings `ワク/コク/イキ`, `あ.る/あるい/あるいは`; local context `或る` | Rewrote to `Hoặc (hoặc; nào đó; có thể)`, added source-backed readings/components, and translated `或る` as `một... nào đó`. |
| `慌` | KANJIDIC2 reading `コウ`, `あわ.てる/あわ.ただしい`; Unihan `kVietnamese=hoảng`; local context `慌ただしい` | Rewrote to `Hoảng (hoảng hốt; bối rối; vội vã)`, replaced word-level reading, and translated the example naturally. |
| `暗` | KANJIDIC2 reading `アン`, `くら.い/...`; Unihan `kVietnamese=ám`; local context `暗殺` | Rewrote to `Ám (tối; u ám; bí mật)`, replaced word-level `あんさつ` as a kanji reading, and translated `暗殺` as `vụ ám sát`. |
| `殺` | KANJIDIC2 readings `サツ/サイ/セツ`, `ころ.す/...`; Unihan `kVietnamese=sát`; local context `暗殺` | Rewrote to `Sát (giết; sát hại; giảm bớt)`, filled source-backed readings/components, and kept the `暗殺` example. |
| `算` | KANJIDIC2 reading `サン`, `そろ`; Unihan `kVietnamese=toán`; local context `暗算` | Rewrote to `Toán (tính toán; phép tính; dự tính)`, replaced word-level `あんざん`, and translated `暗算` as `tính nhẩm`. |
| `示` | KANJIDIC2 readings `ジ/シ`, `しめ.す`; local context `暗示` | Corrected learner-facing Hán-Việt from generated `Kì Thị` to `Thị`, rewrote to `Thị (chỉ ra; biểu thị; cho thấy)`, and translated `暗示` as `gợi ý ngầm; ám chỉ`. |
| `案` | KANJIDIC2 readings `アン`, no learner-facing kun; existing verified app convention | Corrected generated `An Án Yên` to learner-facing `Án`, rewrote to `Án (ý tưởng; phương án; vụ việc)`, and removed unsupported word-derived readings. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `63` to `64` and added an N1 lesson-13 sentinel for `示` so existing browsers reseed the changed metadata.

Verification: coverage audit reduced N1 incomplete current entries from `104` to `96`; focused DB/reachability/taxonomy/upper-JLPT tests passed; `flutter analyze lib test` was clean; UI string guard reported `0`; content status report machine/open-review counts stayed `0`; hosting cache guard passed; full `flutter test` passed (`2340`); release web build succeeded; and Firebase Hosting deploy completed.

Live proof after deploy: after `f66f53e0` was deployed to Firebase Hosting, a production browser using normal cache fetched `/assets/assets/data/content/kanji/n1/lesson_13.json` from page context with `Cache-Control: no-cache`. The deployed lesson returned `importStatus=source-verified`; all eight entries had `vi-source-verified`; `示` showed `Thị (chỉ ra; biểu thị; cho thấy)`, on `ジ/シ`, kun `しめ.す`, and example `暗示/あんじ = gợi ý ngầm; ám chỉ`. Current page console errors/warnings: `0`.

## Kanji N1 Lesson 14 Completeness Batch

Sources consulted:

- KANJIDIC2 local cache `.codex/sources/kanjidic2/kanjidic2.xml` for Japanese stroke counts, readings, English definitions, and Vietnamese readings where Unihan was absent or unsuitable.
- Unihan local cache `.codex/sources/Unihan/Unihan_Readings.txt` and `.codex/sources/Unihan/Unihan_IRGSources.txt` for `kVietnamese`, `kDefinition`, `kJapanese`, and `kTotalStrokes`; `静` has no Unihan `kVietnamese`, so KANJIDIC2 readings `Tĩnh/Tịnh` were used.
- Existing verified duplicate rows for `安`, `定`, `余`, and `井`, plus vocabulary examples for `安静`, `案の定`, `余り`, `依存`, `良い`, `伊豆`, and `井戸`.

| Item | Sources | Change |
|---|---|---|
| `安` | KANJIDIC2/Unihan readings `アン`, `やす.い/...`; existing N2/N3/N5 rows; local context `安静` | Aligned to `An (yên ổn; an toàn; rẻ)`, replaced word-level `あんせい` as a kanji reading, and translated `安静` as `nghỉ ngơi; tĩnh dưỡng`. |
| `静` | KANJIDIC2 readings `セイ/ジョウ`, `しず-...`; Unihan definition/strokes; local context `安静` | Rewrote to `Tĩnh (yên tĩnh; tĩnh lặng; điềm tĩnh)`, added source-backed readings/components, and used the shared `安静` example. |
| `定` | KANJIDIC2/Unihan readings `テイ/ジョウ`, `さだ.める/...`; existing verified N2 row; local context `案の定` | Aligned to `Định (quyết định; cố định; ổn định)`, replaced word-level `あんのじょう`, and translated `案の定` as `quả nhiên; đúng như dự đoán`. |
| `余` | KANJIDIC2/Unihan readings `ヨ`, `あま.る/.../あんま.り`; existing verified N2 row; local context `余り` | Aligned to `Dư (thừa; còn lại; phần dư)`, replaced the truncated gloss, and translated `余り` as `không mấy; quá; phần dư`. |
| `依` | KANJIDIC2/Unihan readings `イ/エ`, `よ.る`; local context `依存` | Rewrote to `Y (dựa vào; nương theo; phụ thuộc)`, replaced bare `依/い`, and used `依存` as the clearer example. |
| `良` | KANJIDIC2/Unihan reading `リョウ`, `よ.い/い.い`; existing N5 row; local context `良い` | Rewrote to `Lương (tốt; lương thiện; phẩm chất tốt)`, filled source-backed readings, and kept `良い` as the example. |
| `伊` | KANJIDIC2/Unihan reading `イ`, `かれ`; local N4 vocabulary context `伊豆` | Rewrote to `Y (Ý; người ấy; dùng trong tên riêng)` and replaced the suspicious generated `伊井/いい` source row with `伊豆/いず`. |
| `井` | KANJIDIC2/Unihan readings `セイ/ショウ`, `い`; existing verified N2 row; local context `井戸` | Aligned to `Tỉnh (giếng; hầm; miệng giếng)` and replaced the suspicious generated `伊井/いい` example with `井戸/いど`. |

Tagging: added entry-level and file-level `vi-source-verified`, removed old `approved-by-user`/`kanji-metadata-approved`/`unihan-kanji-checked` metadata, kept `vi-editorial-codex-pass`, and did not add `vi-human-approved`.

Runtime note: bumped content DB Kanji seed revision from `64` to `65` and added an N1 lesson-14 sentinel for `伊` so existing browsers reseed the changed metadata.

Verification: coverage audit reduced N1 incomplete current entries from `96` to `88`; focused DB/reachability/taxonomy/upper-JLPT tests passed; `flutter analyze lib test` was clean; UI string guard reported `0`; content status report machine/open-review counts stayed `0`; hosting cache guard passed; full `flutter test` passed (`2340`); release web build succeeded; and Firebase Hosting deploy completed.

Live proof after deploy: after `66694ebe` was deployed to Firebase Hosting, a production browser using normal cache fetched `/assets/assets/data/content/kanji/n1/lesson_14.json` from page context with `Cache-Control: no-cache`. The deployed lesson returned `importStatus=source-verified`; all eight entries had `vi-source-verified`; old approval tags were absent; `伊` showed `Y (Ý; người ấy; dùng trong tên riêng)`, on `イ`, kun `かれ`, and example `伊豆/いず = Izu; địa danh ở Nhật`. Current page console errors/warnings: `0`.
