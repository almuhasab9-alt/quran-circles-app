// Quran Circles API — Cloudflare Worker over D1
// REST API for quran-circles-app Flutter frontend

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Content-Type': 'application/json',
};

function json(data, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: CORS_HEADERS });
}

function error(msg, status = 400) {
  return json({ error: msg }, status);
}

// Convert DB row (snake_case) to camelCase JSON for the Flutter client
function toCamel(row) {
  if (!row) return null;
  const out = {};
  for (const [k, v] of Object.entries(row)) {
    const camel = k.replace(/_([a-z])/g, (_, c) => c.toUpperCase());
    // D1 stores booleans as 0/1 integers
    if (camel === 'active' || camel === 'isFriday') {
      out[camel] = v === 1 || v === true;
    } else {
      out[camel] = v;
    }
  }
  return out;
}

async function body(req) {
  try { return await req.json(); }
  catch { return {}; }
}

// ─── Auth: shared HMAC token verification with quran-auth-api ───
// نفس آلية التوكن في quran-auth-api (HMAC-SHA256 + payload {sub, role, exp})
// ⚠️ المفتاح يُقرأ حصراً من أسرار النشر (wrangler secret put HMAC_SECRET)
//    ولا يوجد أي مفتاح احتياطي في الكود — إن غاب السر تُرفض كل الطلبات.

function b64encode(buf) {
  const bytes = new Uint8Array(buf);
  let bin = '';
  const chunk = 0x8000;
  for (let i = 0; i < bytes.length; i += chunk) {
    bin += String.fromCharCode.apply(null, bytes.subarray(i, i + chunk));
  }
  return btoa(bin);
}

function b64decode(s) {
  const bin = atob(s);
  const bytes = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
  return bytes;
}

function getSecret(env) {
  if (!env || !env.HMAC_SECRET) {
    throw new Error('HMAC_SECRET is not configured (set via: wrangler secret put HMAC_SECRET)');
  }
  return env.HMAC_SECRET;
}

async function verifyToken(token, secret) {
  try {
    const [bodyPart, sig] = token.split('.');
    if (!bodyPart || !sig) return null;
    const key = await crypto.subtle.importKey(
      'raw',
      new TextEncoder().encode(secret),
      { name: 'HMAC', hash: 'SHA-256' },
      false,
      ['sign']
    );
    const expected = b64encode(
      await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(bodyPart))
    ).replace(/=+$/, '');
    if (expected !== sig) return null;
    const pad = bodyPart + '='.repeat((4 - (bodyPart.length % 4)) % 4);
    const payload = JSON.parse(new TextDecoder().decode(b64decode(pad)));
    if (payload.exp && payload.exp < Date.now() / 1000) return null;
    return payload;
  } catch {
    return null;
  }
}

async function requireAuth(request, env) {
  const h = request.headers.get('Authorization') || '';
  const token = h.startsWith('Bearer ') ? h.slice(7) : null;
  if (!token) return null;
  return await verifyToken(token, getSecret(env));
}

