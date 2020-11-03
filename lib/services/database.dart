import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  
  DatabaseService({this.uid});

  // Variables y métodos relacionados con los usuarios.
  // Colección de usuarios que se almacena en Firestore
  final CollectionReference usersCollection = Firestore.instance.collection("users");

  // Crea el usuario en Firestore
  Future<void> addUser(Map userMap) async {
    await usersCollection.document(uid)
    .setData(userMap)
    .catchError((e) {
      print(e.toString());
    });
  }

  // Es símilar a la hora de subir el usuario a Firestore, lo único que se le da el uid para saber
  // donde tiene que escribir los datos
  Future<void> updateProfile(Map userMap, String uid) async {
    await usersCollection.document(uid)
    .setData(userMap)
    .catchError((e) {
      print(e.toString());
    });
  }

  // Obtiene de Firestore todos los documentos. Es útil para hacer un ListView.
  getUser() async {
    return usersCollection.snapshots();
  }

  // Devuelve un DocumentSnapshot a partir del UID del usuario para obtener los campos de datos.
  getUserByUid(String uid) async {
    return usersCollection.document(uid).get();
  }

  // Variables y métodos relacionados con las Tarjetas de preguntas.
  // Colección de preguntas que se almacena en Firestore
  final CollectionReference categoryCollection = Firestore.instance.collection("categories");

  // Sube las categorías a Firestore.
  Future<void> addCategory(Map categoryMap, String categoryId) async {
    await categoryCollection
    .document(categoryId)
    .setData(categoryMap)
    .catchError((e) {
      print(e.toString());
    });
  }

  // Sube las preguntas a Firestore dependiendo de la Categoría.
  Future<void> addQuestion(Map questionMap, String categoryId) async {
    await categoryCollection
    .document(categoryId)
    .collection("questions")
    .add(questionMap)
    .catchError((e){
      print(e.toString());
    });
  }

  // Descarga las categorías de Firestore
  getCategories() async {
    return categoryCollection.snapshots();
  }

  // Descarga las Preguntas dependiendo de la Categoría.
  getQuestions(String categoryId) async {
    return await categoryCollection.document(categoryId).collection("questions").getDocuments();
  }
}