import 'package:learningtogether/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learningtogether/models/user.dart';

class AuthMethods {
	final FirebaseAuth _auth = FirebaseAuth.instance;
	String statusReset, _statusUser = "";

	void setStatusUser(String e) {
		if(e.contains('ERROR_EMAIL_ALREADY_IN_USE')) _statusUser = "La dirección de email ya está en uso.";
		else _statusUser = 'Datos erróneos.';
	}

	String getStatusUser() {return _statusUser;}

	void setStatusReset(String e) {
		if(e.contains('ERROR_INVALID_EMAIL')) statusReset = "El formato de email es incorrecto.";
		else if(e.contains('ERROR_USER_NOT_FOUND')) statusReset = 'El email no se ha encontrado.';
    else statusReset = "Se ha enviado un email a la dirección indicada para recuperar la contraseña.";
	}

	String getStatusReset() {return statusReset;}

  // Stream
  // Cada vez que un usuario inicia o cierra sesión, vamos a recibir un stream con el estado
  Stream<User> get user {
	  return _auth.onAuthStateChanged.map(_createUserFromFirebase);
  }

	// Métodos relacionados con Firebase
  // Crea un objeto User a partir de Firebase.
	User _createUserFromFirebase(FirebaseUser user) {
		return user != null ? User(uid: user.uid) : null;
	}

	// Inicia sesión con email y contraseña.
  // Además, obtenemos el uid de los usuario.
	Future signInWithEmailAndPass(String email, String pass) async {
		try {
			AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
			FirebaseUser firebaseUser = result.user;

			return _createUserFromFirebase(firebaseUser);
		} catch(e) {
			print(e.toString());
		}
	}

	// Registra el usuario utilizando el email y contraseña.
	// También guarda el usuario en Firestore con el uid para identificarlo.
	Future registerWithEmailAndPass(String email, String pass, Map userMap) async {
		try {
		  AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
		  FirebaseUser firebaseUser = result.user;
    
		  await DatabaseService(uid: firebaseUser.uid).addUser(userMap);

		  return _createUserFromFirebase(firebaseUser);
		}catch(e) {
		  setStatusUser(e.toString());
		  print(e.toString());
		}
  }

	// Le envía al usuario un correo para resetear la contraseña.
	// * Hay que activarlo en Firebase.
	Future resetPassword(String email) async {
		try {
			return await _auth.sendPasswordResetEmail(email: email);

		}catch(e) {
      setStatusReset(e.toString());
			print(e.toString());
		}
	}

	// Cierra la sesión del usuario.
	Future signOut() async {
		try {
			return await _auth.signOut();

		}catch(e) {
			print(e.toString());
		}
	}
}