// ─── Router ───
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;
    const method = request.method;

    if (method === 'OPTIONS') return new Response(null, { headers: CORS_HEADERS });

    const db = env.DB;
    if (!db) return error('D1 binding not configured', 500);

    // ─── مصادقة: كل المسارات تتطلب توكن صالح (عدا GET /api/health) ───
    const auth = await requireAuth(request, env);
    if (path !== '/api/health' && !auth) {
      return error('غير مصرح', 401);
    }
    if ((path === '/api/wipe' || path === '/api/seed') && (!auth || auth.role !== 'supervisor')) {
      return error('غير مصرح — هذه العملية للمشرف فقط', 403);
    }

    // ─── تفويض الكتابة: إدارة الكيانات للمشرف فقط ───
    // المعلمون يكتبون سجلاتهم اليومية فقط (مسارات /api/daily-records)
    const isWrite = method === 'POST' || method === 'PUT' || method === 'DELETE';
    const supervisorOnlyWrite =
      isWrite && (
        path.startsWith('/api/users') ||
        path.startsWith('/api/halaqas') ||
        path.startsWith('/api/students') ||
        path.startsWith('/api/weekly-plans') ||
        path.startsWith('/api/student-transfers') ||
        path === '/api/transfer-student'
      );
    if (supervisorOnlyWrite && auth.role !== 'supervisor') {
      return error('غير مصرح — إدارة البيانات للمشرف فقط', 403);
    }

    try {
      // ─── Health ───
      if (path === '/api/health' && method === 'GET') {
        const r = await db.prepare('SELECT COUNT(*) as c FROM users').first();
        return json({ status: 'ok', tables: { users: r?.c || 0 } });
      }

      // ─── Seed (POST /api/seed) ───
      if (path === '/api/seed' && method === 'POST') {
        return await seed(db, request);
      }

      // ─── Wipe (POST /api/wipe) ───
      if (path === '/api/wipe' && method === 'POST') {
        await db.batch([
          db.prepare('DELETE FROM daily_records'),
          db.prepare('DELETE FROM weekly_plans'),
          db.prepare('DELETE FROM student_transfers'),
          db.prepare('DELETE FROM students'),
          db.prepare('DELETE FROM halaqas'),
          db.prepare('DELETE FROM users'),
        ]);
        return json({ ok: true, message: 'All data wiped' });
      }

      // ─── Users ───
      if (path === '/api/users') {
        if (method === 'GET') {
          const role = url.searchParams.get('role');
          let stmt;
          if (role) {
            stmt = db.prepare('SELECT * FROM users WHERE role = ? AND active = 1 ORDER BY full_name').bind(role);
          } else {
            stmt = db.prepare('SELECT * FROM users ORDER BY full_name');
          }
          const { results } = await stmt.all();
          return json(results.map(toCamel));
        }
        if (method === 'POST') {
          const b = await body(request);
          const id = b.id || crypto.randomUUID();
          await db.prepare(
            `INSERT INTO users (id, full_name, username, role, active, assigned_halaqa_ids, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)`
          ).bind(id, b.fullName, b.username, b.role || 'teacher',
            b.active === false ? 0 : 1, b.assignedHalaqaIds || '',
            b.createdAt || Date.now(), b.updatedAt || Date.now()
          ).run();
          return json({ id, ...b, createdAt: b.createdAt || Date.now(), updatedAt: b.updatedAt || Date.now() }, 201);
        }
      }

      if (path.startsWith('/api/users/') && method === 'GET') {
        const id = path.split('/')[3];
        const row = await db.prepare('SELECT * FROM users WHERE id = ?').bind(id).first();
        return row ? json(toCamel(row)) : error('User not found', 404);
      }

      // ─── Halaqas ───
      if (path === '/api/halaqas') {
        if (method === 'GET') {
          const includeInactive = url.searchParams.get('includeInactive') === 'true';
          const stmt = includeInactive
            ? db.prepare('SELECT * FROM halaqas ORDER BY name')
            : db.prepare('SELECT * FROM halaqas WHERE active = 1 ORDER BY name');
          const { results } = await stmt.all();
          return json(results.map(toCamel));
        }
        if (method === 'POST') {
          const b = await body(request);
          const id = b.id || crypto.randomUUID();
          await db.prepare(
            `INSERT INTO halaqas (id, name, level, teacher_ids, supervisor_id, capacity, schedule_description, active)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)`
          ).bind(id, b.name, b.level || '', b.teacherIds || '', b.supervisorId || '',
            b.capacity || 25, b.scheduleDescription || '', b.active === false ? 0 : 1
          ).run();
          return json({ id, ...b }, 201);
        }
      }

      // ─── Halaqas by teacher/supervisor (يجب أن تأتي قبل الراوت العام /api/halaqas/:id) ───
      if (path.startsWith('/api/halaqas/by-teacher/')) {
        const teacherId = path.split('/')[4];
        const { results } = await db.prepare('SELECT * FROM halaqas WHERE teacher_ids LIKE ? AND active = 1').bind(`%${teacherId}%`).all();
        return json(results.map(toCamel));
      }
      if (path.startsWith('/api/halaqas/by-supervisor/')) {
        const supId = path.split('/')[4];
        const { results } = await db.prepare('SELECT * FROM halaqas WHERE supervisor_id = ? AND active = 1').bind(supId).all();
        return json(results.map(toCamel));
      }

      if (path.startsWith('/api/halaqas/')) {
        const id = path.split('/')[3];
        if (method === 'GET') {
          const row = await db.prepare('SELECT * FROM halaqas WHERE id = ?').bind(id).first();
          return row ? json(toCamel(row)) : error('Halaqa not found', 404);
        }
        if (method === 'PUT') {
          const b = await body(request);
          const sets = [];
          const vals = [];
          const fields = ['name', 'level', 'teacher_ids', 'supervisor_id', 'capacity', 'schedule_description', 'active'];
          const camelMap = { name: 'name', level: 'level', teacherIds: 'teacher_ids', supervisorId: 'supervisor_id', capacity: 'capacity', scheduleDescription: 'schedule_description', active: 'active' };
          for (const [camel, snake] of Object.entries(camelMap)) {
            if (b[camel] !== undefined) {
              sets.push(`${snake} = ?`);
              vals.push(camel === 'active' ? (b[camel] ? 1 : 0) : b[camel]);
            }
          }
          if (sets.length === 0) return error('No fields to update');
          vals.push(id);
          await db.prepare(`UPDATE halaqas SET ${sets.join(', ')} WHERE id = ?`).bind(...vals).run();
          return json({ ok: true });
        }
        if (method === 'DELETE') {
          await db.prepare('UPDATE halaqas SET active = 0 WHERE id = ?').bind(id).run();
          return json({ ok: true });
        }
      }

      // ─── Students ───
      if (path === '/api/students') {
        if (method === 'GET') {
          const includeInactive = url.searchParams.get('includeInactive') === 'true';
          const halaqaId = url.searchParams.get('halaqaId');
          const searchQ = url.searchParams.get('q');
          let stmt;
          if (halaqaId) {
            stmt = db.prepare('SELECT * FROM students WHERE halaqa_id = ? AND active = 1 ORDER BY full_name').bind(halaqaId);
          } else if (searchQ) {
            stmt = db.prepare('SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? ORDER BY full_name').bind(`%${searchQ}%`, `%${searchQ}%`);
          } else if (includeInactive) {
            stmt = db.prepare('SELECT * FROM students ORDER BY full_name');
          } else {
            stmt = db.prepare('SELECT * FROM students WHERE active = 1 ORDER BY full_name');
          }
          const { results } = await stmt.all();
          return json(results.map(toCamel));
        }
        if (method === 'POST') {
          const b = await body(request);
          const id = b.id || crypto.randomUUID();
          await db.prepare(
            `INSERT INTO students (id, student_code, full_name, halaqa_id, level, active, join_date, internal_notes, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
          ).bind(id, b.studentCode, b.fullName, b.halaqaId || '', b.level || '',
            b.active === false ? 0 : 1, b.joinDate || Date.now(), b.internalNotes || '',
            b.createdAt || Date.now(), b.updatedAt || Date.now()
          ).run();
          return json({ id, ...b }, 201);
        }
      }

      // ─── Student by id (GET/PUT/DELETE) — الشرط القديم `&& !path.includes('/')`
      // كان مستحيلاً دائماً (المسار يحتوي '/' دائماً) فكانت كل العمليات الفردية ترمي 404 ───
      if (path.startsWith('/api/students/')) {
        const id = path.split('/')[3];
        if (!id) return error('Not found', 404);
        if (method === 'GET') {
          const row = await db.prepare('SELECT * FROM students WHERE id = ?').bind(id).first();
          return row ? json(toCamel(row)) : error('Student not found', 404);
        }
        if (method === 'PUT') {
          const b = await body(request);
          const sets = [];
          const vals = [];
          const fields = { fullName: 'full_name', halaqaId: 'halaqa_id', level: 'level', active: 'active', internalNotes: 'internal_notes', updatedAt: 'updated_at' };
          for (const [camel, snake] of Object.entries(fields)) {
            if (b[camel] !== undefined) {
              sets.push(`${snake} = ?`);
              vals.push(camel === 'active' ? (b[camel] ? 1 : 0) : b[camel]);
            }
          }
          if (sets.length === 0) return error('No fields to update');
          vals.push(id);
          await db.prepare(`UPDATE students SET ${sets.join(', ')} WHERE id = ?`).bind(...vals).run();
          return json({ ok: true });
        }
        if (method === 'DELETE') {
          await db.prepare('UPDATE students SET active = 0 WHERE id = ?').bind(id).run();
          return json({ ok: true });
        }
      }

      // ─── Daily Records ───
      if (path === '/api/daily-records') {
        if (method === 'GET') {
          const studentId = url.searchParams.get('studentId');
          const halaqaId = url.searchParams.get('halaqaId');
          const dateKey = url.searchParams.get('dateKey');
          const fromKey = url.searchParams.get('from');
          const toKey = url.searchParams.get('to');
          let stmt;
          if (studentId && dateKey) {
            stmt = db.prepare('SELECT * FROM daily_records WHERE student_id = ? AND date_key = ?').bind(studentId, dateKey);
            const row = await stmt.first();
            return row ? json(toCamel(row)) : json(null);
          }
          if (studentId && fromKey && toKey) {
            stmt = db.prepare('SELECT * FROM daily_records WHERE student_id = ? AND date_key BETWEEN ? AND ? ORDER BY date_key ASC').bind(studentId, fromKey, toKey);
          } else if (halaqaId && fromKey && toKey) {
            stmt = db.prepare('SELECT * FROM daily_records WHERE halaqa_id = ? AND date_key BETWEEN ? AND ? ORDER BY date_key ASC').bind(halaqaId, fromKey, toKey);
          } else if (halaqaId && dateKey) {
            stmt = db.prepare('SELECT * FROM daily_records WHERE halaqa_id = ? AND date_key = ? ORDER BY created_at').bind(halaqaId, dateKey);
          } else if (halaqaId) {
            stmt = db.prepare('SELECT * FROM daily_records WHERE halaqa_id = ? ORDER BY date_key DESC').bind(halaqaId);
          } else if (studentId) {
            stmt = db.prepare('SELECT * FROM daily_records WHERE student_id = ? ORDER BY date_key DESC').bind(studentId);
          } else {
            stmt = db.prepare('SELECT * FROM daily_records ORDER BY date_key DESC LIMIT 500');
          }
          const { results } = await stmt.all();
          return json(results.map(toCamel));
        }
        if (method === 'POST') {
          const b = await body(request);
          if (!b.studentId || !b.dateKey) return error('studentId and dateKey are required');
          const id = b.id || crypto.randomUUID();
          // إدراج أو تحديث (طالب + يوم = سجل واحد) — يمكن للمعلم تعديل سجل اليوم بأمان
          await db.prepare(
            `INSERT INTO daily_records (
              id, student_id, halaqa_id, teacher_id, date, date_key, weekday, is_friday,
              new_from_surah, new_from_ayah, new_to_surah, new_to_ayah, new_pages,
              grade, repetition,
              recent_from_page, recent_to_page,
              minor_from_page, minor_to_page,
              major_from_page, major_to_page,
              notes, created_at, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(student_id, date_key) DO UPDATE SET
              id = excluded.id,
              halaqa_id = excluded.halaqa_id,
              teacher_id = excluded.teacher_id,
              date = excluded.date,
              weekday = excluded.weekday,
              is_friday = excluded.is_friday,
              new_from_surah = excluded.new_from_surah,
              new_from_ayah = excluded.new_from_ayah,
              new_to_surah = excluded.new_to_surah,
              new_to_ayah = excluded.new_to_ayah,
              new_pages = excluded.new_pages,
              grade = excluded.grade,
              repetition = excluded.repetition,
              recent_from_page = excluded.recent_from_page,
              recent_to_page = excluded.recent_to_page,
              minor_from_page = excluded.minor_from_page,
              minor_to_page = excluded.minor_to_page,
              major_from_page = excluded.major_from_page,
              major_to_page = excluded.major_to_page,
              notes = excluded.notes,
              updated_at = excluded.updated_at`
          ).bind(
            id, b.studentId, b.halaqaId, b.teacherId || '', b.date || Date.now(),
            b.dateKey, b.weekday || 1, b.isFriday ? 1 : 0,
            b.newFromSurah || 0, b.newFromAyah || 0, b.newToSurah || 0, b.newToAyah || 0, b.newPages || 0,
            b.grade || '', b.repetition || 0,
            b.recentFromPage || 0, b.recentToPage || 0,
            b.minorFromPage || 0, b.minorToPage || 0,
            b.majorFromPage || 0, b.majorToPage || 0,
            b.notes || '', b.createdAt || Date.now(), Date.now()
          ).run();
          return json({ id, ...b }, 201);
        }
      }

      // ─── Weekly Plans ───
      if (path === '/api/weekly-plans') {
        if (method === 'GET') {
          const studentId = url.searchParams.get('studentId');
          const halaqaId = url.searchParams.get('halaqaId');
          let stmt;
          if (studentId) {
            stmt = db.prepare('SELECT * FROM weekly_plans WHERE student_id = ? ORDER BY week_start_key DESC').bind(studentId);
          } else if (halaqaId) {
            stmt = db.prepare('SELECT * FROM weekly_plans WHERE halaqa_id = ? ORDER BY week_start_key DESC').bind(halaqaId);
          } else {
            stmt = db.prepare('SELECT * FROM weekly_plans ORDER BY week_start_key DESC LIMIT 500');
          }
          const { results } = await stmt.all();
          return json(results.map(toCamel));
        }
        if (method === 'POST') {
          const b = await body(request);
          if (!b.studentId || !b.weekStartKey) return error('studentId and weekStartKey are required');
          const id = b.id || crypto.randomUUID();
          // إدراج أو تحديث (طالب + أسبوع = خطة واحدة)
          await db.prepare(
            `INSERT INTO weekly_plans (
              id, student_id, halaqa_id, week_start_key,
              required_new_pages, required_recent_pages, required_minor_pages, required_major_pages, required_friday_pages,
              created_at, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(student_id, week_start_key) DO UPDATE SET
              halaqa_id = excluded.halaqa_id,
              required_new_pages = excluded.required_new_pages,
              required_recent_pages = excluded.required_recent_pages,
              required_minor_pages = excluded.required_minor_pages,
              required_major_pages = excluded.required_major_pages,
              required_friday_pages = excluded.required_friday_pages,
              updated_at = excluded.updated_at`
          ).bind(
            id, b.studentId, b.halaqaId, b.weekStartKey,
            b.requiredNewPages || 0, b.requiredRecentPages || 0, b.requiredMinorPages || 0,
            b.requiredMajorPages || 0, b.requiredFridayPages || 0,
            b.createdAt || Date.now(), Date.now()
          ).run();
          return json({ id, ...b }, 201);
        }
      }

      // ─── Student Transfers ───
      if (path === '/api/student-transfers') {
        if (method === 'GET') {
          const studentId = url.searchParams.get('studentId');
          let stmt;
          if (studentId) {
            stmt = db.prepare('SELECT * FROM student_transfers WHERE student_id = ? ORDER BY transferred_at DESC').bind(studentId);
          } else {
            stmt = db.prepare('SELECT * FROM student_transfers ORDER BY transferred_at DESC LIMIT 100');
          }
          const { results } = await stmt.all();
          return json(results.map(toCamel));
        }
        if (method === 'POST') {
          const b = await body(request);
          const id = b.id || crypto.randomUUID();
          await db.prepare(
            `INSERT INTO student_transfers (id, student_id, from_halaqa_id, to_halaqa_id, transferred_at, by_user)
             VALUES (?, ?, ?, ?, ?, ?)`
          ).bind(id, b.studentId, b.fromHalaqaId, b.toHalaqaId, b.transferredAt || Date.now(), b.byUser || '').run();
          return json({ id, ...b }, 201);
        }
      }

      // ─── Transfer endpoint (atomic) ───
      if (path === '/api/transfer-student' && method === 'POST') {
        const b = await body(request);
        const { studentId, toHalaqaId, byUserId } = b;
        if (!studentId || !toHalaqaId) return error('studentId and toHalaqaId required');

        const student = await db.prepare('SELECT * FROM students WHERE id = ?').bind(studentId).first();
        if (!student) return error('الطالب غير موجود.', 404);

        const target = await db.prepare('SELECT * FROM halaqas WHERE id = ?').bind(toHalaqaId).first();
        if (!target) return error('الحلقة المستهدفة غير موجودة.', 404);
        if (!target.active) return error('الحلقة المستهدفة غير نشطة.');
        if (student.halaqa_id === toHalaqaId) return error('الطالب موجود أصلاً في هذه الحلقة.');

        const { results: currentCount } = await db.prepare('SELECT COUNT(*) as c FROM students WHERE halaqa_id = ? AND active = 1').bind(toHalaqaId).all();
        if (currentCount[0]?.c >= target.capacity) {
          return error(`الحلقة «${target.name}» ممتلئة (السعة ${target.capacity}).`);
        }

        const fromHalaqaId = student.halaqa_id;
        const now = Date.now();
        const newTeacherId = target.teacher_ids.split(',')[0]?.trim() || '';
        const transferId = crypto.randomUUID();

        await db.batch([
          db.prepare('INSERT INTO student_transfers (id, student_id, from_halaqa_id, to_halaqa_id, transferred_at, by_user) VALUES (?, ?, ?, ?, ?, ?)')
            .bind(transferId, studentId, fromHalaqaId, toHalaqaId, now, byUserId || ''),
          db.prepare('UPDATE students SET halaqa_id = ?, updated_at = ? WHERE id = ?')
            .bind(toHalaqaId, now, studentId),
          db.prepare('UPDATE daily_records SET halaqa_id = ?, teacher_id = ?, updated_at = ? WHERE student_id = ?')
            .bind(toHalaqaId, newTeacherId, now, studentId),
          db.prepare('UPDATE weekly_plans SET halaqa_id = ?, updated_at = ? WHERE student_id = ?')
            .bind(toHalaqaId, now, studentId),
        ]);
        return json({ ok: true });
      }

      // ─── 404 ───
      return error('Not found', 404);

    } catch (e) {
      return error(e.message || 'Internal server error', 500);
    }
  }
};

// ─── Seed function (deterministic, seed=2026) ───
// Mirrors DemoSeedService in Flutter
const FIRST_NAMES = ['محمد','أحمد','عبدالله','عبدالرحمن','خالد','سعد','فهد','عمر','يوسف','إبراهيم','سلطان','ناصر','علي','حسن','طارق','زياد','ماجد','بدر','فيصل','تركي','سالم','مشعل','راشد','هاني','وليد','أنس','عمار','بلال','حمزة','صالح'];
const SECOND_NAMES = ['علي','حسين','سعيد','عوض','جابر','مبارك','قاسم','ناجي','عادل','طاهر','شائع','مفلح','هديان','صائل','مرزوق','جمعان','داوود','لقمان','وهبان','هيثم'];
const TEACHER_FIRST = ['عبدالعزيز','منصور','زكريا','يحيى','إسماعيل','عثمان','بلال','معاذ','أنس','زيد','سفيان','طلحة'];
const TEACHER_SECOND = ['أحمد','محمد','صالح','علي','حسن','يوسف','إبراهيم','عمر','خالد','سعد','فهد','ناصر'];
const HALAQA_NAMES = ['حلقة النور','حلقة الفرقان','حلقة الإخلاص','حلقة التقوى','حلقة الهدى','حلقة الصديق','حلقة الفاروق','حلقة ذي النورين'];
const LEVELS = ['مبتدئ','متوسط','متقدم'];

function uuid() { return crypto.randomUUID(); }

// LCG random with fixed seed (deterministic)
function makeRng(seed) {
  let s = seed;
  return () => {
    s = (s * 1103515245 + 12345) & 0x7fffffff;
    return s / 0x7fffffff;
  };
}
function randInt(rng, max) { return Math.floor(rng() * max); }
function pick(rng, arr) { return arr[randInt(rng, arr.length)]; }

async function seed(db, request) {
  // Check if already seeded
  const existing = await db.prepare('SELECT COUNT(*) as c FROM users').first();
  if (existing?.c > 0) {
    return json({ ok: true, message: 'Already seeded', users: existing.c });
  }

  const rng = makeRng(2026);
  const now = Date.now();
  const nowDate = new Date(now);
  const today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate());
  const grades = ['excellent','veryGood','veryGood','good','good','excellent','veryGood','repeat'];

  // Week start (Saturday)
  const dayDiff = (today.getDay() - 6 + 7) % 7;
  const thisWeekStart = new Date(today.getTime() - dayDiff * 86400000);

  const statements = [];

  // 2 supervisors
  const supervisorIds = [];
  for (let i = 0; i < 2; i++) {
    const id = uuid();
    supervisorIds.push(id);
    const name = i === 0 ? 'أبو عمر صالح' : `${TEACHER_FIRST[i]} ${TEACHER_SECOND[i]}`;
    const username = i === 0 ? 'supervisor' : 'supervisor2';
    statements.push(db.prepare(
      'INSERT INTO users (id, full_name, username, role, active, assigned_halaqa_ids, created_at, updated_at) VALUES (?, ?, ?, ?, 1, ?, ?, ?)'
    ).bind(id, name, username, 'supervisor', '', now, now));
  }

  // 8 teachers
  const teacherIds = [];
  for (let i = 0; i < 8; i++) {
    const id = uuid();
    teacherIds.push(id);
    const nm = `${TEACHER_FIRST[i + 2]} ${TEACHER_SECOND[i]}`;
    statements.push(db.prepare(
      'INSERT INTO users (id, full_name, username, role, active, assigned_halaqa_ids, created_at, updated_at) VALUES (?, ?, ?, ?, 1, ?, ?, ?)'
    ).bind(id, nm, `teacher${i + 1}`, 'teacher', '', now, now));
  }

  // 8 halaqas
  const halaqaIds = [];
  const halaqaTeacher = {};
  for (let i = 0; i < 8; i++) {
    const id = uuid();
    halaqaIds.push(id);
    const tid = teacherIds[i];
    halaqaTeacher[id] = tid;
    statements.push(db.prepare(
      'INSERT INTO halaqas (id, name, level, teacher_ids, supervisor_id, capacity, schedule_description, active) VALUES (?, ?, ?, ?, ?, 25, ?, 1)'
    ).bind(id, HALAQA_NAMES[i], LEVELS[i % LEVELS.length], tid, supervisorIds[i % 2], 'يومياً من السبت إلى الجمعة - بعد العصر'));
    statements.push(db.prepare('UPDATE users SET assigned_halaqa_ids = ? WHERE id = ?').bind(id, tid));
  }

  // 12 students per halaqa
  const studentIds = [];
  const studentHalaqa = {};
  let code = 1000;
  for (const hid of halaqaIds) {
    const hlevel = LEVELS[halaqaIds.indexOf(hid) % LEVELS.length];
    for (let j = 0; j < 12; j++) {
      code++;
      const stId = uuid();
      studentIds.push(stId);
      studentHalaqa[stId] = hid;
      const name = `${pick(rng, FIRST_NAMES)} ${pick(rng, SECOND_NAMES)}`;
      const joinOffset = 60 + randInt(rng, 400);
      const joinDate = now - joinOffset * 86400000;
      statements.push(db.prepare(
        'INSERT INTO students (id, student_code, full_name, halaqa_id, level, active, join_date, internal_notes, created_at, updated_at) VALUES (?, ?, ?, ?, ?, 1, ?, ?, ?, ?)'
      ).bind(stId, `ST${code}`, name, hid, hlevel, joinDate, '', now, now));
    }
  }

  // Progress tracking for surah/ayah advancement
  const progress = {};
  for (let i = 0; i < studentIds.length; i++) {
    progress[studentIds[i]] = { surah: 83 + (i % 8), ayah: 1 };
  }

  // 12 weeks of records
  for (let w = 0; w < 12; w++) {
    const weekStart = new Date(thisWeekStart.getTime() - (11 - w) * 7 * 86400000);
    const weekKey = weekStart.toISOString().slice(0, 10);

    for (const sid of studentIds) {
      const hid = studentHalaqa[sid];
      const tid = halaqaTeacher[hid];

      // Weekly plan
      statements.push(db.prepare(
        'INSERT INTO weekly_plans (id, student_id, halaqa_id, week_start_key, required_new_pages, required_recent_pages, required_minor_pages, required_major_pages, required_friday_pages, created_at, updated_at) VALUES (?, ?, ?, ?, 2, 3, 5, 10, 4, ?, ?)'
      ).bind(uuid(), sid, hid, weekKey, now, now));

      // 7 days
      for (let d = 0; d < 7; d++) {
        const date = new Date(weekStart.getTime() + d * 86400000);
        if (date.getTime() > today.getTime()) continue;
        const dateKey = date.toISOString().slice(0, 10);
        const weekday = date.getDay() === 6 ? 6 : date.getDay() === 0 ? 7 : date.getDay();
        const isFriday = date.getDay() === 5;

        if (isFriday) {
          const rf = 1 + randInt(rng, 500);
          const rt = rf + 2 + randInt(rng, 3);
          statements.push(db.prepare(
            `INSERT INTO daily_records (id, student_id, halaqa_id, teacher_id, date, date_key, weekday, is_friday, recent_from_page, recent_to_page, notes, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?, ?)`
          ).bind(uuid(), sid, hid, tid, date.getTime(), dateKey, weekday, rf, Math.min(rt, 604), 'ربط الجمعة', now, now));
        } else {
          const cur = progress[sid];
          const span = 4 + randInt(rng, 8);
          let fs = cur.surah, fa = cur.ayah;
          let ts = fs, ta = fa + span;
          // Simple surah wrap
          if (ta > 286) { ts = Math.min(ts + 1, 114); ta = ta - 286; if (ta < 1) ta = 1; }
          const pages = Math.round((ta - fa) / 15 * 10) / 10; // approximate pages
          // Advance progress
          const nextAyah = ta + 1;
          if (nextAyah > 286) { progress[sid] = { surah: Math.min(ts + 1, 114), ayah: 1 }; }
          else { progress[sid] = { surah: ts, ayah: nextAyah }; }

          const recentF = 1 + randInt(rng, 100);
          const minorF = 100 + randInt(rng, 200);
          const majorF = 300 + randInt(rng, 200);

          statements.push(db.prepare(
            `INSERT INTO daily_records (
              id, student_id, halaqa_id, teacher_id, date, date_key, weekday, is_friday,
              new_from_surah, new_from_ayah, new_to_surah, new_to_ayah, new_pages,
              grade, repetition,
              recent_from_page, recent_to_page,
              minor_from_page, minor_to_page,
              major_from_page, major_to_page,
              notes, created_at, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
          ).bind(
            uuid(), sid, hid, tid, date.getTime(), dateKey, weekday,
            fs, fa, ts, ta, pages || 0,
            pick(rng, grades), 3 + randInt(rng, 8),
            recentF, recentF + randInt(rng, 2),
            minorF, minorF + randInt(rng, 3),
            majorF, majorF + 1 + randInt(rng, 4),
            rng() < 0.15 ? 'يحتاج تركيزاً على مخارج الحروف' : '',
            now, now
          ));
        }
      }
    }
  }

  // Execute in batches of 50 (D1 batch limit)
  for (let i = 0; i < statements.length; i += 50) {
    await db.batch(statements.slice(i, i + 50));
  }

  const counts = await db.prepare('SELECT COUNT(*) as c FROM daily_records').first();
  return json({ ok: true, message: 'Seed complete', dailyRecords: counts?.c || 0 });
}
