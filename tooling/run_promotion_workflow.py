#!/usr/bin/env python3
"""Scheduled workflow runner for N4 curated -> manual promotion.

Use this as the release/tooling entrypoint, then trigger it:
- at app start (schedule=app-start)
- daily/weekly in CI or Task Scheduler (schedule=weekly)
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict

from promote_n4_curated_from_mistakes import (
    CONTENT_DB_PATH,
    OVERRIDES_PATH,
    REPORT_PATH,
    USER_DB_PATH,
    run_promotion,
)


ROOT = Path(__file__).resolve().parents[1]
STATE_PATH = ROOT / "tooling" / "reports" / "n4_promotion_schedule_state.json"


def _utc_now_iso() -> str:
    return (
        datetime.now(timezone.utc)
        .replace(microsecond=0)
        .isoformat()
        .replace("+00:00", "Z")
    )


def _parse_iso_utc(value: str | None) -> datetime | None:
    if not value:
        return None
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00")).astimezone(
            timezone.utc
        )
    except ValueError:
        return None


def _read_state(path: Path) -> Dict[str, Any]:
    if not path.exists():
        return {}
    try:
        raw = json.loads(path.read_text(encoding="utf-8-sig"))
    except json.JSONDecodeError:
        return {}
    return raw if isinstance(raw, dict) else {}


def _write_state(path: Path, state: Dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    state["schemaVersion"] = 1
    path.write_text(json.dumps(state, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def _is_due(
    *,
    schedule: str,
    interval_days: int,
    state: Dict[str, Any],
) -> tuple[bool, str]:
    if schedule == "always":
        return True, "forced_always"

    last_run = _parse_iso_utc(state.get("lastRunAtUtc"))
    if last_run is None:
        return True, "first_run"

    interval_sec = max(1, interval_days) * 24 * 60 * 60
    elapsed_sec = (datetime.now(timezone.utc) - last_run).total_seconds()
    if elapsed_sec >= interval_sec:
        return True, "interval_elapsed"

    remaining_hours = max(0, int((interval_sec - elapsed_sec) / 3600))
    return False, f"not_due_{remaining_hours}h"


def _refresh_templates() -> None:
    script = ROOT / "tooling" / "generate_stroke_templates.py"
    subprocess.run([sys.executable, str(script)], check=True)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--schedule",
        choices=("app-start", "weekly", "always"),
        default="weekly",
        help="app-start/weekly use interval gate; always runs every invocation.",
    )
    parser.add_argument(
        "--interval-days",
        type=int,
        default=7,
        help="Minimum days between runs for app-start/weekly schedules.",
    )
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--count", type=int, default=12)
    parser.add_argument("--user-db", type=Path, default=USER_DB_PATH)
    parser.add_argument("--content-db", type=Path, default=CONTENT_DB_PATH)
    parser.add_argument("--overrides-path", type=Path, default=OVERRIDES_PATH)
    parser.add_argument("--report-file", type=Path, default=REPORT_PATH)
    parser.add_argument("--max-history", type=int, default=120)
    parser.add_argument("--state-file", type=Path, default=STATE_PATH)
    parser.add_argument("--skip-template-refresh", action="store_true")
    args = parser.parse_args()

    state = _read_state(args.state_file)
    due, reason = _is_due(
        schedule=args.schedule,
        interval_days=args.interval_days,
        state=state,
    )
    if args.force:
        due = True
        reason = "force_flag"

    now_iso = _utc_now_iso()
    state["lastCheckAtUtc"] = now_iso
    state["schedule"] = args.schedule
    state["intervalDays"] = max(1, int(args.interval_days))

    if not due:
        state["lastSkipReason"] = reason
        _write_state(args.state_file, state)
        print(f"skipped=1 reason={reason} schedule={args.schedule}")
        return

    run_id = f"workflow-{int(time.time())}"
    report = run_promotion(
        count=max(0, int(args.count)),
        user_db=args.user_db,
        content_db=args.content_db,
        overrides_path=args.overrides_path,
        report_file=args.report_file,
        max_history=max(0, int(args.max_history)),
        run_id=run_id,
    )

    refreshed_templates = False
    if report.get("overridesUpdated") and not args.skip_template_refresh:
        _refresh_templates()
        refreshed_templates = True

    run_time = report.get("runAtUtc") or now_iso
    state["lastRunAtUtc"] = run_time
    state["lastRunId"] = report.get("runId")
    state["lastRunMode"] = report.get("mode")
    state["lastPromotedCount"] = int(report.get("promotedCount", 0))
    state["lastReportFile"] = str(args.report_file)
    state["lastTemplateRefreshAtUtc"] = run_time if refreshed_templates else None
    state["lastSkipReason"] = None
    _write_state(args.state_file, state)

    print(
        f"schedule={args.schedule} reason={reason} "
        f"promoted={report.get('promotedCount', 0)} "
        f"templates_refreshed={int(refreshed_templates)} "
        f"report={args.report_file}"
    )


if __name__ == "__main__":
    main()
