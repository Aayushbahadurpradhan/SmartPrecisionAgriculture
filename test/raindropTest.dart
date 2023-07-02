import 'dart:io';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_agri_project/main.dart';
import 'package:my_agri_project/services/firebase_services.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

void main() {

  // Build our app and trigger a frame.
  await tester.pumpWidget( MyApp());

  // Verify that our counter starts at 0.
  expect(find.text('0'), findsOneWidget);
  expect(find.text('1'), findsNothing);

  // Tap the '+' icon and trigger a frame.
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  // Verify that our counter has incremented.
  expect(find.text('0'), findsNothing);
  expect(find.text('1'), findsOneWidget);
});
  testWidgets('Raindrop UI Test', (WidgetTester tester) async {
    await tester.pumpWidget( MyApp(home: "/jjjj",));
    await tester.pumpAndSettle();

    expect(find.text('Raindrop Sensor'), findsWidgets);
    expect(find.text('History'), findsOneWidget);

  });
}
