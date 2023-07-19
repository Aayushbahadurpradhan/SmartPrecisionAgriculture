import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_agri_project/profile/profilescreen.dart';
import 'package:my_agri_project/register/signup.dart';
import 'package:my_agri_project/sensors/raindrop.dart';
import 'package:my_agri_project/sensors/soilmoisture.dart';
import 'package:my_agri_project/sensors/ultrasonicSensor.dart';
import 'package:my_agri_project/upload.dart';
import 'package:my_agri_project/viewmodel/auth_view_model.dart';
import 'package:my_agri_project/viewmodel/global_ui.dart';
import 'package:provider/provider.dart';

import 'Dashboard.dart';
import 'login/LoadingScreen.dart';
import 'login/Login.dart';
import 'login/forgotpass.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, this.home}) : super(key: key);
  String? home;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalUIViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Image.asset(
            "images/logo.png",
            height: 100,
            width: 100,
          ),
        ),
        child: Consumer<GlobalUIViewModel>(builder: (context, loader, child) {
          if (loader.isLoading) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
          return MaterialApp(
              title: 'Smart Agriculture',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primaryColor: Colors.black),
              initialRoute: home ?? "/home", // just change this
              routes: {
                "/LoadingScreen": (BuildContext context) => LoadingScreen(),
                "/forgotpassword": (BuildContext context) => ForgotScreen(),
                "/login": (BuildContext context) => LoginScreens(),
                "/register": (BuildContext context) => RegisterScreen(),
                "/prof": (BuildContext context) => ProfileScreen(),

                "/home": (BuildContext context) => HomePage(),
                "/up": (BuildContext context) => UploadAndViewImages(),
                "/soi": (BuildContext context) => SoilMoistureScreen(),
                "/rain": (BuildContext context) => RaindropSensor(),
                "/ultra": (BuildContext context) => UltrasonicSensor(),


              });
        }),
      ),
    );
  }
}
