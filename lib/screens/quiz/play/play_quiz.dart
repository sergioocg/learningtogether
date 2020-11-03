import 'package:learningtogether/models/question_model.dart';
import 'package:learningtogether/screens/quiz/play/results.dart';
import 'package:learningtogether/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'quiz_play_widgets.dart';

int total, _correct, _incorrect, _notAttempted = 0;

// Builder que muestra todas las preguntas de Firestore.
class PlayQuiz extends StatefulWidget {
  final String categoryId;
  final String title;
  PlayQuiz(this.categoryId, this.title);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService db = new DatabaseService();
  QuerySnapshot qs;

  // Descarga todas las preguntas de Firestore.
  QuestionModel getQuestionModelFromDatasnapshot(DocumentSnapshot qs){
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = qs.data["question"];

    List<String> options =
      [
        qs.data["opt1"],
        qs.data["opt2"],
        qs.data["opt3"],
        qs.data["opt4"]        
      ];

      options.shuffle(); // Mezcla las opciones

      questionModel.opt1 = options[0];
      questionModel.opt2 = options[1];
      questionModel.opt3 = options[2];
      questionModel.opt4 = options[3];
      questionModel.correctOption = qs.data["opt1"];
      questionModel.answered = false;

      return questionModel;
  }

  @override
  void initState() { 
    db.getQuestions(widget.categoryId).then((value) {
      qs = value;
      _notAttempted = qs.documents.length;
      _correct = 0;
      _incorrect = 0;
      total = qs.documents.length;

      setState(() {});
    });

    super.initState();
  }

  // https://medium.com/@iamatul_k/flutter-handle-back-button-in-a-flutter-application-override-back-arrow-button-in-app-bar-d17e0a3d41f
  Future<bool> _onBackPressed() {
    String text = "¿Estás seguro que quieres salir?\nSe perderá todo tu progreso.";

    return showDialog(
      context: context,
      builder: (context) =>
        new AlertDialog(
          content: Text(text),
          title: Text("¡Cuidado!"),
          actions: <Widget>[
            FlatButton(
              child: Text("Sí"),
              onPressed: (){
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: (){
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
    );
  }

  Future<void> _showCheckDialog(BuildContext context) {
    String text = "Aún te quedan preguntas por contestar.\n¿Estás seguro que quieres finalizar?";

    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        content: Text(text),
        title: Text("¡Cuidado!"),
        actions: <Widget>[
            FlatButton(
              child: Text("Sí"),
              onPressed: (){
                if(_notAttempted == total) {
                  _incorrect = total;
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Results(
                      correct: _correct,
                      incorrect: _incorrect,
                      total: total,
                    )
                  ));
                }              
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: (){
                Navigator.pop(context, false);
              },
            ),
        ],
      );
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xFF53aeb6),      
        appBar: AppBar(
          title: Text("${widget.title}"),
          backgroundColor: Color.fromRGBO(3, 9, 23, 1),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                qs == null ? 
                Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ):
                ListView.builder(
                  padding: EdgeInsets.all(25),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(), // Permite scroll
                  itemCount: qs.documents.length,
                  itemBuilder: (context, index) {
                    return QuizPlayTile(
                      questionModel: getQuestionModelFromDatasnapshot(qs.documents[index]),
                      index: index,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            if(_notAttempted > 0) {
              _showCheckDialog(context);
            }
            else {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Results(
                  correct: _correct,
                  incorrect: _incorrect,
                  total: total,
                )
              ));
            }
          },
        ),
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final int index;
  final QuestionModel questionModel;
  
  QuizPlayTile({this.questionModel, this.index});

  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(.3),
                  child: Text("${widget.index+1}", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400)),
                ),
          SizedBox(width: 10),
          Expanded(
            child: Text("${widget.questionModel.question}", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
            softWrap: true),
          ),
              ],
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                if(!widget.questionModel.answered) {
                  if(widget.questionModel.opt1 == widget.questionModel.correctOption) {
                    optionSelected = widget.questionModel.opt1;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    setState(() {});
                  }
                  else {
                    optionSelected = widget.questionModel.opt1;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    setState(() {});
                  }
                }
                _notAttempted = _notAttempted - 1;
              },
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.opt1,
                option: "A",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(height: 4,),
            GestureDetector(
              onTap: () {
                if(!widget.questionModel.answered) {
                  if(widget.questionModel.opt2 == widget.questionModel.correctOption) {
                    optionSelected = widget.questionModel.opt2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    setState(() {});
                  }
                  else {
                    optionSelected = widget.questionModel.opt2;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    setState(() {});
                  }
                }
                _notAttempted = _notAttempted - 1;
              },          
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.opt2,
                option: "B",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(height: 4,),
            GestureDetector(
              onTap: () {
                if(!widget.questionModel.answered) {
                  if(widget.questionModel.opt3 == widget.questionModel.correctOption) {
                    optionSelected = widget.questionModel.opt3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    setState(() {});
                  }
                  else {
                    optionSelected = widget.questionModel.opt3;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    setState(() {});
                  }
                }
                _notAttempted = _notAttempted - 1;
              },
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.opt3,
                option: "C",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(height: 4,),
            GestureDetector(
              onTap: () {
                if(!widget.questionModel.answered) {
                  if(widget.questionModel.opt4 == widget.questionModel.correctOption) {
                    optionSelected = widget.questionModel.opt4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    setState(() {});
                  }
                  else {
                    optionSelected = widget.questionModel.opt4;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    setState(() {});
                  }
                }
                _notAttempted = _notAttempted - 1;
              },          
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.opt4,
                option: "D",
                optionSelected: optionSelected,
              ),
            ),
          ],
      ),
    );
  }
}