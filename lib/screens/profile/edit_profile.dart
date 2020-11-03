import 'dart:async';
import 'dart:io';

import 'package:learningtogether/models/user.dart';
import 'package:learningtogether/services/database.dart';
import 'package:learningtogether/shared/widget.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Edita los datos del Perfil
// Si los datos no se editan, vuelve a coger los que ya estaban en Firestore para no machacarlos
class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DatabaseService db = new DatabaseService();
  String name, lastname, location, bio, code, filePath = "";
  File imageFile;
  bool imageSelected = false;
  var profilePic;
  User u;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  // Después de seleccionar la imagen, la sube al Storage y obtiene la URL para más adelante guardarlo en Firestore.
  uploadPhotoProfile() async {
    final FirebaseStorage _storage = FirebaseStorage(storageBucket: "gs://learning-together-34606.appspot.com");
    
    filePath = "images/profiles/${u.userName}.png";
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

  getUserInfo() async {
    final user = await db.getUserByUid(User.user.uid);
    
    setState(() {
      u = new User(
        profilePic: user.data["profilepic"],
        name: user.data["name"],
        lastname: user.data["lastname"],
        location: user.data["location"],
        bio: user.data["bio"],
        userName: user.data["username"],
        email: user.data["email"],
        memberSince: user.data["member"],
        code: user.data["code"]);     
    });
  }

  changeProfileData() async {
    if(name == null) name = u.name;
    if(lastname == null) lastname = u.lastname;
    if(location == null) location = u.location;
    if(bio == null) bio = u.bio;    
    if(code == null) code = u.code;

    String profilePicUrl = null;
    if(imageSelected) {
      profilePicUrl = await uploadPhotoProfile();
    }
    else {
      profilePicUrl = u.profilePic;
    }

    Map<String, String> userMap = {
      "profilepic" : profilePicUrl,
      "name" : name,
      "lastname" : lastname,
      "location" : location,
      "bio" : bio,
      "username" : u.userName, 
      "email" : u.email,
      "member" : u.memberSince,
      "code" : u.code,
    }; 
    db.updateProfile(userMap, User.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return u == null ? Center(child: CircularProgressIndicator())
    : Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF53aeb6), Color(0xFF428b91)])),
          ),     
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 10),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () { Navigator.pop(context); },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, right: 20),
                    child: IconButton(
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        changeProfileData(); 
                        EdgeAlert.show(context, description: 'Se han actualizado los datos del perfil.',
                          icon: Icons.check_circle,
                          backgroundColor: Colors.greenAccent,
                          duration: EdgeAlert.LENGTH_LONG,
                          gravity: EdgeAlert.TOP
                        );
                        Timer(Duration(seconds: 4), () {
                          Navigator.of(context)
                          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 90, right: 20, left: 20),
              height: MediaQuery.of(context).size.height - 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 25),
                      Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration( 
                          image: DecorationImage(
                            image: imageSelected ? FileImage(imageFile) : 
                            u.profilePic == "" ? AssetImage("assets/images/dummy.png") :
                            NetworkImage(u.profilePic),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: Colors.blueAccent.withOpacity(.2),
                          width: 5,
                      ),
                  ),
                ),
             SizedBox(height: 3),
                Center(child: Text("(opcional)", style: TextStyle(color: Colors.white))),   
                SizedBox(height: 13),
                Center(
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
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]), top: BorderSide(color: Colors.grey[300])),
                        ),
                        child: TextFormField(
                          decoration: textDecoration("Nombre").copyWith(prefixIcon: Icon(Icons.assignment_ind)),
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
                            setState(() => location = val); 
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                        ),
                        child: TextFormField(
                          decoration: textDecoration("Descripción").copyWith(prefixIcon: Icon(Icons.sort_by_alpha)),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 2,
                          onChanged: (val){
                            setState(() => bio = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
        ],
      ),
    );
  }
}