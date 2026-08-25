# D1 Database Setup Report
Date: Tue Aug 25 07:24:20 UTC 2026

## Database
- **Name**: quran-circles-db
- **UUID**: `63369c25-6332-4c78-aeeb-476b5a53e156`

## Tables

 ⛅️ wrangler 4.125.0
────────────────────
Resource location: remote 

🌀 Executing on remote database quran-circles-db (63369c25-6332-4c78-aeeb-476b5a53e156):
🌀 To execute on your local development database, remove the --remote flag from your wrangler command.
🚣 Executed 1 command in 0.25ms
[
  {
    "results": [
      {
        "name": "_cf_KV"
      },
      {
        "name": "daily_records"
      },
      {
        "name": "halaqas"
      },
      {
        "name": "student_transfers"
      },
      {
        "name": "students"
      },
      {
        "name": "users"
      },
      {
        "name": "weekly_plans"
      }
    ],
    "success": true,
    "meta": {
      "served_by": "v3-prod",
      "served_by_region": "ENAM",
      "served_by_colo": "IAD",
      "served_by_primary": true,
      "timings": {
        "sql_duration_ms": 0.2488
      },
      "duration": 0.2488,
      "changes": 0,
      "last_row_id": 0,
      "changed_db": false,
      "size_after": 139264,
      "rows_read": 37,
      "rows_written": 0,
      "total_attempts": 1
    }
  }
]

## Row counts
- users: 0 rows
- halaqas: 0 rows
- students: 0 rows
- daily_records: 0 rows
- weekly_plans: 0 rows
- student_transfers: 0 rows
