/**
 * quran-center-bridge — القنطرة الموحدة (بروكسي شامل)
 * رابط واحد يمرر الموقع والـ API معاً:
 *   /*        → quran-center-app.pages.dev            (الموقع)
 *   /api/*    → quran-circles-api.almuhasab9-alt.workers.dev  (البيانات)
 *   /auth/*   → quran-auth-api.almuhasab9-alt.workers.dev     (المصادقة)
 *
 * التطبيق يستخدم مسارات نسبية، لذا يعمل هذا البروكسي على أي نطاق:
 * workers.dev — أو نطاق مخصص من Cloudflare — أو نسخة Netlify/Vercel.
 */
export default {
  async fetch(request) {
    const url = new URL(request.url);
    const path = url.pathname;

    // 1) تحديد الهدف حسب المسار
    let target;
    if (path.startsWith('/auth/')) {
      target = 'https://quran-auth-api.almuhasab9-alt.workers.dev' + path.slice('/auth'.length);
    } else if (path.startsWith('/api/')) {
      target = 'https://quran-circles-api.almuhasab9-alt.workers.dev' + path;
    } else {
      target = 'https://quran-center-app.pages.dev' + path;
    }
    target += url.search;

    // 2) تمرير الطلب كما هو (method + headers + body)
    const headers = new Headers(request.headers);
    headers.delete('host');
    headers.delete('cf-connecting-ip');
    headers.delete('cf-ray');
    headers.delete('cf-ipcountry');
    headers.delete('cf-worker');
    headers.delete('cf-visitor');
    headers.delete('cf-request-id');

    const init = {
      method: request.method,
      headers,
      redirect: 'follow',
    };
    if (request.method !== 'GET' && request.method !== 'HEAD') {
      init.body = await request.arrayBuffer();
    }

    // 3) إعادة الاستجابة كما هي
    const resp = await fetch(target, init);
    return new Response(resp.body, {
      status: resp.status,
      statusText: resp.statusText,
      headers: resp.headers,
    });
  },
};
