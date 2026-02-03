#!/usr/bin/env python3
"""Promote N4 curated templates to manual using Mistake Bank priority.

Priority order:
1) Direct N4 kanji mistakes (highest weight)
2) Lesson pressure from Mistake Bank (vocab/grammar/kanji)
3) Fallback: earlier lesson + lower stroke count
"""

from __future__ import annotations

import argparse
import json
import sqlite3
import sys
import time
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Tuple


ROOT = Path(__file__).resolve().parents[1]
OVERRIDES_PATH = (
    ROOT / "assets" / "data" / "kanji" / "stroke_template_overrides.json"
)
CONTENT_DB_PATH = Path.home() / "Documents" / "content.sqlite"
USER_DB_PATH = Path.home() / "Documents" / "jpstudy.sqlite"


def _read_json(path: Path) -> List[dict]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def _load_kanji_map(content_db_path: Path) -> Dict[str, dict]:
    con = sqlite3.connect(str(content_db_path))
    cur = con.cursor()
    cur.execute("SELECT id, character, lesson_id, jlpt_level, stroke_count FROM kanji")
    rows = cur.fetchall()
    con.close()
    out: Dict[str, dict] = {}
    for item_id, ch, lesson_id, level, stroke_count in rows:
        if ch in out:
            # Keep first stable row if duplicates appear.
            continue
        out[ch] = {
            "id": int(item_id),
            "lesson": int(lesson_id),
            "level": (level or "").upper(),
            "stroke": int(stroke_count),
        }
    return out


def _safe_query(cur: sqlite3.Cursor, sql: str) -> List[Tuple]:
    try:
        cur.execute(sql)
        return cur.fetchall()
    except sqlite3.Error:
        return []


