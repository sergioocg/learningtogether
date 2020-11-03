import 'package:learningtogether/services/database.dart';
import 'package:flutter/material.dart';

import 'category_tile.dart';

// Builder que muestra todas las categorías subidas en Firestore.
class ShowCategories extends StatefulWidget {
  @override
  _ShowCategoriesState createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories> {
  Stream categoryStream;
  DatabaseService db = new DatabaseService();

  Widget categoryList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: StreamBuilder(
        stream: categoryStream,
        builder: (context, snapshot) {
          return snapshot.data == null ? Container() : 
            ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return CategoryTile(
                  imgUrl: snapshot.data.documents[index].data["categoryImgUrl"],
                  title: snapshot.data.documents[index].data["categoryTitle"],
                  desc: snapshot.data.documents[index].data["categoryDesc"],
                  categoryId: snapshot.data.documents[index].data["categoryId"],
                );
              });
        },
      ),
    );
  }
  
  @override
  void initState() {
    db.getCategories().then((val) {
      setState(() {
        categoryStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF53aeb6),      
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 9, 23, 1),
        elevation: 0.0,
      ),
      body: Center(
        child: categoryList(),
      ),
    );
  }
}
