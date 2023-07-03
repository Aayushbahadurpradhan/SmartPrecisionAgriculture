import 'dart:io';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_agri_project/main.dart';
import 'package:my_agri_project/services/firebase_services.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
void main() {
  testWidgets('Ultrasonic UI Test', (WidgetTester tester) async {
    await tester.pumpWidget( MyApp(home: "/ultra",));
    await tester.pumpAndSettle();

    expect(find.text('Water Tank Level'), findsWidgets);
    expect(find.text('History'), findsOneWidget);

  });
}
