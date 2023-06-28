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

          ],
        ),
      ),
    );
  }
}
























































































































