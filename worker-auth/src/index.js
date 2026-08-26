var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });

// src/index.js
var CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization"
};
var json = /* @__PURE__ */ __name((data, status = 200) => new Response(JSON.stringify(data), { status, headers: { "Content-Type": "application/json", ...CORS } }), "json");
var b64 = /* @__PURE__ */ __name((buf) => btoa(String.fromCharCode(...new Uint8Array(buf))), "b64");
var fromB64 = /* @__PURE__ */ __name((s) => Uint8Array.from(atob(s), (c) => c.charCodeAt(0)), "fromB64");

function b64EncodeChunked(buf) {
  const bytes = new Uint8Array(buf);
  let bin = "";
  const chunk = 0x8000;
  for (let i = 0; i < bytes.length; i += chunk) {
    bin += String.fromCharCode.apply(null, bytes.subarray(i, i + chunk));
  }
  return btoa(bin);
}
function b64DecodeChunked(s) {
  const bin = atob(s);
  const bytes = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
  return bytes;
}
async function gzipBytes(data) {
  const stream = new Blob([data]).stream().pipeThrough(new CompressionStream("gzip"));
  const buf = await new Response(stream).arrayBuffer();
  return new Uint8Array(buf);
}
async function gunzipBytes(data) {
  const stream = new Blob([data]).stream().pipeThrough(new DecompressionStream("gzip"));
  const buf = await new Response(stream).arrayBuffer();
  return new Uint8Array(buf);
}
async function compressSnapshot(obj) {
  const raw = JSON.stringify(obj);
  const gz = await gzipBytes(new TextEncoder().encode(raw));
  const gzStr = "GZ1:" + b64EncodeChunked(gz);
  return gzStr.length < raw.length ? gzStr : raw;
}
async function decompressSnapshot(stored) {
  if (typeof stored === "string" && stored.startsWith("GZ1:")) {
    const raw = await gunzipBytes(b64DecodeChunked(stored.slice(4)));
    return JSON.parse(new TextDecoder().decode(raw));
  }
  return JSON.parse(stored);
}

