import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class MotorControlPage extends StatefulWidget {
  @override
  _MotorControlPageState createState() => _MotorControlPageState();
}

class _MotorControlPageState extends State<MotorControlPage> {
  bool motor1Status = false;
  bool motor2Status = false;
  String motor1Name = 'Control';
  String motor2Name = 'Control';

  void setMotorValues(bool motor1Status, bool motor2Status) {
    final DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference();

    databaseReference.child('motor1').set(motor1Status);
    databaseReference.child('motor2').set(motor2Status);
  }

  void setMotorName(String motorName, String newName) {
    final DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference();

    databaseReference.child(motorName).set(newName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motor Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: motor1Status,
              onChanged: (value) {
                setState(() {
                  motor1Status = value;
                  setMotorValues(motor1Status, motor2Status);
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Change Motor 1 Name'),
                    content: TextField(
                      onChanged: (text) {
                        setState(() {
                          motor1Name = text;
                          setMotorName('motor1', motor1Name);
                        });
                      },
                      controller: TextEditingController(text: motor1Name),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Motor 1: $motor1Name'),
            ),
            Switch(
              value: motor2Status,
              onChanged: (value) {
                setState(() {
                  motor2Status = value;
                  setMotorValues(motor1Status, motor2Status);
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Change Motor 2 Name'),
                    content: TextField(
                      onChanged: (text) {
                        setState(() {
                          motor2Name = text;
                          setMotorName('motor2', motor2Name);
                        });
                      },
                      controller: TextEditingController(text: motor2Name),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Motor 2: $motor2Name'),
            ),
          ],
        ),
      ),
    );
  }
}
