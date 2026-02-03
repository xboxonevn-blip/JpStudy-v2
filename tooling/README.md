# Tooling Workflows

## Scheduled N4 Promotion

Use `run_promotion_workflow.py` as the release/tooling entrypoint.

### Run every app start (but gate to weekly)

```bash
python tooling/run_promotion_workflow.py --schedule app-start --interval-days 7
```

### Run from a weekly job (CI / Task Scheduler)

```bash
python tooling/run_promotion_workflow.py --schedule weekly --interval-days 7
```

### Force run now

```bash
python tooling/run_promotion_workflow.py --force
```

## Reports

- Promotion history JSON: `tooling/reports/n4_promotion_history.json`
- Scheduler state JSON: `tooling/reports/n4_promotion_schedule_state.json`

Each promotion run appends one entry to the history file, including:
- run time, mode, promoted count
- list of promoted characters (lesson/stroke/score)
