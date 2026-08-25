# Worker API Deploy Report
Date: Tue Aug 25 07:42:22 UTC 2026

- **Worker URL**: https://quran-circles-api.almuhasab9-alt.workers.dev
- **Health**: curl: (35) OpenSSL/3.0.13: error:0A000410:SSL routines::sslv3 alert handshake failure
failed
- **Users**: ?
- **Halaqas**: ?
- **Students**: ?
- **Daily records**: ?

## Deploy output
```

 ⛅️ wrangler 4.125.0
────────────────────

Cloudflare collects anonymous telemetry about your usage of Wrangler. Learn more at https://github.com/cloudflare/workers-sdk/tree/main/packages/wrangler/telemetry.md
Total Upload: 27.93 KiB / gzip: 5.57 KiB
Your Worker has access to the following bindings:
Binding                        Resource         
env.DB (quran-circles-db)      D1 Database      

Uploaded quran-circles-api (2.55 sec)
[33m▲ [43;33m[[43;30mWARNING[43;33m][0m [1mBecause 'workers_dev' is not in your Wrangler file, it will be enabled for this deployment by default.[0m

  To override this setting, you can disable workers.dev by explicitly setting 'workers_dev = false' in your Wrangler file.


[33m▲ [43;33m[[43;30mWARNING[43;33m][0m [1mBecause your 'workers.dev' route is enabled and your 'preview_urls' setting is not in your Wrangler file, Preview URLs will be enabled for this deployment by default.[0m

  To override this setting, you can disable Preview URLs by explicitly setting 'preview_urls = false' in your Wrangler file.


Deployed quran-circles-api triggers (0.77 sec)
  https://quran-circles-api.almuhasab9-alt.workers.dev
Current Version ID: 559ec9d7-55e6-4529-8a39-20c8665add40
```
