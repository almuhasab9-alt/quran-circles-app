# Worker API Deploy Report
Date: Tue Aug 25 07:40:25 UTC 2026

- **Worker URL**: 
- **Health**: curl: (3) URL rejected: No host part in the URL
failed

## Deploy output (run 1)
```

 ⛅️ wrangler 4.125.0
────────────────────

Cloudflare collects anonymous telemetry about your usage of Wrangler. Learn more at https://github.com/cloudflare/workers-sdk/tree/main/packages/wrangler/telemetry.md
[33m▲ [43;33m[[43;30mWARNING[43;33m][0m [1mYou need to register a workers.dev subdomain before publishing to workers.dev[0m


? Would you like to register a workers.dev subdomain now?
🤖 Using fallback value in non-interactive context: no

[31m✘ [41;31m[[41;97mERROR[41;31m][0m [1mYou can either deploy your worker to one or more routes by specifying them in your wrangler.jsonc file, or register a workers.dev subdomain here:[0m

  [4mhttps://dash.cloudflare.com/23f393728445f65d19a245d16cb4d4dd/workers/onboarding[0m


🪵  Logs were written to "/home/runner/.config/.wrangler/logs/wrangler-2026-08-25_07-40-18_540.log"
```

## Deploy output (run 2)
```

 ⛅️ wrangler 4.125.0
────────────────────
Total Upload: 27.93 KiB / gzip: 5.57 KiB
Your Worker has access to the following bindings:
Binding                        Resource         
env.DB (quran-circles-db)      D1 Database      

Uploaded quran-circles-api (0.91 sec)
No targets deployed for quran-circles-api (0.62 sec)

[31m✘ [41;31m[[41;97mERROR[41;31m][0m [1mTrigger configuration for "quran-circles-api" was only partially updated:[0m

  
    Routes:
      - A request to the Cloudflare API (/accounts/23f393728445f65d19a245d16cb4d4dd/workers/scripts/quran-circles-api/routes) failed.
        - Could not understand route pattern [], please try a different pattern [code: 10022]
  
  Successful trigger changes were not rolled back.


🪵  Logs were written to "/home/runner/.config/.wrangler/logs/wrangler-2026-08-25_07-40-21_616.log"
```
