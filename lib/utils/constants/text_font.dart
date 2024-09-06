import 'package:flutter/material.dart';

class TextFonts {
  TextFonts._(); 

  static const TextStyle poppinsRegular = TextStyle(
    fontFamily: 'Poppins', 
    fontWeight: FontWeight.normal, 
    fontSize: 16, 
    color: Colors.white,
  );

  static const TextStyle poppinsMedium = TextStyle(
    fontFamily: 'Poppins', 
    fontWeight: FontWeight.normal, 
    fontSize: 24, 
    color: Colors.white,
  );

  static const TextStyle poppinsBold = TextStyle(
    fontFamily: 'Poppins', 
    fontWeight: FontWeight.bold,
    fontSize: 18, 
    color: Colors.white,
  );

  // Você pode adicionar mais estilos de texto aqui
  static const TextStyle poppinsLight = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w300, // Peso light
    fontSize: 14,
    color: Colors.white,
  );
}
