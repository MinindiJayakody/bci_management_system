import 'package:flutter_test/flutter_test.dart';

import 'package:bci_management_system/main.dart';

void main() {
  testWidgets('shows the landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BciApp());

    expect(find.text('BCI Management System'), findsOneWidget);
    expect(find.text('Student and course management made simple'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Enter the App'), findsOneWidget);
  });
}
