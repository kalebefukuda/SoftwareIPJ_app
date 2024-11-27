import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para controlar a orientação
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Carrega o arquivo de ambiente
    await dotenv.load(fileName: ".env");

    // Configurações do Supabase
    final url = dotenv.env['SUPABASE_URL']!;
    final anonKey = dotenv.env['SUPABASE_ANON_KEY']!;
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );

    // Define a orientação para retrato apenas
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    debugPrint('$e');
  }

  runApp(const App());
}
