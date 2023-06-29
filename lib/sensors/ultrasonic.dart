import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UltrasonicSensor extends StatefulWidget {
  @override
  _UltrasonicSensorState createState() => _UltrasonicSensorState();
}

class _UltrasonicSensorState extends State<UltrasonicSensor>



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
