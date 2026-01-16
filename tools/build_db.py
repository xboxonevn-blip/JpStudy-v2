import json
import os
import sqlite3
import sys

from validate_content import validate


def _load_json(path):
    with open(path, "r", encoding="utf-8") as handle:
        return json.load(handle)


def _create_schema(cursor):
    cursor.executescript(
        """
        CREATE TABLE vocab (
            id INTEGER PRIMARY KEY,
            term TEXT NOT NULL,
            reading TEXT,
            meaning TEXT NOT NULL,
            level TEXT NOT NULL,
            tags TEXT
        );
        CREATE TABLE grammar (
            id INTEGER PRIMARY KEY,
            level TEXT NOT NULL,
            title TEXT NOT NULL,
            summary TEXT NOT NULL
        );
        CREATE TABLE question (
            id INTEGER PRIMARY KEY,
            level TEXT NOT NULL,
            prompt TEXT NOT NULL,
            choices_json TEXT NOT NULL,
            correct_index INTEGER NOT NULL,
            grammar_id INTEGER,
            explanation TEXT
        );
        CREATE TABLE mock_test (
            id INTEGER PRIMARY KEY,
            level TEXT NOT NULL,
            title TEXT NOT NULL,
            duration_seconds INTEGER NOT NULL
        );
        CREATE TABLE mock_test_section (
            id INTEGER PRIMARY KEY,
            test_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            order_index INTEGER NOT NULL
        );
        CREATE TABLE mock_test_question_map (
            id INTEGER PRIMARY KEY,
            test_id INTEGER NOT NULL,
            section_id INTEGER NOT NULL,
            question_id INTEGER NOT NULL,
            order_index INTEGER NOT NULL
        );
        """
    )


def _insert_rows(cursor, table, rows):
    if not rows:
        return
    columns = list(rows[0].keys())
    if table == "question" and "choices" in columns:
        columns = [("choices_json" if col == "choices" else col) for col in columns]
    placeholders = ",".join(["?"] * len(columns))
    sql = f"INSERT INTO {table} ({','.join(columns)}) VALUES ({placeholders})"
    values = []
    for row in rows:
        record = dict(row)
        if table == "question":
            record["choices_json"] = json.dumps(record.pop("choices"))
        values.append([record.get(column) for column in columns])
    cursor.executemany(sql, values)


def build_db(source_path, output_path):
    errors = validate(source_path)
    if errors:
        raise ValueError("validation failed")

    data = _load_json(source_path)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    if os.path.exists(output_path):
        os.remove(output_path)

    connection = sqlite3.connect(output_path)
    try:
        cursor = connection.cursor()
        _create_schema(cursor)
        _insert_rows(cursor, "vocab", data["vocab"])
        _insert_rows(cursor, "grammar", data["grammar"])
        _insert_rows(cursor, "question", data["question"])
        _insert_rows(cursor, "mock_test", data["mock_test"])
        _insert_rows(cursor, "mock_test_section", data["mock_test_section"])
        _insert_rows(cursor, "mock_test_question_map", data["mock_test_question_map"])
        connection.commit()
    finally:
        connection.close()


def main():
    source_path = sys.argv[1] if len(sys.argv) > 1 else "tools/content/content.json"
    output_path = (
        sys.argv[2] if len(sys.argv) > 2 else "assets/db/content.sqlite"
    )
    try:
        build_db(source_path, output_path)
    except ValueError:
        print("ERROR: validation failed")
        return 1
    print(f"OK: wrote {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