def _load_mistake_signals(
    user_db_path: Path,
    kanji_by_id: Dict[int, dict],
) -> Tuple[Dict[str, float], Dict[int, float]]:
    """Return (direct_n4_kanji_score_by_char, lesson_score)."""

    if not user_db_path.exists():
        return {}, {}

    con = sqlite3.connect(str(user_db_path))
    cur = con.cursor()

    lesson_score: Dict[int, float] = defaultdict(float)
    direct_char_score: Dict[str, float] = defaultdict(float)

    # Lesson pressure from vocab mistakes.
    for lesson_id, total_wrong in _safe_query(
        cur,
        """
        SELECT t.lesson_id, COALESCE(SUM(m.wrong_count), 0)
        FROM user_mistakes m
        JOIN user_lesson_term t ON t.id = m.item_id
        WHERE m.type = 'vocab'
        GROUP BY t.lesson_id
        """,
    ):
        lesson_score[int(lesson_id)] += float(total_wrong)

    # Lesson pressure from grammar mistakes.
    for lesson_id, total_wrong in _safe_query(
        cur,
        """
        SELECT g.lesson_id, COALESCE(SUM(m.wrong_count), 0)
        FROM user_mistakes m
        JOIN grammar_points g ON g.id = m.item_id
        WHERE m.type = 'grammar'
        GROUP BY g.lesson_id
        """,
    ):
        lesson_score[int(lesson_id)] += float(total_wrong)

    # Kanji mistakes: boost both lesson score and direct char score.
    kanji_rows = _safe_query(
        cur,
        """
        SELECT item_id, wrong_count, last_mistake_at
        FROM user_mistakes
        WHERE type = 'kanji'
        """,
    )
    now_ms = int(time.time() * 1000)
    for item_id, wrong_count, last_mistake_at in kanji_rows:
        meta = kanji_by_id.get(int(item_id))
        if meta is None:
            continue
        wrong = float(wrong_count or 0)
        lesson = int(meta["lesson"])
        level = str(meta["level"])
        char = str(meta["character"])

        lesson_score[lesson] += wrong * 2.0

        if level != "N4":
            continue
        # Recency bonus in [0, 1], tapering over 30 days.
        age_ms = max(0, now_ms - int(last_mistake_at or 0))
        recency = max(0.0, 1.0 - (age_ms / (30 * 24 * 60 * 60 * 1000)))
        direct_char_score[char] += (wrong * 4.0) + recency

    con.close()
    return dict(direct_char_score), dict(lesson_score)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--count", type=int, default=12)
    parser.add_argument("--user-db", type=Path, default=USER_DB_PATH)
    parser.add_argument("--content-db", type=Path, default=CONTENT_DB_PATH)
    args = parser.parse_args()

    overrides = _read_json(OVERRIDES_PATH)
    override_map = {entry["character"]: dict(entry) for entry in overrides}
    override_order = {entry["character"]: i for i, entry in enumerate(overrides)}

    kanji_map = _load_kanji_map(args.content_db)
    kanji_by_id = {
        meta["id"]: {"character": ch, **meta}
        for ch, meta in kanji_map.items()
    }
    direct_score, lesson_score = _load_mistake_signals(args.user_db, kanji_by_id)

    curated_n4 = [
        entry
        for entry in overrides
        if entry.get("level") == "N4" and str(entry.get("quality", "")).lower() == "curated"
    ]
    if not curated_n4:
        print("No curated N4 entries found. Nothing to promote.")
        return

    ranked = []
    for entry in curated_n4:
        ch = entry["character"]
        meta = kanji_map.get(ch, {})
        lesson = int(meta.get("lesson", 999))
        stroke = int(meta.get("stroke", 99))
        direct = float(direct_score.get(ch, 0.0))
        lesson_sig = float(lesson_score.get(lesson, 0.0))
        total = (direct * 100.0) + (lesson_sig * 4.0)
        ranked.append(
            {
                "character": ch,
                "lesson": lesson,
                "stroke": stroke,
                "direct": direct,
                "lesson_sig": lesson_sig,
                "total": total,
                "order": override_order.get(ch, 99999),
            }
        )

    # If no signal exists at all, fallback to early lessons + simpler strokes.
    has_signal = any(item["total"] > 0 for item in ranked)
    mode = "mistake_signal" if has_signal else "fallback_lesson_stroke"
    if has_signal:
        ranked.sort(
            key=lambda x: (
                -x["total"],
                -x["direct"],
                -x["lesson_sig"],
                x["lesson"],
                x["stroke"],
                x["order"],
            )
        )
    else:
        ranked.sort(
            key=lambda x: (
                x["lesson"],
                x["stroke"],
                x["order"],
            )
        )

    selected = ranked[: max(0, min(args.count, len(ranked)))]
    selected_chars = {item["character"] for item in selected}

    for ch in selected_chars:
        item = override_map[ch]
        item["quality"] = "manual"
        item["level"] = "N4"
        override_map[ch] = item

    # Stable output order: N5 first, then N4; preserve previous order inside level.
    level_rank = {"N5": 0, "N4": 1, "N3": 2, "N2": 3, "N1": 4}
    final = sorted(
        override_map.values(),
        key=lambda e: (
            level_rank.get(e.get("level", "N9"), 9),
            override_order.get(e["character"], 99999),
            e["character"],
        ),
    )
    OVERRIDES_PATH.write_text(
        json.dumps(final, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    manual_n4 = sum(
        1
        for e in final
        if e.get("level") == "N4" and str(e.get("quality", "")).lower() == "manual"
    )
    curated_n4_left = sum(
        1
        for e in final
        if e.get("level") == "N4" and str(e.get("quality", "")).lower() == "curated"
    )

    print(
        f"mode={mode} promoted={len(selected_chars)} "
        f"manual_n4={manual_n4} curated_n4={curated_n4_left}"
    )
    for item in selected:
        char = item["character"]
        try:
            char.encode(sys.stdout.encoding or "utf-8")
        except UnicodeEncodeError:
            char = char.encode("unicode_escape").decode("ascii")
        print(
            f"{char} lesson={item['lesson']} stroke={item['stroke']} "
            f"score={item['total']:.2f} direct={item['direct']:.2f} lessonSig={item['lesson_sig']:.2f}"
        )


if __name__ == "__main__":
    main()
