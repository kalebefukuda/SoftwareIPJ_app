import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwareipj_app/screens/home.dart';
import 'package:softwareipj_app/screens/login.dart';
import 'package:softwareipj_app/screens/start_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool isDarkMode = false;
  late ValueNotifier<bool> isDarkModeNotifier;

  @override
  void initState() {
    super.initState();
    isDarkModeNotifier = ValueNotifier<bool>(isDarkMode);
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      isDarkModeNotifier.value = isDarkMode;
    });
  }

  Future<void> _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
      isDarkModeNotifier.value = value;
      _saveThemePreference(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFFCF9F6),
        primaryColor: const Color(0xFF015B40),
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF015B40)),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 255, 255, 255)),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF015B40)),
        inputDecorationTheme: const InputDecorationTheme(fillColor: Color(0xFFE7E7E7), filled: true),
        iconTheme: const IconThemeData(color: Color(0xFF015B40)),
        colorScheme: const ColorScheme.light(primary: Color(0xFF015B40), secondary: Color.fromARGB(255, 0, 145, 101)),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        primaryColor: const Color.fromARGB(255, 0, 145, 101),
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 14, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 255, 255, 255)),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1F1F1F)),
        inputDecorationTheme: const InputDecorationTheme(fillColor: Color(0xFF1F1F1F), filled: true),
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 45, 45, 45), 
          secondary: Color(0xFF015B40)
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: StartScreen(onThemeToggle: _toggleTheme, isDarkModeNotifier: isDarkModeNotifier),
      // home: LoginScreen(
      //   onThemeToggle: _toggleTheme,
      //   isDarkModeNotifier: isDarkModeNotifier,
      // ),
    );
  }
}
