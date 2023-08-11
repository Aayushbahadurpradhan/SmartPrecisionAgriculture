import 'package:flutter/material.dart';
import 'package:my_agri_project/profile/profilescreen.dart';
import 'package:my_agri_project/sensors/humidity.dart';
import 'package:my_agri_project/sensors/light.dart';
import 'package:my_agri_project/sensors/motor.dart';
import 'package:my_agri_project/sensors/phSensor.dart';
import 'package:my_agri_project/sensors/raindrop.dart';
import 'package:my_agri_project/sensors/soilmoisture.dart';
import 'package:my_agri_project/sensors/ultrasonicSensor.dart';
import 'package:my_agri_project/sensors/undergroundTemp.dart';

class MyApp extends StatelessWidget {
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue), // Change the primarySwatch color to blue
    hintColor: Colors.greenAccent,
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple), // Change the primarySwatch color to blue
    hintColor: Colors.black12,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Agri Project',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _handleMenuOptionSelected(BuildContext context, String value) {
    switch (value) {
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 'Light Button':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LightPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MotorControlPage(),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuOptionSelected(context, value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Profile',
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'Light Button',
                child: ListTile(
                  leading: const Icon(Icons.lightbulb),
                  title: const Text('Light Button'),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Center(
                      child: Image.asset(
                        'images/banner.png',
                        height: 250,
                        width: 500,
                        scale: 0.8,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Smart Agriculture',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 38),
                    const Text(
                      'SENSOR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SoilMoistureScreen(),
                              ),
                            );
                          },
                          icon: 'images/soil_moisture.png',
                          title: 'SOIL MOISTURE',
                        ),
                        _CardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TemperatureAndHumidity(),
                              ),
                            );
                          },
                          icon: 'images/temphu.png',
                          title: 'TEMPERATURE',
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PHValueSensor(),
                              ),
                            );
                          },
                          icon: 'images/phvalue.png',
                          title: 'pHvalue',
                        ),
                        _CardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RaindropSensor(),
                              ),
                            );
                          },
                          icon: 'images/raindrop.png',
                          title: 'RAIN DROP',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WaterProofTemperatureSensor(),
                              ),
                            );
                          },
                          icon: 'images/undertemp.png',
                          title: 'Underground Temperature',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UltrasonicSensor(),
                              ),
                            );
                          },
                          icon: 'images/undertemp.png',
                          title: 'Underground Temperature',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardMenu extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback? onTap;
  final Color color;
  final Color fontColor;

  const _CardMenu({
    required this.title,
    required this.icon,
    this.onTap,
    this.color = Colors.white,
    this.fontColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 36,
        ),
        width: 156,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Image.asset(
              icon,
              width: 64,
              height: 64,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
            ),
          ],
        ),
      ),
    );
  }
}
