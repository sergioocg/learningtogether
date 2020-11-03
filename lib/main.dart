import 'package:learningtogether/models/user.dart';
import 'package:learningtogether/screens/splash/splash_screen.dart';
import 'package:learningtogether/services/authmethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
          value: AuthMethods().user, 
          child: MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
      ),
    );
  }
}