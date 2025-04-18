// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_service_container/flutter_service_container.dart';
import 'package:flutter_service_provider_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Flutter service test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ServicesRoot(
        printDebugLogs: true,
        child: const MyApp(),
      ),
    );

    expect(find.textContaining('Greetings, Singleton'), findsOneWidget);
    expect(find.textContaining('Greetings, Transient'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.textContaining('Greetings, Scope'), findsOneWidget);
    expect(find.textContaining('Greetings, Transient'), findsOneWidget);
    expect(find.textContaining('Greetings, Consumer'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.textContaining('Greetings, New Route'), findsOneWidget);
  });
}
