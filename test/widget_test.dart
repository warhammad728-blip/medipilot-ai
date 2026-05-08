import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medipilot_ai/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MediPilotApp()),
    );
    expect(find.text('MediPilot AI — Ready!'), findsOneWidget);
  });
}
