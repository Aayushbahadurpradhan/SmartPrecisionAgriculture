import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class MotorControlPage extends StatefulWidget {
  @override
  _MotorControlPageState createState() => _MotorControlPageState();
}

class _MotorControlPageState extends State<MotorControlPage> {

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
            
          ],
        ),
      ),
    );
  }
}
