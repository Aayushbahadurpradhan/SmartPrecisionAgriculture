import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RaindropSensor extends StatefulWidget {
  @override
  _RaindropSensorState createState() => _RaindropSensorState();
}

class _RaindropSensorState extends State<RaindropSensor> {
  DatabaseReference? _databaseRef;
  FirebaseMessaging? _firebaseMessaging;
  double raindropValue = 0;
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

    // Listen to raindrop sensor changes
    _databaseRef!.child('raindrop').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          raindropValue = double.parse(data.toString()); // Convert value to double
          sensorData.add({
            'timestamp': DateTime.now(),
            'raindropValue': raindropValue,
          });
        });
        checkRaindropLevel();
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

  void checkRaindropLevel() {
    if (raindropValue >= 50 && raindropValue <= 100) {
      sendNotification("Light rainfall detected");
    } else if (raindropValue >= 20 && raindropValue < 50) {
      sendNotification("Moderate rainfall detected");
    } else if (raindropValue >= 0 && raindropValue < 20) {
      sendNotification("Heavy rainfall detected");
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
      'Raindrop Alert',
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
        title: Text('Raindrop Sensor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Raindrop Detection',
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
                  raindropValue > 0
                      ? 'Rainfall Level: ${raindropValue.toStringAsFixed(2)}'
                      : 'No Rainfall',
                  style: TextStyle(
                    fontSize: 24,
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
                      DataColumn(label: Text('Rainfall Level')),
                    ],
                    rows: sensorData
                        .map(
                          (data) => DataRow(
                        cells: [
                          DataCell(
                            Text(data['timestamp'].toString()),
                          ),
                          DataCell(
                            Text(data['raindropValue'].toStringAsFixed(2)),
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



















































