// Import Dependencies
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'home.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      // app screen laoding time
      seconds: 2,
      navigateAfterSeconds: Home(),
      // text title on screen
      title: Text(
        'EuroSat Land Cover Classification',
        textAlign: TextAlign.center,
        // text style and color
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color(0xFFFFFFFF)),
      ),
      // image for screen
      //image: Image.asset('assets/background.jpeg'),
      imageBackground: AssetImage('assets/background.jpeg'),
      // image size on screen
      photoSize: 50,
      loaderColor: Color(0xFFEEDA28),
    );
  }
}
