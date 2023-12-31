import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UltrasonicSensor extends StatefulWidget {
  @override
  _UltrasonicSensorState createState() => _UltrasonicSensorState();
}

class _UltrasonicSensorState extends State<UltrasonicSensor> {
  DatabaseReference? _databaseRef;
  FirebaseMessaging? _firebaseMessaging;
  double distance = 0.0;
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

    // Listen to distance changes
    _databaseRef!.child('distance').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          distance = double.parse(data.toString());
          sensorData.add({
            'timestamp': DateTime.now(),
            'distance': distance,
          });
        });
        checkWaterLevel();
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

  void checkWaterLevel() {
    if (distance < 30) {
      sendNotification('Water tank is full!');
    } else {
      sendNotification('Water tank is not full');
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
      'Water Tank Alert',
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
        title: Text('Water Tank Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Water Tank Level',
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
                  '${distance.toStringAsFixed(1)} cm',
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
            SizedBox(height: 10),
            Expanded(
              child: Card(
                elevation: 4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowHeight: 40,
                    dataRowHeight: 56,
                    horizontalMargin: 12,
                    headingTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    dataTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    columns: [
                      DataColumn(label: Text('Timestamp')),
                      DataColumn(label: Text('Distance')),
                    ],
                    rows: sensorData
                        .map(
                          (data) => DataRow(
                        cells: [
                          DataCell(
                            Text(data['timestamp'].toString()),
                          ),
                          DataCell(
                            Text(
                              '${data['distance'].toStringAsFixed(1)} cm',
                            ),
                          ),
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
