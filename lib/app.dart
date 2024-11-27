import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwareipj/screens/start_screen.dart';

// Enum para os modos de tema
enum ThemeModeOptions {
  light,
  system,
  dark
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeModeOptions currentThemeMode = ThemeModeOptions.system;
  late ValueNotifier<ThemeModeOptions> themeModeNotifier;

  @override
  void initState() {
    super.initState();
    themeModeNotifier = ValueNotifier<ThemeModeOptions>(currentThemeMode);
    _loadThemePreference();
  }

  // Carregar a preferência do tema salva
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      int? modeIndex = prefs.getInt('themeMode');
      currentThemeMode = ThemeModeOptions.values[modeIndex ?? ThemeModeOptions.system.index];
      themeModeNotifier.value = currentThemeMode;
    });
  }

  // Salvar a preferência do tema
  Future<void> _saveThemePreference(ThemeModeOptions mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  // Alterar o modo de tema
  void _toggleTheme(ThemeModeOptions mode) {
    setState(() {
      currentThemeMode = mode;
      themeModeNotifier.value = mode;
      _saveThemePreference(mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Tema claro
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFFCF9F6),
        primaryColor: const Color(0xFF015B40),
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
          bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF015B40)),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF015B40)),
          titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF015B40)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF015B40),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFFE7E7E7),
          filled: true,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF015B40)),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF015B40),
          secondary: Color.fromARGB(255, 0, 145, 101),
          tertiary: Color.fromARGB(255, 109, 109, 109),
          onSecondary: Colors.black,          
          onTertiary: Color.fromARGB(255, 226, 177, 0),
        ),
      ),

      // Tema escuro
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        primaryColor: const Color.fromARGB(255, 0, 145, 101),
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 14, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
          bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
          titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFF1F1F1F),
          filled: true,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 45, 45, 45),
          secondary: Color(0xFF015B40),
          tertiary: Color.fromARGB(255, 186, 186, 186),
          onSecondary: Colors.white,
          onTertiary: Color.fromARGB(255, 75, 75, 75),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Definindo o modo de tema com base na escolha do usuário
      themeMode: currentThemeMode == ThemeModeOptions.light
          ? ThemeMode.light
          : currentThemeMode == ThemeModeOptions.dark
              ? ThemeMode.dark
              : ThemeMode.system,

      // Definindo a tela inicial
      home: StartScreen(
        onThemeToggle: _toggleTheme,
        themeModeNotifier: themeModeNotifier,
      ),
    );
  }
}
