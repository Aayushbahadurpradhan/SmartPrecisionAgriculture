import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WaterProofTemperatureSensor extends StatefulWidget {
  @override
  _WaterProofTemperatureSensorState createState() =>
      _WaterProofTemperatureSensorState();
}
class _WaterProofTemperatureSensorState
    extends State<WaterProofTemperatureSensor> {
  DatabaseReference? _databaseRef;
  FirebaseMessaging? _firebaseMessaging;
  double temperature = 0.0;
  List<Map<String, dynamic>> sensorData = [];

  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    initializeNotifications();
  }
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    _databaseRef = FirebaseDatabase.instance.reference().child('test');

    // Listen to temperature changes
    _databaseRef!.child('waterproof_temperature').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          temperature = double.parse(data.toString());
          sensorData.add({
            'timestamp': DateTime.now(),
            'temperature': temperature,
          });
        });
        checkTemperatureLevel();
      }
    });
  }
  void initializeNotifications() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
    AndroidInitializationSettings('launch_background');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    _flutterLocalNotificationsPlugin?.initialize(initializationSettings);

    // Initialize Firebase Cloud Messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      // Handle notification when the app is in the foreground
      showNotification(
        message.notification?.title,
        message.notification?.body,
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: $message');
      // Handle notification when the app is in the background or terminated
    });
    _firebaseMessaging?.getToken().then((token) {
      print('FCM Token: $token');
      // Save the token to your user's data for sending targeted notifications
    });
  }

