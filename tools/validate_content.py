import json
import sys


REQUIRED_FIELDS = {
    "vocab": ["id", "term", "meaning", "level"],
    "grammar": ["id", "level", "title", "summary"],
    "question": ["id", "level", "prompt", "choices", "correct_index"],
    "mock_test": ["id", "level", "title", "duration_seconds"],
    "mock_test_section": ["id", "test_id", "title", "order_index"],
    "mock_test_question_map": [
        "id",
        "test_id",
        "section_id",
        "question_id",
        "order_index",
    ],
}


def _error(message):
    print(f"ERROR: {message}")


def _load_json(path):
    with open(path, "r", encoding="utf-8") as handle:
        return json.load(handle)


def _validate_records(name, records, errors):
    if not isinstance(records, list):
        errors.append(f"{name} must be a list")
        return
    seen_ids = set()
    for idx, record in enumerate(records):
        if not isinstance(record, dict):
            errors.append(f"{name}[{idx}] must be an object")
            continue
        missing = [field for field in REQUIRED_FIELDS[name] if field not in record]
        if missing:
            errors.append(f"{name}[{idx}] missing fields: {', '.join(missing)}")
        record_id = record.get("id")
        if record_id in seen_ids:
            errors.append(f"{name}[{idx}] duplicate id {record_id}")
        seen_ids.add(record_id)
        if name == "question":
            choices = record.get("choices")
            correct_index = record.get("correct_index")
            if not isinstance(choices, list) or len(choices) < 2:
                errors.append(f"{name}[{idx}] choices must be a list with 2+ items")
            if not isinstance(correct_index, int):
                errors.append(f"{name}[{idx}] correct_index must be an int")
            elif isinstance(choices, list) and not (0 <= correct_index < len(choices)):
                errors.append(f"{name}[{idx}] correct_index out of range")


def validate(path):
    data = _load_json(path)
    errors = []
    for table_name in REQUIRED_FIELDS:
        if table_name not in data:
            errors.append(f"missing table: {table_name}")
            continue
        _validate_records(table_name, data[table_name], errors)
    return errors


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "tools/content/content.json"
    try:
        errors = validate(path)
    except json.JSONDecodeError as exc:
        _error(f"invalid JSON: {exc}")
        return 1
    if errors:
        for error in errors:
            _error(error)
        return 1
    print("OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
