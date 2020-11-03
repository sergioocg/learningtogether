import 'package:learningtogether/models/user.dart';
import 'package:flutter/material.dart';

// "Monta" toda la información de los usuarios.
class ProfileHolder extends StatelessWidget {
  final User u;

  ProfileHolder(this.u);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 90, right: 20, left: 20), // Separación entre la cabecera y la caja principal
      height: MediaQuery.of(context).size.height - 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 25), // Espacio superior entre la foto y la caja principal
            Container(
              height: 170, // Foto perfil
              width: 170,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: u.profilePic == "" ? AssetImage("assets/images/dummy.png")
                    : NetworkImage(u.profilePic),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: Colors.blueAccent.withOpacity(.2),
                      width: 5,
                  ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              u.name + " " + u.lastname,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            SizedBox(height: 7),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                SizedBox(width: 8),              
                Text(
                  u.email,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            Container( // Comienza el cuadro con la información
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(25),
              width: 320,
              height: 215,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 30,
                        spreadRadius: 5
                      ),
                  ],
              borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Nombre de usuario',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          SizedBox(height: 3),
                          Text(
                            u.userName,
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Descripción',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "“" + u.bio + "”",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),    
            SizedBox( // Línea horizontal
              height: 80,
              width: MediaQuery.of(context).size.width / 1.2,
              child: Divider(
                thickness: 1,
                color: Colors.grey.withOpacity(.5),
              ),
            ),
            Row( // Contienen las 2 cajas de datos
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container( // Caja de localización
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.all(25),
                  width: MediaQuery.of(context).size.width / 2.4,
                  height: 160, // 160
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 30,
                        spreadRadius: 5
                      ),
                  ],
                  borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.redAccent,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            u.location,
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container( // Caja de miembro desde
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(25),
                  width: MediaQuery.of(context).size.width / 2.4,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 30,
                        spreadRadius: 5
                      ),
                  ],
                  borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.date_range,
                              color: Colors.lightBlue,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(height: 5),                          
                          Text(
                            u.memberSince,
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}