import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RaindropSensorScreen extends StatefulWidget {
  @override
  _RaindropSensorScreenState createState() => _RaindropSensorScreenState();
}

class _RaindropSensorScreenState extends State<RaindropSensorScreen> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  List<String> historyData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raindrop Sensor'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(historyData[index]),
                );
              },
            ),
          ),
          TextButton(
            child: Text('Add History Data'),
            onPressed: () {
              // Call the method to add new history data
              _addHistoryData('New History Data');
            },
          ),
        ],
      ),
    );
  }
}


























