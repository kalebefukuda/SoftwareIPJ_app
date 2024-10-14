import 'package:flutter/material.dart';
// import 'package:softwareipj_app/screens/create_members.dart';
import 'package:softwareipj_app/screens/login.dart';
// import 'package:softwareipj_app/screens/report.dart';
// import 'package:softwareipj_app/screens/start_screen.dart';

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
            fontWeight: FontWeight.w500,
            color: Color(0xFF015B40), // Cor verde
          ),
          titleLarge: TextStyle(
            //Classe para os titulos de cabeçalhos
            fontSize: 24,
            fontWeight: FontWeight.w600,
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
        iconTheme: const IconThemeData(
          color: Color(0xFF015B40), // Cor para os ícones no modo claro
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF015B40), // Cor primária no modo claro
          secondary: Color.fromARGB(255, 0, 145, 101), // Cor secundária no modo claro
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins', // Define a Poppins como fonte padrão
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0), // Cor de fundo para o modo escuro
        primaryColor: const Color.fromARGB(255, 0, 145, 101), // Cor do rótulo quando o campo está focado
        brightness: Brightness.dark, // Define o brilho como escuro
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 14,
            color: Colors.white, // Texto branco quando preenchido no modo escuro
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.grey, // Texto cinza quando vazio no modo escuro
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Títulos no modo escuro
          ),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 255, 255, 255), // Títulos no modo escuro
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F), // Cor do AppBar no modo escuro
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFF1F1F1F), // Cor de fundo dos campos no modo escuro
          filled: true, // Garante que a cor de fundo seja aplicada
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Cor branca para o ícone (logo) no modo escuro
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 45, 45, 45), // Cor primária no modo escuro
          secondary: Color(0xFF015B40), // Cor secundária no modo escuro
        ),
      ),
      themeMode: ThemeMode.system, // Altere para ThemeMode.system para seguir o tema do sistema
      home: LoginScreen(),
    );
  }
}
