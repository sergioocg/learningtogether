import 'package:flutter/material.dart';

// Estilo de los cuadros de texto.
InputDecoration textDecoration(String hintText){
  return InputDecoration(
    border: InputBorder.none,
    labelText: hintText,
    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
  );
}