import 'package:learningtogether/screens/home/home.dart';
import 'package:flutter/material.dart';

// Pantalla que muestra los resultados obtenidos en las preguntas.
class Results extends StatefulWidget {
  final int correct, incorrect, total;
  Results({@required this.correct, @required this.incorrect, @required this.total});
  
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 90),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffe91e63),
              Color(0xff3f51b5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Image.asset("assets/images/celeb/celeb1.png", height: 75),
              Image.asset("assets/images/celeb/main_celeb.png"),
              SizedBox(height: 20), 
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Total de preguntas"),
                  trailing: Text("${widget.total}", style: TextStyle(fontSize: 28)),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Puntuación"),
                  trailing: Text("${widget.correct/widget.total* 100}%", style: TextStyle(fontSize: 28)),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Preguntas correctas"),
                  trailing: Text("${widget.correct}", style: TextStyle(fontSize: 28)),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Preguntas incorrectas"),
                  trailing: Text("${widget.incorrect}", style: TextStyle(fontSize: 28)),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Theme.of(context).accentColor.withOpacity(0.8),
                    child: Text("Finalizar"),
                    onPressed: () { 
                      Navigator.pushAndRemoveUntil(context,   
                        MaterialPageRoute(builder: (BuildContext context) => Home()),    
                        ModalRoute.withName('/home')); 
                    },
                  ),
                Image.asset("assets/images/celeb/celeb2.png", height: 75),
                ],
              )
            ],
          ),
        ),
      );

  }
}