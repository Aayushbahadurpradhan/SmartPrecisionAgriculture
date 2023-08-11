import 'dart:io';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_agri_project/main.dart';
import 'package:my_agri_project/services/firebase_services.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp(
      name: 'test',
      options: const FirebaseOptions(
        apiKey: 'test',
        appId: 'test',
        messagingSenderId: 'test',
        projectId: 'test',
      ),
    );

  testWidgets('Raindrop UI Test', (WidgetTester tester) async {
    await tester.pumpWidget( MyApp(home: "/rain",));
    await tester.pumpAndSettle();

    expect(find.text('Raindrop Sensor'), findsWidgets);
    expect(find.text('History'), findsOneWidget);

    await tester.tap(find.widgetWithText(Text, '30'));
    await tester.pump();
    expect(find.text('60'), findsOneWidget);
  });
}
