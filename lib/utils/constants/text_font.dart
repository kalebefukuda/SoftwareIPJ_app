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
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300, // Peso light
    fontSize: 14,
    color: Colors.white,
  );

  static const TextStyle poppinsGreenMedium = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600, // Peso mais forte que light
    fontSize: 18,
    color: Color(0xFF015B40), // Cor verde 015B40
  );
}
