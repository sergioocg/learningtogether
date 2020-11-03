import 'package:learningtogether/services/database.dart';
import 'package:learningtogether/shared/widget.dart';
import 'package:flutter/material.dart';

// Pantalla para ir añadiendo cada una de las preguntas.
// Cada vez que se añade una pregunta, se llama "recursivamente"
class AddQuestion extends StatefulWidget {
  AddQuestion(this.categoryId);

  final String categoryId;

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  DatabaseService db = new DatabaseService();
  List<String> questions = new List(5);

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  createQuestion() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String,String> questionMap = {
        "question" : questions[0],
        "opt1" : questions[1],
        "opt2" : questions[2],
        "opt3" : questions[3],
        "opt4" : questions[4]
      };

      await db.addQuestion(questionMap, widget.categoryId).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),      
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
                    Text("Añadir preguntas",
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
                            decoration: textDecoration("Enunciado de la pregunta").copyWith(prefixIcon: Icon(Icons.short_text)),
                              validator: (val) => val.isEmpty ? "Introduce un enunciado" : null,
                              onChanged: (val) {
                                questions[0] = val;
                              }
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[300]))
                            ),
                            child: TextFormField(
                              decoration: textDecoration("Opción 1 (Respuesta correcta)").copyWith(prefixIcon: Icon(Icons.looks_one)),
                              validator: (val) => val.isEmpty ? "Introduce la opción 1 (respuesta correcta)" : null,
                              onChanged: (val) {
                                questions[1] = val;
                              }
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[300]))
                            ),
                            child: TextFormField(
                              decoration: textDecoration("Opción 2").copyWith(prefixIcon: Icon(Icons.looks_two)),
                              validator: (val) => val.isEmpty ? "Introduce la opción 2" : null,
                              onChanged: (val) {
                                questions[2] = val;
                              }
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[300]))
                            ),
                            child: TextFormField(
                              decoration: textDecoration("Opción 3").copyWith(prefixIcon: Icon(Icons.looks_3)),
                              validator: (val) => val.isEmpty ? "Introduce la opción 3" : null,
                              onChanged: (val) {
                                questions[3] = val;
                              }
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: TextFormField(
                              decoration: textDecoration("Opción 4").copyWith(prefixIcon: Icon(Icons.looks_4)),
                              validator: (val) => val.isEmpty ? "Introduce la opción 4" : null,
                              onChanged: (val) {
                                questions[4] = val;
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: RaisedButton(
                            color: Colors.green[800],
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text("Añadir otra pregunta",
                                style: TextStyle(color: Colors.white.withOpacity(.7)),
                              ),
                            ),
                            onPressed: () async {
                              createQuestion();
                            }
                          ),
                        ),
                      ),
                    ),    
                    SizedBox(height: 80),                
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: RaisedButton(
                            color: Colors.blue[800],
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text("Finalizar",
                                style: TextStyle(color: Colors.white.withOpacity(.7)),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            }
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
        ),
      ),
    );
  }
}