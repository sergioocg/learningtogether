import 'dart:async';
import 'package:learningtogether/shared/wrapper.dart';
import 'package:flutter/material.dart';

// https://github.com/flutter-devs/flutter_splash_app
class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    return new Timer(new Duration(seconds: 2), navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  
  void navigationPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[new Image.asset('assets/images/splash_screen.png')],
      ),
    );
  }
}