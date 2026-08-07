import 'package:flutter_test/flutter_test.dart';
import 'package:quran_center/main.dart';

void main() {
  testWidgets('App starts with login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const QuranCenterApp());
    expect(find.text('نظام إدارة حلقات القرآن الكريم'), findsOneWidget);
  });
}
