import 'dart:ui' as ui;
import 'package:learningtogether/screens/profile/profile.dart';
import 'package:learningtogether/screens/quiz/category/create/create_category.dart';
import 'package:learningtogether/screens/quiz/category/show/show_categories.dart';
import 'package:flutter/material.dart';

// https://github.com/afzalali15/Flutter-UI-Design
class ButtonTile extends StatelessWidget {
  final items;
  final int index;
  final String userCode;

  final double _borderRadius = 24;

  ButtonTile(this.items, this.index, this.userCode);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(userCode == "PROFE20") {
          switch(index.toString()) {
            case "0":
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCategory()));          
            break;

            case "1":
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowCategories()));          
            break;

            case "2":
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));          
            break;                              
          }
        }
        else {
          switch(index.toString()) {
            case "0":
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowCategories()));          
            break;

            case "1":
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));          
            break;
          }
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  gradient: LinearGradient(colors: [
                    items[index].startColor,
                    items[index].endColor
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(
                      color: items[index].endColor,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: CustomPaint(
                  size: Size(100, 150),
                  painter: CustomCardShapePainter(_borderRadius,
                      items[index].startColor, items[index].endColor),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.asset(
                        items[index].image,
                        height: 64,
                        width: 64,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            items[index].name,
                            style: TextStyle(
                                color: Colors.white,
                                // fontFamily: 'Avenir',
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                          SizedBox(height: 3),
                          Text(
                            items[index].category,
                            style: TextStyle(
                              color: Colors.white,
                              // fontFamily: 'Avenir',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Se encarga de pintar todos los items de selección de Home()
class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}