// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_xray_diagnosis_app/main.dart';

void main() {
  testWidgets('AI X-ray app renders core UI', (WidgetTester tester) async {
    await tester.pumpWidget(const AiXrayApp());

    expect(find.text('AI X-ray Diagnosis'), findsOneWidget);
    expect(find.text('Upload X-ray'), findsOneWidget);
  });
}
