import 'package:flutter/material.dart';
import '/screens/create_members.dart';

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
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF015B40), // Cor verde
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF015B40), // Cor do AppBar no modo claro
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212), // Cor de fundo para o modo escuro
        primaryColor: const Color(0xFF121212), // Cor primária para o modo escuro
        brightness: Brightness.dark, // Define o brilho como escuro
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 14), // Texto branco quando preenchido no modo escuro
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14), // Texto cinza quando vazio no modo escuro
          titleLarge: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600), // Títulos no modo escuro
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F), // Cor do AppBar no modo escuro
        ),
      ),
      themeMode: ThemeMode.light, // Altere para ThemeMode.system para seguir o tema do sistema
      home: const CreateMembersScreen(),
    );
  }
}