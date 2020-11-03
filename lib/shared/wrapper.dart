import 'package:learningtogether/models/user.dart';
import 'package:learningtogether/screens/authentication/authenticate.dart';
import 'package:learningtogether/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

  // Devuelve una pantalla u otra, dependiendo del estado (Logeado o no) del usuario.
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    return user == null ? Authenticate() : Home();
  }
}