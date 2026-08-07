import 'package:intl/intl.dart';

String dateKeyOf(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

String formatDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

String formatDateAr(DateTime d) => DateFormat('yyyy/MM/dd', 'ar').format(d);

String formatDateTime(DateTime d) => DateFormat('yyyy-MM-dd HH:mm').format(d);
