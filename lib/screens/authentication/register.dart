import 'dart:async';
import 'dart:io';
import 'package:learningtogether/services/authmethods.dart';
import 'package:learningtogether/shared/widget.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  Register({this.toggleView});

  final Function toggleView;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
	final AuthMethods _auth = AuthMethods();
	final _formKey = GlobalKey<FormState>();

	String name, lastname, location, bio, userName, userEmail, userPass, memberSince = "";
  String emailStatus, errorMessage, filePath, code = "";
  bool imageSelected = false;
  bool showPass = true, _isHidden = true;

  var profilePic;
  File imageFile;

  void changeEmailStatus(val) {
    if(val.isEmpty) {
      emailStatus = 'El campo email no puede estar vacío';
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

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }  

  // Métodos relacionados con la imagen de Perfil.
  // Sube la imagen del usuario a la Storage de Firebase utilizando el nombre de usuario.
  // Después obtiene la URL de la foto y la guarda en un String en la base de datos.
  uploadPhotoProfile() async {
    final FirebaseStorage _storage = FirebaseStorage(storageBucket: "gs://learning-together-34606.appspot.com");
    
    filePath = "images/profiles/$userName.png";
    final StorageUploadTask uploadTask = _storage.ref().child(filePath).putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void _openGallery(BuildContext context) async {
    profilePic = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = profilePic;
    });
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    profilePic = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = profilePic;
    });
    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Elige una foto de perfil", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Tus fotos"),
                onTap: () {
                  _openGallery(context);
                }
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              GestureDetector(
                child: Text("Tomar foto"),
                onTap: () {
                  _openCamera(context);
                }
              ),
            ],
          ),
        ),
      );
    });
  }

  void createUser() async {
    if(_formKey.currentState.validate()) {
      String profilePicUrl = "";
      
      if(imageFile != null) {
        profilePicUrl = await uploadPhotoProfile();
      }

      if(location == null) location = "Desconocida";
      if(bio == null) bio = "Sin descripción";

      var now = DateTime.now();
      memberSince = '${now.day}/${now.month}/${now.year}';

      Map<String, String> userMap = {
        "profilepic" : profilePicUrl,
        "name" : name,
        "lastname" : lastname,
        "location" : location,
        "bio" : bio,
        "username" : userName, 
        "email" : userEmail,
        "member" : memberSince,
        "code" : code,
      };

      dynamic result = await _auth.registerWithEmailAndPass(userEmail, userPass, userMap);
      if(result == null) {
        EdgeAlert.show(context, description: _auth.getStatusUser(), icon: Icons.error_outline, backgroundColor: Colors.redAccent, duration: EdgeAlert.LENGTH_LONG, gravity: EdgeAlert.TOP);                          
      }
      else {
        EdgeAlert.show(context, description: 'Se ha creado la cuenta con el email ' + userEmail, icon: Icons.check_circle, backgroundColor: Colors.greenAccent, duration: EdgeAlert.LENGTH_LONG, gravity: EdgeAlert.TOP);
        Timer(Duration(seconds: 4), () {
          Navigator.pop(context);
        });
      }
    }
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
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Dar de alta usuario",
                        style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold),
                      ),
                  SizedBox(height: 40.0),
                  Center(
                    child: Container( // Foto perfil
                      height: 170, 
                      width: 170,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageFile == null ? AssetImage("assets/images/dummy.png")
                          : FileImage(imageFile),
                        fit: BoxFit.cover
                      ),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white.withOpacity(.7),
                          width: 5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  Center(child: Text("(opcional)", style: TextStyle(color: Colors.white))),   
                  SizedBox(height: 13),
                  Center( // Botón para seleccionar imagen.
                    child: Container(
                      width: 170,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: RaisedButton(
                          color: Colors.blue[800],
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text("Cambiar avatar",
                              style: TextStyle(color: Colors.white.withOpacity(.7)),
                            ),
                          ),
                          onPressed: () async {
                            _showChoiceDialog(context);
                            imageSelected = true;
                          }
                        ),
                      ),
                    ),
                  ),  
                  SizedBox(height: 30.0),
                  Container( // Campo de los datos 1
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]))
                          ),
                          child: TextFormField(
                            decoration: textDecoration("Nombre").copyWith(prefixIcon: Icon(Icons.assignment_ind)),
                            validator: (val) => val.isEmpty ? 'El campo nombre no puede estar vacío.' : null,
                            onChanged: (val){
                              setState(() => name = val);
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]))
                          ),
                          child: TextFormField(
                            decoration: textDecoration("Apellidos").copyWith(prefixIcon: Icon(Icons.assignment_ind)),
                            validator: (val) => val.isEmpty ? 'El campo apellidos no puede estar vacío.' : null,
                            onChanged: (val){
                              setState(() => lastname = val);
                            },
                          ),
                        ),   
                        Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]))
                          ),                        
                          child: TextFormField(
                            decoration: textDecoration("Localidad").copyWith(prefixIcon: Icon(Icons.location_city)),
                            onChanged: (val){
                              setState(() {
                                location = val;
                              });
                            },
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: textDecoration("Breve descripción (opcional)").copyWith(prefixIcon: Icon(Icons.sort_by_alpha)),
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 2,
                            onChanged: (val){
                              setState(() {
                                bio = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container( // Campo de los datos 2
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]))
                          ),
                          child: TextFormField(
                            decoration: textDecoration("Nombre de usuario").copyWith(prefixIcon: Icon(Icons.alternate_email)),
                            validator: (val) => val.isEmpty  ? 'El campo nombre de usuario no puede estar vacío.' : null,
                            onChanged: (val){
                              setState(() => userName = val);
                            },
                          ),
                        ),
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
                            decoration: textDecoration("Contraseña")
                              .copyWith(
                                prefixIcon: Icon(Icons.enhanced_encryption),
                                suffixIcon: showPass ? IconButton(
                                  onPressed: _toggleVisibility,
                                  icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                ) : null,
                              ),                            keyboardType: TextInputType.visiblePassword,
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
                  SizedBox(height: 20),
                  Container( // Campo de los datos 3
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextFormField(
                            decoration: textDecoration("Código de registro").copyWith(prefixIcon: Icon(Icons.receipt)),
                            validator: (val) {
                              if(val.isEmpty) { 
                                return 'El campo código de registro no puede estar vacío.';
                              }
                              else {
                                if(!val.toString().contains("PROFE20") && !val.toString().contains("ALU20")){
                                  return 'Introduce un código válido.';
                                }
                                else {
                                  return null;
                                }
                              }
                            },
                            onChanged: (val) {
                              setState(() => code = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center( // Botón
                    child: Container(
                      width: 120,
                      child:ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: RaisedButton(
                          color: Colors.blue[800],
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text("Registrar",
                              style: TextStyle(color: Colors.white.withOpacity(.7)),
                            ),
                          ),
                          onPressed: () async {
                            createUser();
                          }
                         ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}