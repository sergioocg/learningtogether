import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String profilePic, name, lastname, location, bio, userName, email, memberSince, code;

  static FirebaseUser _user;
  static get user => _user;

  // A partir de Authenticate, me da el uid del usuario que hace login.
  // Más adelante me viene bien para descargar los datos de Database y Storage.
  static void init() async {
    _user = await FirebaseAuth.instance.currentUser();
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) {
      _user = firebaseUser;
    });    
  }

  User({
    this.uid,
    this.profilePic,
    this.name,
    this.lastname,
    this.location,
    this.bio,
    this.userName,
    this.email,
    this.memberSince,
    this.code,
  });
}