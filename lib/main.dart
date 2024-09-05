import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Fontes do Google
import 'screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Software IPJ App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Scaffold(
        body: LoginScreen(), // Inclui a tela de login como o corpo do Scaffold
      ),
    );
  }
}
