/**
 * quran-center-bridge — القنطرة الموحدة (بروكسي شامل)
 * رابط واحد يمرر الموقع والـ API معاً:
 *   /*        → quran-center-app.pages.dev                       (الموقع)
 *   /api/*    → quran-circles-api  (service binding داخلي)       (البيانات)
 *   /auth/*   → quran-auth-api     (service binding داخلي)       (المصادقة)
 *
 * خدمة الـ API تتم عبر bindings داخلية (لا تمر بالنطاق العام إطلاقاً)
 * لذا لا تظهر عناوين workers.dev للمتصفح — ميزة إضافية ضد الحجب.
 *
 * التطبيق يستخدم مسارات نسبية، لذا يعمل هذا البروكسي على أي نطاق:
 * workers.dev — أو نطاق مخصص من Cloudflare — أو نسخة Netlify/Vercel.
 */
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    // 1) توجيه الـ API إلى الخدمات المرتبطة (bindings داخلية)
    let svc = null;
    let targetPath = path;
    if (path.startsWith('/auth/')) {
      svc = env.AUTH_API;
      targetPath = path.slice('/auth'.length);
    } else if (path.startsWith('/api/')) {
      svc = env.CIRCLES_API;
    }

    const headers = new Headers(request.headers);
    headers.delete('host');
    ['cf-connecting-ip', 'cf-ray', 'cf-ipcountry', 'cf-worker', 'cf-visitor', 'cf-request-id', 'cf-connecting-ipv6', 'cdn-loop'].forEach((h) => headers.delete(h));

    const init = {
      method: request.method,
      headers,
      redirect: 'follow',
    };
    if (request.method !== 'GET' && request.method !== 'HEAD') {
      init.body = await request.arrayBuffer();
    }

    try {
      if (svc) {
        // fetch داخلي إلى الـ Worker المرتبط (لا يمر بالنطاق العام)
        const resp = await svc.fetch('https://internal' + targetPath + url.search, init);
        return new Response(resp.body, {
          status: resp.status,
          statusText: resp.statusText,
          headers: resp.headers,
        });
      }

      // 2) الموقع: مرر إلى pages.dev
      const target = 'https://quran-center-app.pages.dev' + path + url.search;
      const resp = await fetch(target, init);
      return new Response(resp.body, {
        status: resp.status,
        statusText: resp.statusText,
        headers: resp.headers,
      });
    } catch (err) {
      return new Response(JSON.stringify({ error: 'bridge: ' + err.message }), {
        status: 502,
        headers: { 'content-type': 'application/json' },
      });
    }
  },
};
