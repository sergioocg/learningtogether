import 'package:learningtogether/screens/quiz/play/play_quiz.dart';
import 'package:flutter/material.dart';

// Diseño para mostrar el contenido de las categorías.
class CategoryTile extends StatelessWidget { 
  final String imgUrl, title, desc, categoryId;

  CategoryTile({@required this.imgUrl, @required this.title, @required this.desc, @required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayQuiz(categoryId, title)));
      },
        child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 150,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imgUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Container(
                height: 100,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black26,
                ),                
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                      Text(title, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
                      SizedBox(height: 3),
                      Text(desc, style: TextStyle(color: Colors.white.withOpacity(.8), fontSize: 17, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}