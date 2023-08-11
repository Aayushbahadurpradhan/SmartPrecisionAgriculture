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
  void checkTemperatureLevel() {
    if (temperature < 0) {
      sendNotification('Temperature is so below freezing!');
    } else if (temperature < 10) {
      sendNotification('Temperature is so very cold.');
    } else if (temperature < 20) {
      sendNotification('Temperature is so cold.');
    } else if (temperature < 30) {
      sendNotification('Temperature is so moderate.');
    } else if (temperature < 40) {
      sendNotification('Temperature is so warm.');
    } else if (temperature >= 50) {
      sendNotification('Temperature is so hot!');
    }
  }

  Future<void> sendNotification(String message) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin?.show(
      0,
      'Temperature Alert',
      message,
      platformChannelSpecifics,
      payload: null,
    );
  }

  void showNotification(String? title, String? body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waterproof Temperature Sensor'),
      ),
      body: Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text(
      'Underground Temperature',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(height: 20),
    Container(
    width: 300,
    height: 150,
    decoration: BoxDecoration(
    color: Colors.lightBlue,
    borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
    child: Text(
    '${temperature.toStringAsFixed(1)}°C',
    style: TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    ),
    ),
    SizedBox(height: 20),
    Text(
    'History',
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    ),
    ),
