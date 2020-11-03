import 'package:learningtogether/models/user.dart';
import 'package:learningtogether/screens/profile/profile_holder.dart';
import 'package:learningtogether/services/database.dart';
import 'package:flutter/material.dart';

import 'edit_profile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> { 
  DatabaseService databaseService = new DatabaseService();
  User u;

  // A partir del uid, obtenemos los datos del usuario que inicie sesión.
  getUserInfo() async {
    final user = await databaseService.getUserByUid(User.user.uid);
    
    setState(() {
      u = new User(
        profilePic: user.data["profilepic"],
        name: user.data["name"],
        lastname: user.data["lastname"],
        location: user.data["location"],
        bio: user.data["bio"],
        userName: user.data["username"],
        email: user.data["email"],
        memberSince: user.data["member"]);     
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: u == null ? Center(child: CircularProgressIndicator())
      : Stack(
        children: <Widget>[
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF53aeb6), Color(0xFF428b91)])),
          ),     
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 10),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () { 
                        Navigator.pop(context);
                        },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, right: 20),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: ProfileHolder(u),
          ),
        ],
      ),
    );
  }
}