import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apptest/data/mock_data.dart';
import 'package:apptest/main.dart';
import 'package:apptest/widgets/category_chips.dart';

/// Phone sizes to check for layout overflow (logical pixels).
const _phones = {
  'small (iPhone SE)': Size(320, 568),
  'medium (Pixel 7)': Size(412, 915),
  'large (iPhone Pro Max)': Size(430, 932),
};

Future<void> _pumpApp(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

void main() {
  for (final entry in _phones.entries) {
    testWidgets('home, detail and profile render on ${entry.key}', (
      tester,
    ) async {
      await _pumpApp(tester, entry.value);

      expect(find.text('Find something soft'), findsOneWidget);
      final firstCard = find.text(kProducts.first.name);
      await tester.scrollUntilVisible(
        firstCard,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Open the first product (hero transition) and come back.
      await tester.tap(firstCard);
      await tester.pumpAndSettle();
      expect(find.text('Add to Cart'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Quantity'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      expect(find.text('Quantity'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_rounded).last);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Add to Cart'), findsNothing);

      // Switch to Profile.
      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pumpAndSettle();
      expect(find.text(MockUser.name), findsOneWidget);
      expect(find.text('My Orders'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Logout'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      expect(find.text('Logout'), findsOneWidget);
    });
  }

  testWidgets('category chips filter the product grid', (tester) async {
    await _pumpApp(tester, _phones['medium (Pixel 7)']!);

    await tester.tap(
      find.descendant(
        of: find.byType(CategoryChips),
        matching: find.text('Audio'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2 items'), findsOneWidget);
    expect(
      find.text('Cloud Runner Sneakers', skipOffstage: false),
      findsNothing,
    );
  });

  testWidgets('decorative nav items show a toast and keep the tab', (
    tester,
  ) async {
    await _pumpApp(tester, _phones['medium (Pixel 7)']!);

    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Explore is coming soon'), findsOneWidget);
    expect(find.text('Find something soft'), findsOneWidget);

    // Let the toast finish and remove itself.
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Explore is coming soon'), findsNothing);
  });

  testWidgets('home scroll position is kept when switching tabs', (
    tester,
  ) async {
    await _pumpApp(tester, _phones['medium (Pixel 7)']!);

    await tester.drag(find.text('Popular picks'), const Offset(0, -500));
    await tester.pumpAndSettle();
    final scrollable = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
    final offset = scrollable.position.pixels;
    expect(offset, greaterThan(0));

    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    expect(scrollable.position.pixels, offset);
  });
}
