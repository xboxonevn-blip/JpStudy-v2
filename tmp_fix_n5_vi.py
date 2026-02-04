#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
from pathlib import Path


SPECIALS = {0x3005, 0x3006, 0x30F6}


def has_kanji(text: str) -> bool:
    for ch in text or "":
        code = ord(ch)
        if (0x4E00 <= code <= 0x9FFF) or (code in SPECIALS):
            return True
    return False


placeholders = {"nga", "bandung", "osaka", "singapore", "paris", "veracruz", "franken"}

# Restore Vietnamese accents for rows damaged by mojibake and normalize prior placeholder rows.
vi_from_en = {
    "strict / severe": "nghiêm khắc",
    "bad-tasting": "dở / khó ăn",
    "Mt. Fuji": "Núi Phú Sĩ",
    "get used to": "quen với",
    "full / a lot": "đầy / nhiều",
    "how / how about": "thế nào / ra sao",
    "quite / enough": "khá / đủ",
    "soon / about time": "sắp đến lúc",
    "excuse me / rude": "thất lễ / xin phép",
    "hello (on the phone)": "a lô",
    "together": "cùng nhau",
    "a little": "một chút",
    "maybe another time": "để lần khác nhé",
    "please": "làm ơn / xin vui lòng",
    "film": "phim",
    "corner / section": "góc / khu",
    "spice": "gia vị",
    "company": "công ty",
    "curry rice": "cơm cà ri",
    "fine weather": "thời tiết đẹp",
    "outing / going out": "đi ra ngoài",
    "come / go / be (honorific)": "(kính ngữ) đi / đến / ở",
    "after that / and then": "sau đó",
    "coffee": "cà phê",
    "amazing / great": "tuyệt vời",
    "get tired": "mệt",
    "Gion Festival": "Lễ hội Gion",
    "Hong Kong": "Hồng Kông",
    "Singapore": "Singapore",
    "coffee shop": "quán cà phê",
    "park": "công viên",
    "ski / skiing": "trượt tuyết",
    "stomach / belly": "bụng",
    "traffic signal": "tín hiệu giao thông",
    "Russia": "Nga",
    "Osaka": "Osaka",
    "train": "tàu điện",
    "university": "đại học",
    "quit / stop": "nghỉ / thôi",
    "quit a company": "nghỉ việc công ty",
    "tall (stature)": "cao (về vóc dáng)",
    "smart": "thông minh",
    "no": "không",
    "Asia": "Châu Á",
    "Bandung": "Bandung",
    "Veracruz": "Veracruz",
    "Franken": "Franken",
    "Vietnam": "Việt Nam",
    "report": "báo cáo",
    "bath": "bồn tắm",
    "problem / question": "vấn đề / câu hỏi",
    "teacher / doctor": "giáo viên / bác sĩ",
    "by (deadline)": "trước (hạn)",
    "what happened": "có chuyện gì vậy",
    "can / be able to": "có thể",
    "driving / operation": "lái xe / vận hành",
    "study tour / inspection": "tham quan học tập",
    "international": "quốc tế",
    "meter": "mét",
    "truth / really": "thật / thực sự",
    "stay overnight": "ở lại qua đêm",
    "cake": "bánh ngọt",
    "festival": "lễ hội",
    "have a talk": "trò chuyện",
    "for a while": "một lúc",
    "of course": "tất nhiên",
    "wear (on head)": "đội (mũ)",
    "put on glasses": "đeo kính",
    "this way": "hướng này / bên này",
    "hmm": "ừm",
    "Paris": "Paris",
    "change / alter": "thay đổi",
    "moving (residence)": "chuyển nhà",
    "pinch / turn (a knob)": "vặn (núm)",
    "building": "tòa nhà",
    "alien registration card": "thẻ đăng ký người nước ngoài",
    "change (money)": "tiền lẻ / tiền thối",
    "give (me)": "cho (tôi)",
    "guidance / information": "hướng dẫn / thông tin",
    "explanation": "giải thích",
    "put in / make (coffee)": "cho vào / pha (cà phê)",
    "grandpa": "ông",
    "grandma": "bà",
    "box lunch": "hộp cơm",
    "think / consider": "suy nghĩ / cân nhắc",
    "grow old": "già đi",
    "one cup / one drink": "một ly / một cốc",
    "various": "nhiều / đa dạng",
    "be indebted / be taken care of": "mang ơn / được giúp đỡ",
    "do one's best": "cố gắng hết sức",
    "please / by all means": "nhất định nhé / xin cứ tự nhiên",
}


sense_updates = []
master_updates = []

for lesson in range(1, 26):
    base = Path(f"assets/data/vocab/n5/lesson_{lesson:02d}")
    sense_path = base / "sense.json"
    master_path = base / "master.json"
    if not sense_path.exists() or not master_path.exists():
        continue

    sense = json.loads(sense_path.read_text(encoding="utf-8"))
    master = json.loads(master_path.read_text(encoding="utf-8"))

    s_by_vid = {}
    sense_dirty = False
    for row in sense:
        vid = row["vocabId"]
        s_by_vid[vid] = row
        vi = (row.get("meaningVi") or "").strip()
        en = row.get("meaningEn") or ""
        should_fix = ("?" in vi) or (vi.lower() in placeholders)
        if should_fix and en in vi_from_en:
            new_vi = vi_from_en[en]
            if vi != new_vi:
                row["meaningVi"] = new_vi
                sense_dirty = True
                sense_updates.append(
                    {
                        "lesson": lesson,
                        "vocabId": vid,
                        "meaningEn": en,
                        "oldMeaningVi": vi,
                        "newMeaningVi": new_vi,
                    }
                )

    if sense_dirty:
        sense_path.write_text(json.dumps(sense, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    # Realign kanjiMeaning from corrected meaningVi for terms containing kanji.
    master_dirty = False
    for row in master:
        vid = row["vocabId"]
        vi = (s_by_vid.get(vid, {}).get("meaningVi") or "").strip()
        target = vi if (has_kanji(row.get("term", "")) and vi) else None
        if row.get("kanjiMeaning") != target:
            master_updates.append(
                {
                    "lesson": lesson,
                    "vocabId": vid,
                    "oldKanjiMeaning": row.get("kanjiMeaning"),
                    "newKanjiMeaning": target,
                }
            )
            row["kanjiMeaning"] = target
            master_dirty = True

    if master_dirty:
        master_path.write_text(json.dumps(master, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


report_dir = Path("docs/reports")
report_dir.mkdir(parents=True, exist_ok=True)
(report_dir / "n5-vi-accent-repair-sense.json").write_text(
    json.dumps(sense_updates, ensure_ascii=False, indent=2) + "\n",
    encoding="utf-8",
)
(report_dir / "n5-vi-accent-repair-master.json").write_text(
    json.dumps(master_updates, ensure_ascii=False, indent=2) + "\n",
    encoding="utf-8",
)

print(f"sense_updates={len(sense_updates)}")
print(f"master_updates={len(master_updates)}")
