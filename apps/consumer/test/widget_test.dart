import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:letzdutch_consumer/app.dart';

void main() {
  testWidgets('opens on Discover with demo venues', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LetzdutchApp()));
    await tester.pumpAndSettle();

    expect(find.text('Saffron Terrace'), findsOneWidget);
    expect(find.text('Discover'), findsWidgets);
  });

  testWidgets('start a table, order, and see the split', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LetzdutchApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Saffron Terrace'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start a table'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Your table'));
    await tester.pumpAndSettle();

    expect(find.text('Split the bill'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Pay my share'), 200);
    expect(find.text('Pay my share'), findsOneWidget);
  });
}
