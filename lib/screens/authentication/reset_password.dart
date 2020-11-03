import 'dart:async';

import 'package:learningtogether/shared/widget.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:learningtogether/services/authmethods.dart';

// Pantalla para recuperar la contraseña.
// Envía un email al correo (para que llegue tiene que existir).
class ResetPassword extends StatefulWidget {
  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  final AuthMethods _auth = AuthMethods();

  String userEmail = "";
  String emailStatus = "";

  void changeEmailStatus(val) {
    if(val.isEmpty) {
      emailStatus = 'El campo email no puede estar vacío.';
    }
    else {
      if(!val.contains('@')) {
        emailStatus = 'El formato del email no es correcto.';
      }
      else {
        emailStatus = null;
      }
    }
  }

  void resetPassword() {
    _auth.resetPassword(userEmail);

    EdgeAlert.show(context,
      description: "Se ha enviado un email a " + userEmail + " para recuperar la contraseña.",
      icon: Icons.check_circle,
      backgroundColor: Colors.greenAccent,
      duration: EdgeAlert.LENGTH_LONG,
      gravity: EdgeAlert.TOP);

    Timer(Duration(seconds: 4), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 9, 23, 1),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),      
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                  Text("Recuperar contraseña",
                    style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),                  
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextFormField(
                            decoration: textDecoration("Email").copyWith(prefixIcon: Icon(Icons.email)),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                            changeEmailStatus(val);
                            return emailStatus;
                            },
                            onChanged: (val){
                              setState(() => userEmail = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 120,
                      child:ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: RaisedButton(
                          color: Colors.blue[800],
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text("Enviar",
                              style: TextStyle(color: Colors.white.withOpacity(.7)),
                            ),
                          ),
                          onPressed: () async {
                            resetPassword();
                          }
                        ),
                      ),
                    ),
                  ),
                ],
          ),
        ),
      ),
    );
  }
}