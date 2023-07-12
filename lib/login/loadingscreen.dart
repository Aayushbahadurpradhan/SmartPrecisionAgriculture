import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'Login.dart';


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset('images/logo.png'),
          const SizedBox(height: 65),
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),

          const Text('Smart Agriculture', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),)
        ],
      ),
      backgroundColor: Colors.white,
      nextScreen: LoginScreens(),
      splashIconSize: 600,
      duration: 2000,
      splashTransition: SplashTransition.sizeTransition, //to change the animation.
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}