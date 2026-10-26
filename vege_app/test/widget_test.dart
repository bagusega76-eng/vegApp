import 'package:flutter_test/flutter_test.dart';
import 'package:vege_app/main.dart';

void main() {
  testWidgets('VegBox App initial load test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VegBoxApp());

    // Verify that the brand name VegBox is present
    expect(find.text('VegBox'), findsOneWidget);
  });
}
