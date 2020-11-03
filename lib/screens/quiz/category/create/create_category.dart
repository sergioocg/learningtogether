import 'package:learningtogether/screens/quiz/questions/add_question.dart';
import 'package:learningtogether/services/database.dart';
import 'package:learningtogether/shared/widget.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

// Pantalla para crear las Categorías de las preguntas.
class CreateCategory extends StatefulWidget {
  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  List<String> categories = new List(4);
  DatabaseService db = new DatabaseService();

  String categoryId = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void createCategory() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      categoryId = randomAlphaNumeric(16);
      categories[0] = categoryId;

      Map<String, String> categoryMap = {
        "categoryId" : categories[0],
        "categoryImgUrl" : categories[1],
        "categoryTitle" : categories[2],
        "categoryDesc" : categories[3]
      };
      
      await db.addCategory(categoryMap, categories[0]).then((value) {
        setState(() {
          _isLoading = false;
        });
        
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddQuestion(categories[0])));
        });
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
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
          ),
        ) : Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Form(
              key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Crear nueva categoría",
                      style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40.0),  
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[300]))
                            ),
                            child: TextFormField(
                              decoration: textDecoration("URL de la imagen").copyWith(prefixIcon: Icon(Icons.insert_link)),
                              validator: (val) => val.isEmpty ? "Introduce la URL de una imagen" : null,
                              keyboardType: TextInputType.url,
                              onChanged: (val) {
                                categories[1] = val;
                              }
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[300]))
                            ),
                            child: TextFormField(
                              decoration: textDecoration("Nombre de la categoría").copyWith(prefixIcon: Icon(Icons.category)),
                              validator: (val) => val.isEmpty ? "Introduce el nombre de la categoría" : null,
                              onChanged: (val) {
                                categories[2] = val;
                              }
                            ),
                          ),
                          Container(                
                          padding: EdgeInsets.only(top: 5),
                            child: TextFormField(
                              decoration: textDecoration("Breve descripción de la categoría").copyWith(prefixIcon: Icon(Icons.description)),
                              validator: (val) => val.isEmpty ? "Introduce una descripción para la categoría" : null,
                              onChanged: (val) {
                                categories[3] = val;
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: RaisedButton(
                            color: Colors.blue[800],
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text("Publicar categoría",
                                style: TextStyle(color: Colors.white.withOpacity(.7)),
                              ),
                            ),
                            onPressed: () async {
                              createCategory();
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
    );
  }
}