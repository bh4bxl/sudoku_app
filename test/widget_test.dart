// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sudoku_app/main.dart';

void main() {
  testWidgets('Main page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SudokuApp());

    // Verify that our counter starts at 0.
    expect(find.text('Sudoku'), findsOneWidget);
    expect(find.text('Error'), findsNothing);

    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
    expect(find.text('Expert'), findsOneWidget);

    final easyBut = find.byKey(Key('Easy'));
    expect(easyBut, findsOneWidget);
    await tester.tap(easyBut);
    await tester.pumpAndSettle();

    expect(find.text('Sudoku - Easy'), findsOneWidget);
    expect(find.textContaining('Errors:'), findsOneWidget);
    expect(find.textContaining('Time:'), findsOneWidget);
    expect(find.text('Medium'), findsNothing);
    expect(find.text('Hard'), findsNothing);
  });
}
