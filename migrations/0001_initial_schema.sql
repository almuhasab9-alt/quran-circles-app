-- D1 schema for quran-circles-app
-- Derived from lib/core/database/app_database.dart (drift tables)
-- All tables use TEXT primary keys (UUIDs generated client-side)

-- ─────────── users ───────────
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  full_name TEXT NOT NULL,
  username TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'teacher', -- supervisor | teacher
  active INTEGER NOT NULL DEFAULT 1,
  assigned_halaqa_ids TEXT NOT NULL DEFAULT '',
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- ─────────── halaqas ───────────
CREATE TABLE IF NOT EXISTS halaqas (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  level TEXT NOT NULL DEFAULT '',
  teacher_ids TEXT NOT NULL DEFAULT '',
  supervisor_id TEXT NOT NULL DEFAULT '',
  capacity INTEGER NOT NULL DEFAULT 25,
  schedule_description TEXT NOT NULL DEFAULT '',
  active INTEGER NOT NULL DEFAULT 1
);
CREATE INDEX IF NOT EXISTS idx_halaqas_supervisor ON halaqas(supervisor_id);
CREATE INDEX IF NOT EXISTS idx_halaqas_active ON halaqas(active);

-- ─────────── students ───────────
CREATE TABLE IF NOT EXISTS students (
  id TEXT PRIMARY KEY,
  student_code TEXT NOT NULL,
  full_name TEXT NOT NULL,
  halaqa_id TEXT NOT NULL,
  level TEXT NOT NULL DEFAULT '',
  active INTEGER NOT NULL DEFAULT 1,
  join_date INTEGER NOT NULL,
  internal_notes TEXT NOT NULL DEFAULT '',
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_students_halaqa ON students(halaqa_id);
CREATE INDEX IF NOT EXISTS idx_students_active ON students(active);
CREATE INDEX IF NOT EXISTS idx_students_code ON students(student_code);

-- ─────────── daily_records ───────────
-- سجل التسميع اليومي — طالب واحد + يوم واحد = سجل واحد
CREATE TABLE IF NOT EXISTS daily_records (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  halaqa_id TEXT NOT NULL,
  teacher_id TEXT NOT NULL DEFAULT '',
  date INTEGER NOT NULL,
  date_key TEXT NOT NULL, -- YYYY-MM-DD
  weekday INTEGER NOT NULL,
  is_friday INTEGER NOT NULL DEFAULT 0,
  -- الجديد
  new_from_surah INTEGER NOT NULL DEFAULT 0,
  new_from_ayah INTEGER NOT NULL DEFAULT 0,
  new_to_surah INTEGER NOT NULL DEFAULT 0,
  new_to_ayah INTEGER NOT NULL DEFAULT 0,
  new_pages REAL NOT NULL DEFAULT 0,
  -- التقدير
  grade TEXT NOT NULL DEFAULT '', -- excellent | veryGood | good | repeat
  repetition INTEGER NOT NULL DEFAULT 0,
  -- حديث العهد
  recent_from_page INTEGER NOT NULL DEFAULT 0,
  recent_to_page INTEGER NOT NULL DEFAULT 0,
  -- المراجعة الصغرى
  minor_from_page INTEGER NOT NULL DEFAULT 0,
  minor_to_page INTEGER NOT NULL DEFAULT 0,
  -- المراجعة الكبرى
  major_from_page INTEGER NOT NULL DEFAULT 0,
  major_to_page INTEGER NOT NULL DEFAULT 0,
  -- الملاحظات
  notes TEXT NOT NULL DEFAULT '',
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(student_id, date_key)
);
CREATE INDEX IF NOT EXISTS idx_daily_student ON daily_records(student_id);
CREATE INDEX IF NOT EXISTS idx_daily_halaqa ON daily_records(halaqa_id);
CREATE INDEX IF NOT EXISTS idx_daily_date ON daily_records(date_key);
CREATE INDEX IF NOT EXISTS idx_daily_teacher ON daily_records(teacher_id);

-- ─────────── weekly_plans ───────────
CREATE TABLE IF NOT EXISTS weekly_plans (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  halaqa_id TEXT NOT NULL,
  week_start_key TEXT NOT NULL, -- YYYY-MM-DD (Saturday)
  required_new_pages REAL NOT NULL DEFAULT 0,
  required_recent_pages REAL NOT NULL DEFAULT 0,
  required_minor_pages REAL NOT NULL DEFAULT 0,
  required_major_pages REAL NOT NULL DEFAULT 0,
  required_friday_pages REAL NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(student_id, week_start_key)
);
CREATE INDEX IF NOT EXISTS idx_weekly_student ON weekly_plans(student_id);
CREATE INDEX IF NOT EXISTS idx_weekly_halaqa ON weekly_plans(halaqa_id);
CREATE INDEX IF NOT EXISTS idx_weekly_week ON weekly_plans(week_start_key);

-- ─────────── student_transfers ───────────
CREATE TABLE IF NOT EXISTS student_transfers (
  id TEXT PRIMARY KEY,
  student_id TEXT NOT NULL,
  from_halaqa_id TEXT NOT NULL,
  to_halaqa_id TEXT NOT NULL,
  transferred_at INTEGER NOT NULL,
  by_user TEXT NOT NULL DEFAULT ''
);
CREATE INDEX IF NOT EXISTS idx_transfers_student ON student_transfers(student_id);
