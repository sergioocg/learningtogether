import 'package:learningtogether/screens/home/button_tile.dart';
import 'package:learningtogether/screens/profile/profile.dart';
import 'package:learningtogether/screens/quiz/category/show/show_categories.dart';
import 'package:learningtogether/services/authmethods.dart';
import 'package:learningtogether/services/database.dart';
import 'package:flutter/material.dart';

import 'package:learningtogether/models/user.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthMethods _auth = AuthMethods();
  DatabaseService databaseService = new DatabaseService();
  String userCode = "";
  
  var profeItems = [
  PlaceInfo('Categorías', Color(0xff6DC8F3), Color(0xff73A1F9),
    'Añade nuevas categorías', 'assets/images/icons/categoria.png'),
  PlaceInfo('Tarjetas', Color(0xffFFB157), Color(0xffFFA057), 
    'Consulta las tarjetas disponibles', 'assets/images/icons/tarjeta.png'),
  PlaceInfo('Ver perfil', Color(0xffD76EF5), Color(0xff8F7AFE),
    'Consulta y edita la información de tu perfil', 'assets/images/icons/profile.png'),
  ];

  var aluItems = [
  PlaceInfo('Tarjetas', Color(0xffFFB157), Color(0xffFFA057), 
    'Consulta las tarjetas disponibles', 'assets/images/icons/tarjeta.png'),
  PlaceInfo('Ver perfil', Color(0xffD76EF5), Color(0xff8F7AFE),
    'Consulta y edita la información de tu perfil', 'assets/images/icons/profile.png'),
  ];
  
  getUserInfo() async {
    await User.init();
    final user = await databaseService.getUserByUid(User.user.uid);
    
    setState(() {
      userCode = user.data["code"];  
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {"/home" : (context) => Home(), "/profile":(context) => Profile(), "/category":(context) => ShowCategories()},
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/image.png"), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(3, 9, 23, 1),
            elevation: 0.0,        
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset("assets/images/icon.png", height: 45, fit: BoxFit.contain),
                SizedBox(width: 5),
                Text("Learning Together", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width / 19)),
              ],
            ),
            actions: <Widget>[
              FlatButton.icon(
                icon: Image.asset("assets/images/icons/off.png", height: 45, fit: BoxFit.contain),
                label: Text(""),
                onPressed: () async {await _auth.signOut();},
              ),
            ],
          ),
        body: userCode == "" ? Center(child: CircularProgressIndicator())
        : userCode == "PROFE20"
          ? ListView.builder(
            itemCount: profeItems.length,
            itemBuilder: (context, index) {
              return ButtonTile(profeItems, index, userCode);
            },
          )
          : ListView.builder(
              itemCount: aluItems.length,
              itemBuilder: (context, index) {
                return ButtonTile(aluItems, index, userCode);
              },
          ), 
        ),
      ),
    );
  }
}

class PlaceInfo {
  final String name;
  final String category;
  final Color startColor;
  final Color endColor;
  final String image;

  PlaceInfo(this.name, this.startColor, this.endColor, this.category, this.image);
}