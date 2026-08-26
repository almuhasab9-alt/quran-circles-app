#!/bin/bash
# سكريبت ما بعد البناء: ضغط حجم تطبيق الويب لأقصى درجة
# الاستخدام: flutter build web --release && ./compress_build.sh
set -e
cd "$(dirname "$0")/build/web"

# 1. استخدام CanvasKit من CDN بدلاً من حزمه محلياً (يوفّر ~26MB)
sed -i 's/"useLocalCanvasKit":true/"useLocalCanvasKit":false/' flutter_bootstrap.js
rm -rf canvaskit

# 2. ضغط صور السبلاش (lossy عالي الجودة)
if command -v pngquant &> /dev/null && [ -d splash/img ]; then
  cd splash/img
  for f in *.png; do
    pngquant --quality=80-95 --force --output "$f" -- "$f" 2>/dev/null || true
  done
  cd ../..
fi

echo "✓ Build compressed: $(du -sh . | cut -f1)"
