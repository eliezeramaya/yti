import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_yti_pro/main.dart';

void main() {
  testWidgets('App renders title and nav', (WidgetTester tester) async {
    tester.view.physicalSize = const ui.Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(const ProviderScope(child: YTIProApp()));
    expect(find.text('YT Insights Pro'), findsOneWidget);
  });
}