async function hashPassword(password, saltB64) {
  const salt = saltB64 ? fromB64(saltB64) : crypto.getRandomValues(new Uint8Array(16));
  const key = await crypto.subtle.importKey("raw", new TextEncoder().encode(password), "PBKDF2", false, ["deriveBits"]);
  const bits = await crypto.subtle.deriveBits(
    { name: "PBKDF2", hash: "SHA-256", salt, iterations: 1e5 },
    key,
    256
  );
  return { hash: b64(bits), salt: b64(salt) };
}
__name(hashPassword, "hashPassword");
async function verifyPassword(password, salt, expectedHash) {
  const { hash } = await hashPassword(password, salt);
  return hash === expectedHash;
}
__name(verifyPassword, "verifyPassword");
async function signToken(payload, secret) {
  const body = b64(new TextEncoder().encode(JSON.stringify(payload))).replace(/=+$/, "");
  const key = await crypto.subtle.importKey("raw", new TextEncoder().encode(secret), { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
  const sig = b64(await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(body))).replace(/=+$/, "");
  return `${body}.${sig}`;
}
__name(signToken, "signToken");
async function verifyToken(token, secret) {
  try {
    const [body, sig] = token.split(".");
    const key = await crypto.subtle.importKey("raw", new TextEncoder().encode(secret), { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
    const expected = b64(await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(body))).replace(/=+$/, "");
    if (expected !== sig) return null;
    const pad = body + "=".repeat((4 - body.length % 4) % 4);
    const payload = JSON.parse(new TextDecoder().decode(fromB64(pad)));
    if (payload.exp && payload.exp < Date.now() / 1e3) return null;
    return payload;
  } catch {
    return null;
  }
}
__name(verifyToken, "verifyToken");
var SECRET = "qc-auth-2a9f7e1c-secret-hmac-key-v1";
function getSecret(env) {
  return (env && env.HMAC_SECRET) || SECRET;
}
var pub = /* @__PURE__ */ __name((a) => ({ id: a.id, username: a.username, fullName: a.full_name, role: a.role, halaqaId: a.halaqa_id, active: !!a.active }), "pub");
async function requireAuth(request, env, role) {
  const h = request.headers.get("Authorization") || "";
  const token = h.startsWith("Bearer ") ? h.slice(7) : null;
  if (!token) return null;
  const p = await verifyToken(token, getSecret(env));
  if (!p) return null;
  if (role && p.role !== role) return null;
  return p;
}
__name(requireAuth, "requireAuth");
var index_default = {
  async fetch(request, env) {
    if (request.method === "OPTIONS") return new Response(null, { headers: CORS });
    const url = new URL(request.url);
    const path = url.pathname;
    try {
      if (path === "/api/login" && request.method === "POST") {
        const { username, password } = await request.json();
        if (!username || !password) return json({ error: "\u0623\u062F\u062E\u0644 \u0627\u0633\u0645 \u0627\u0644\u0645\u0633\u062A\u062E\u062F\u0645 \u0648\u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631" }, 400);
        const acc = await env.DB.prepare("SELECT * FROM accounts WHERE username = ? AND active = 1").bind(username.trim().toLowerCase()).first();
        if (!acc || !await verifyPassword(password, acc.salt, acc.password_hash))
          return json({ error: "\u0627\u0633\u0645 \u0627\u0644\u0645\u0633\u062A\u062E\u062F\u0645 \u0623\u0648 \u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631 \u063A\u064A\u0631 \u0635\u062D\u064A\u062D\u0629" }, 401);
        const token = await signToken({ sub: acc.id, role: acc.role, exp: Math.floor(Date.now() / 1e3) + 60 * 60 * 24 * 30 }, getSecret(env));
        return json({ token, user: pub(acc) });
      }
      if (path === "/api/me" && request.method === "GET") {
        const p = await requireAuth(request, env);
        if (!p) return json({ error: "\u063A\u064A\u0631 \u0645\u0635\u0631\u062D" }, 401);
        const acc = await env.DB.prepare("SELECT * FROM accounts WHERE id = ? AND active = 1").bind(p.sub).first();
        if (!acc) return json({ error: "\u0627\u0644\u062D\u0633\u0627\u0628 \u063A\u064A\u0631 \u0645\u0648\u062C\u0648\u062F" }, 404);
        return json({ user: pub(acc) });
      }
      if (path === "/api/accounts" && request.method === "GET") {
        const p = await requireAuth(request, env, "supervisor");
        if (!p) return json({ error: "\u063A\u064A\u0631 \u0645\u0635\u0631\u062D \u2014 \u0647\u0630\u0647 \u0627\u0644\u0639\u0645\u0644\u064A\u0629 \u0644\u0644\u0645\u0634\u0631\u0641 \u0641\u0642\u0637" }, 403);
        const { results } = await env.DB.prepare("SELECT * FROM accounts ORDER BY role DESC, created_at").all();
        return json({ accounts: results.map(pub) });
      }
      if (path === "/api/accounts" && request.method === "POST") {
        const p = await requireAuth(request, env, "supervisor");
        if (!p) return json({ error: "\u063A\u064A\u0631 \u0645\u0635\u0631\u062D \u2014 \u0647\u0630\u0647 \u0627\u0644\u0639\u0645\u0644\u064A\u0629 \u0644\u0644\u0645\u0634\u0631\u0641 \u0641\u0642\u0637" }, 403);
        const { username, password, fullName, halaqaId } = await request.json();
        if (!username || !password || password.length < 6)
          return json({ error: "\u0627\u0633\u0645 \u0627\u0644\u0645\u0633\u062A\u062E\u062F\u0645 \u0645\u0637\u0644\u0648\u0628 \u0648\u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631 6 \u0623\u062D\u0631\u0641 \u0639\u0644\u0649 \u0627\u0644\u0623\u0642\u0644" }, 400);
        const uname = username.trim().toLowerCase();
        const exists = await env.DB.prepare("SELECT id FROM accounts WHERE username = ?").bind(uname).first();
        if (exists) return json({ error: "\u0627\u0633\u0645 \u0627\u0644\u0645\u0633\u062A\u062E\u062F\u0645 \u0645\u0633\u062A\u062E\u062F\u0645 \u0645\u0633\u0628\u0642\u0627\u064B" }, 409);
        const { hash, salt } = await hashPassword(password);
        const id = crypto.randomUUID();
        const now = (/* @__PURE__ */ new Date()).toISOString();
        await env.DB.prepare(
          "INSERT INTO accounts (id, username, password_hash, salt, full_name, role, halaqa_id, active, created_at, updated_at) VALUES (?,?,?,?,?,?,?,1,?,?)"
        ).bind(id, uname, hash, salt, fullName || "", "teacher", halaqaId || "", now, now).run();
        return json({ ok: true, user: { id, username: uname, fullName: fullName || "", role: "teacher", halaqaId: halaqaId || "", active: true } });
      }
      const mUpd = path.match(/^\/api\/accounts\/([\w-]+)$/);
      if (mUpd && request.method === "PUT") {
        const p = await requireAuth(request, env);
        if (!p) return json({ error: "\u063A\u064A\u0631 \u0645\u0635\u0631\u062D" }, 401);
        const targetId = mUpd[1];
        const body = await request.json();
        const target = await env.DB.prepare("SELECT * FROM accounts WHERE id = ?").bind(targetId).first();
        if (!target) return json({ error: "\u0627\u0644\u062D\u0633\u0627\u0628 \u063A\u064A\u0631 \u0645\u0648\u062C\u0648\u062F" }, 404);
        const isSupervisor = p.role === "supervisor";
        const isSelf = p.sub === targetId;
        if (!isSupervisor) return json({ error: "\u063A\u064A\u0631 \u0645\u0635\u0631\u062D \u2014 \u062A\u0639\u062F\u064A\u0644 \u0627\u0644\u062D\u0633\u0627\u0628\u0627\u062A \u0644\u0644\u0645\u0634\u0631\u0641 \u0641\u0642\u0637" }, 403);
        if (isSelf && (body.newUsername || body.newPassword)) {
          if (!body.currentPassword || !await verifyPassword(body.currentPassword, target.salt, target.password_hash))
            return json({ error: "\u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631 \u0627\u0644\u062D\u0627\u0644\u064A\u0629 \u063A\u064A\u0631 \u0635\u062D\u064A\u062D\u0629" }, 401);
        }
        const updates = [];
        const vals = [];
        if (body.newUsername) {
          const uname = body.newUsername.trim().toLowerCase();
          const dup = await env.DB.prepare("SELECT id FROM accounts WHERE username = ? AND id != ?").bind(uname, targetId).first();
          if (dup) return json({ error: "\u0627\u0633\u0645 \u0627\u0644\u0645\u0633\u062A\u062E\u062F\u0645 \u0645\u0633\u062A\u062E\u062F\u0645 \u0645\u0633\u0628\u0642\u0627\u064B" }, 409);
          updates.push("username = ?");
          vals.push(uname);
        }
        if (body.newPassword) {
          if (body.newPassword.length < 6) return json({ error: "\u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631 6 \u0623\u062D\u0631\u0641 \u0639\u0644\u0649 \u0627\u0644\u0623\u0642\u0644" }, 400);
          const { hash, salt } = await hashPassword(body.newPassword);
          updates.push("password_hash = ?", "salt = ?");
          vals.push(hash, salt);
        }
        if (body.fullName !== void 0) {
          updates.push("full_name = ?");
          vals.push(body.fullName);
        }
        if (body.halaqaId !== void 0) {
          updates.push("halaqa_id = ?");
          vals.push(body.halaqaId);
        }
        if (body.active !== void 0 && !isSelf) {
          updates.push("active = ?");
          vals.push(body.active ? 1 : 0);
        }
        if (!updates.length) return json({ error: "\u0644\u0627 \u062A\u0648\u062C\u062F \u062A\u063A\u064A\u064A\u0631\u0627\u062A" }, 400);
        updates.push("updated_at = ?");
        vals.push((/* @__PURE__ */ new Date()).toISOString());
        vals.push(targetId);
        await env.DB.prepare(`UPDATE accounts SET ${updates.join(", ")} WHERE id = ?`).bind(...vals).run();
        const updated = await env.DB.prepare("SELECT * FROM accounts WHERE id = ?").bind(targetId).first();
        return json({ ok: true, user: pub(updated) });
      }
      if (mUpd && request.method === "DELETE") {
        const p = await requireAuth(request, env, "supervisor");
        if (!p) return json({ error: "\u063A\u064A\u0631 \u0645\u0635\u0631\u062D \u2014 \u0647\u0630\u0647 \u0627\u0644\u0639\u0645\u0644\u064A\u0629 \u0644\u0644\u0645\u0634\u0631\u0641 \u0641\u0642\u0637" }, 403);
        if (p.sub === mUpd[1]) return json({ error: "\u0644\u0627 \u064A\u0645\u0643\u0646\u0643 \u062D\u0630\u0641 \u062D\u0633\u0627\u0628\u0643" }, 400);
        await env.DB.prepare("DELETE FROM accounts WHERE id = ? AND role = ?").bind(mUpd[1], "teacher").run();
        return json({ ok: true });
      }
      if (path === "/api/data" && request.method === "GET") {
        const p = await requireAuth(request, env);
        if (!p) return json({ error: "\u063A\u064A\u0631 \u0645\u0635\u0631\u062D" }, 401);
        const row = await env.DB.prepare("SELECT data, updated_at, updated_by FROM data_snapshot WHERE id = 1").first();
        if (!row) return json({ data: null, updatedAt: null });
        return json({ data: await decompressSnapshot(row.data), updatedAt: row.updated_at, updatedBy: row.updated_by });
      }
      if (path === "/api/data" && request.method === "PUT") {
        const p = await requireAuth(request, env);
        if (!p) return json({ error: "\u063A\u064A\u0631 \u0645\u0635\u0631\u062D" }, 401);
        const body = await request.json();
        if (!body || typeof body.data !== "object")
          return json({ error: "\u0628\u064A\u0627\u0646\u0627\u062A \u063A\u064A\u0631 \u0635\u0627\u0644\u062D\u0629" }, 400);
        const now = (/* @__PURE__ */ new Date()).toISOString();
        await env.DB.prepare(
          `INSERT INTO data_snapshot (id, data, updated_at, updated_by) VALUES (1, ?, ?, ?)
           ON CONFLICT(id) DO UPDATE SET data = excluded.data, updated_at = excluded.updated_at, updated_by = excluded.updated_by`
        ).bind(await compressSnapshot(body.data), now, p.sub).run();
        return json({ ok: true, updatedAt: now });
      }
      return json({ error: "\u0627\u0644\u0645\u0633\u0627\u0631 \u063A\u064A\u0631 \u0645\u0648\u062C\u0648\u062F" }, 404);
    } catch (e) {
      return json({ error: "\u062E\u0637\u0623 \u0641\u064A \u0627\u0644\u062E\u0627\u062F\u0645: " + e.message }, 500);
    }
  }
};
export {
  index_default as default
};
//# sourceMappingURL=index.js.map
