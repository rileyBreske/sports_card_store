import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sports_card_store/main.dart';

void main() {
  testWidgets('selecting an item updates the total', (tester) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const CardStoreApp());
    expect(find.text('Total: \$0.00'), findsOneWidget);

    await tester.tap(find.text('Baseball Pack'));
    await tester.pump();
    expect(find.text('Total: \$4.99'), findsOneWidget);
  });
}
