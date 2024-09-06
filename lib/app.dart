import 'package:flutter/material.dart';
import '/screens/report.dart';
//import 'screens/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Report()
    );
  }
}