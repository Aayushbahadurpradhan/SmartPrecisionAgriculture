import 'package:flutter/material.dart';
class PHValueSensor extends StatefulWidget {
  @override
  _PHValueSensorState createState() => _PHValueSensorState();
}

class _PHValueSensorState extends State<PHValueSensor> {

  double pH = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pH Value Sensor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current pH Value',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
        SizedBox(height: 10),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: pH < 7
                ? Colors.redAccent
                : (pH > 7 ? Colors.blueAccent : Colors.greenAccent),
            borderRadius: BorderRadius.circular(75),
          ),
          child: Center(
            child: Text(
              '${pH.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        saasc
          sacas
          c
          as
          csac
          sa
          c
          sa
          c
          sa
          c
          sac
          as

          cas
          c
          sac
          s
          c
          as
          c
          as
          c
          as
          c
          ascsa
          c
          asc
          a
          sc
          sac
          sac
          sac
          sa
      ),
    );
  }



  
}


