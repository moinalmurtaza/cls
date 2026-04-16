import 'package:flutter_test/flutter_test.dart';
import 'package:cls/main.dart';

void main() {
  testWidgets('SmartAttendanceApp runs successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartAttendanceApp());
    expect(find.text('Smart Attendance'), findsWidgets);
  });
}
