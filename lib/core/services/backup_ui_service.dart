import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import 'backup_service.dart';

/// خدمات واجهة المستخدم للنسخ الاحتياطي:
/// تنزيل/مشاركة ملف النسخة، اختيار ملف للاستيراد، وفحص النسخ الآلي.
class BackupUiService {
  final BackupService service;
  BackupUiService(this.service);

  // ---------------- التصدير ----------------

  /// تصدير النسخة الاحتياطية وتسليمها للمستخدم (تنزيل على الويب / مشاركة على الجوال).
  /// تُعيد اسم الملف عند النجاح، وnull عند الإلغاء/الفشل.
  Future<String?> exportAndDeliver(
      {String? teacherId, DateTime? fromDate, DateTime? toDate}) async {
    final bytes = await service.exportBytes(
        teacherId: teacherId, fromDate: fromDate, toDate: toDate);
    final name = service.suggestedFileName(
        teacherId: teacherId, fromDate: fromDate, toDate: toDate);
    final ok = await _deliverBytes(name, Uint8List.fromList(bytes), 'application/gzip');
    if (ok) {
      // نسخ الفترة الجزئية لا تُحتسب نسخة كاملة للتذكير
      if (fromDate == null) await service.markBackupDone();
      return name;
    }
    return null;
  }

  /// تسليم بايتات أي ملف للمستخدم (تنزيل على الويب / مشاركة على الجوال).
  Future<bool> deliverPublic(String name, Uint8List bytes, String mime) =>
      _deliverBytes(name, bytes, mime);

  Future<bool> _deliverBytes(String name, Uint8List bytes, String mime) async {
    if (kIsWeb) {
      final blob = html.Blob([bytes], mime);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..download = name
        ..style.display = 'none';
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(url);
      return true;
    }
    final result = await Share.shareXFiles(
      [XFile.fromData(bytes, name: name, mimeType: mime)],
      subject: name,
    );
    return result.status == ShareResultStatus.success ||
        result.status == ShareResultStatus.dismissed; // dismissed يعني أن نظام المشاركة تعامل معه
  }

  // ---------------- الاستيراد ----------------

  /// فتح منتقي الملفات وإرجاع بايتات الملف المختار
  /// (ويب: عنصر إدخال المتصفح — جوال/سطح مكتب: file_picker).
  Future<Uint8List?> pickBackupFile() async {
    if (!kIsWeb) {
      final res = await FilePicker.platform.pickFiles(withData: true);
      return res?.files.firstOrNull?.bytes;
    }
    if (kIsWeb) {
      final input = html.FileUploadInputElement()
        ..accept = '.${BackupService.ext},.json,.gz,application/gzip,application/json';
      input.click();
      final completer = Completer<Uint8List?>();
      late StreamSubscription sub;
      sub = input.onChange.listen((_) async {
        final file = input.files?.firstOrNull;
        if (file == null) {
          if (!completer.isCompleted) completer.complete(null);
        } else {
          final reader = html.FileReader();
          reader.onLoadEnd.listen((_) {
            final res = reader.result;
            if (res is Uint8List) {
              if (!completer.isCompleted) completer.complete(res);
            } else if (res is ByteBuffer) {
              if (!completer.isCompleted) completer.complete(res.asUint8List());
            } else if (res is String) {
              if (!completer.isCompleted) completer.complete(utf8.encode(res));
            } else {
              if (!completer.isCompleted) completer.complete(null);
            }
          });
          reader.onError.listen((_) {
            if (!completer.isCompleted) completer.complete(null);
          });
          reader.readAsArrayBuffer(file);
        }
        await sub.cancel();
      });
      // مهلة أمان 5 دقائق
      return completer.future
          .timeout(const Duration(minutes: 5), onTimeout: () => null);
    }
    return null;
  }

  /// استيراد ملف نسخة احتياطية يختاره المستخدم.
  Future<ImportResult?> importFromPickedFile() async {
    final bytes = await pickBackupFile();
    if (bytes == null) return null;
    final res = await service.importBackup(bytes);
    if (res.ok) {
      await service.markBackupDone();
    }
    return res;
  }

  // ---------------- النسخ الآلي ----------------

  static const _kAutoCheckedDay = 'backup_auto_checked_day';

  /// يُستدعى عند بدء التطبيق/الشاشة الرئيسية:
  /// إذا كان النسخ الآلي مفعّلاً وحان الوقت، ينشئ نسخة تلقائياً.
  /// تُعيد وصف ما حدث لعرضه للمستخدم (أو null إن لم يحدث شيء).
  Future<String?> runAutoBackupIfDue({String? teacherId}) async {
    final settings = await service.loadSettings();
    if (!settings.autoBackup) return null;
    if (settings.reminder == BackupReminder.off) return null;
    if (!settings.isOverdue) return null;

    // امنع التكرار أكثر من مرة في اليوم
    final p = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (p.getString(_kAutoCheckedDay) == today) return null;
    await p.setString(_kAutoCheckedDay, today);

    try {
      final bytes = await service.exportBytes(teacherId: teacherId);
      await service.saveAutoBackupFile(bytes);
      await service.markBackupDone();
      return 'تم إنشاء نسخة احتياطية تلقائية بنجاح';
    } catch (e) {
      return 'تعذر إنشاء النسخة الاحتياطية التلقائية: $e';
    }
  }
}
