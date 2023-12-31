import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TemperatureAndHumidity extends StatefulWidget {
  @override
  _TemperatureAndHumidityState createState() => _TemperatureAndHumidityState();
}

class _TemperatureAndHumidityState extends State<TemperatureAndHumidity> {
  late DatabaseReference _databaseRef;
  late FirebaseMessaging _firebaseMessaging;
  double temperature = 0.0;
  double humidity = 0.0;
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

    _databaseRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        setState(() {
          temperature = double.parse(data['temperature'].toString());
          humidity = double.parse(data['humidity'].toString());
          sensorData.add({
            'temperature': temperature,
            'humidity': humidity,
            'timestamp': DateTime.now(),
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
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin?.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      showNotification(
        message.notification?.title,
        message.notification?.body,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: $message');
    });

    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });
  }

  void checkTemperatureLevel() {
    if (temperature < 20.0) {
      sendNotification('Temperature is too low!');
    } else if (temperature > 30.0) {
      sendNotification('Temperature is too high!');
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
        title: Text('TEMPERATURE AND HUMIDITY DATA'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Temperature',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.lightBlue, Colors.blue],
                  ),
                ),
                child: Center(
                  child: Text(
                    '${temperature.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Humidity',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.lightGreen, Colors.green],
                  ),
                ),
                child: Center(
                  child: Text(
                    '${humidity.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'History',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Card(
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
                      DataColumn(
                        label: Text('Temperature'),
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text('Humidity'),
                        numeric: true,
                      ),
                      DataColumn(label: Text('Time')),
                    ],
                    rows: sensorData
                        .map(
                          (data) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              data['temperature'].toStringAsFixed(1),
                            ),
                          ),
                          DataCell(
                            Text(
                              data['humidity'].toStringAsFixed(1),
                            ),
                          ),
                          DataCell(
                            Text(
                              data['timestamp'].toString(),
                            ),
                          ),
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
