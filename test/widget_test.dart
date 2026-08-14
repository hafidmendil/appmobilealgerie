import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: NeuroSyncApp()));

    // Verify that the app builds by checking for the top-level ProviderScope/NeuroSyncApp
    expect(find.byType(NeuroSyncApp), findsOneWidget);
    
    // Clear pending timers from splash screen or animations
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
