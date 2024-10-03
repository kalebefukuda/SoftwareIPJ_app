import 'package:flutter/material.dart';
import '/screens/create_members.dart';
import './screens/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins', // Define a Poppins como fonte padrão
        scaffoldBackgroundColor: const Color(0xFFFCF9F6), // Cor de fundo para o modo claro
        primaryColor: const Color(0xFF015B40), // Cor primária para o modo claro
        brightness: Brightness.light, // Define o brilho como claro
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black, // Texto preto quando preenchido no modo claro
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey, // Cor inicial (cinza) para os campos vazios
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF015B40), // Cor verde
          ),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF015B40), // Cor do AppBar no modo claro
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFFE7E7E7), // Cor de fundo dos campos no modo claro
          filled: true, // Garante que a cor de fundo seja aplicada
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins', // Define a Poppins como fonte padrão
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0), // Cor de fundo para o modo escuro
        primaryColor: const Color.fromARGB(255, 113, 75, 75), // Cor primária para o modo escuro
        brightness: Brightness.dark, // Define o brilho como escuro
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 14), // Texto branco quando preenchido no modo escuro
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14), // Texto cinza quando vazio no modo escuro
          titleMedium: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600), // Títulos no modo escuro
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0), // Cor do AppBar no modo escuro
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFF1F1F1F), // Cor de fundo dos campos no modo escuro
          filled: true, // Garante que a cor de fundo seja aplicada
        ),
      ),
      themeMode: ThemeMode.system, // Altere para ThemeMode.system para seguir o tema do sistema
      home: LoginScreen(),
    );
  }
}