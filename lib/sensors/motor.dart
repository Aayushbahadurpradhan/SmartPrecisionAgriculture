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
