import 'package:learningtogether/screens/authentication/register.dart';
import 'package:learningtogether/shared/widget.dart';
import 'package:flutter/material.dart';
import 'package:learningtogether/services/authmethods.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:learningtogether/screens/authentication/reset_password.dart';

class Login extends StatefulWidget {
  Login({this.toggleView});

  final Function toggleView;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
	String emailStatus, errorMessage = "";
  bool showPass = true, _isHidden = true;
	String userEmail, userPass  = "";

	final AuthMethods _auth = AuthMethods();
	final _formKey = GlobalKey<FormState>();

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

	void signIn() async {
		if(_formKey.currentState.validate()) {
			dynamic result = await _auth.signInWithEmailAndPass(userEmail, userPass);

			if(result == null) {
				setState(() {
					errorMessage = "No se ha pedido iniciar sesión con esas credenciales.";
					EdgeAlert.show(context, description: errorMessage, icon: Icons.error_outline, backgroundColor: Colors.redAccent,
					duration: EdgeAlert.LENGTH_LONG, gravity: EdgeAlert.TOP);
				});
			}
		}	  
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 125, left: 30, right: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[                               
                  Image.asset("assets/images/icon.png", height: 325, width: 325), 
                  SizedBox(height: 30),
                  Container( // Campo de los datos
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]))
                          ),
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
                        Container(
                          child: TextFormField(
                            decoration:
                              textDecoration("Contraseña")
                              .copyWith(
                                prefixIcon: Icon(Icons.enhanced_encryption),
                                suffixIcon: showPass ? IconButton(
                                  onPressed: _toggleVisibility,
                                  icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                ) : null,
                              ),
                            keyboardType: TextInputType.visiblePassword,
                            validator: (val) => val.isEmpty ? 'El campo contraseña no puede estar vacío.' : null,
                            obscureText: showPass ? _isHidden : false,
                            onChanged: (val) {
                              setState(() => userPass = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
                    },
                    child: Container(
                      child: Text("¿Has olvidado la contraseña?", style: TextStyle(color: Colors.white)),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center( 
                    child: Container(
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: RaisedButton(
                          color: Colors.blue[800],
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text("Iniciar",
                              style: TextStyle(color: Colors.white.withOpacity(.7)),
                            ),
                          ),
                          onPressed: () async {
                            signIn();
                          }
                        ),
                      ),
                    ),
                  ),
            SizedBox( // Línea horizontal
              height: 75,
              width: MediaQuery.of(context).size.width / 1.2,
              child: Divider(
                thickness: 1,
                color: Colors.grey.withOpacity(.5),
              ),
            ), 
            Container(
              child: Text("¿Todavía no tienes una cuenta?", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 5),
            Center( 
              child: Container(
                width: MediaQuery.of(context).size.width / 3, // MediaQuery 170
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: RaisedButton(
                    color: Colors.green[800],
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text("Registrarse",
                        style: TextStyle(color: Colors.white.withOpacity(.7)),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));          
                    }
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
              ),
            ),
        ),
      ),
    );
  }
}