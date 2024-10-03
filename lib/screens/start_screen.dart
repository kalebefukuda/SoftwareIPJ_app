import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(  // Usando Stack para permitir o uso de Positioned
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Image.asset(
                "assets/images/Logo_IPB.png",
                height: 100,
                color: Theme.of(context).iconTheme.color // Aplicando a cor do tema
              ),
            ),
          ),
        ],
      ),
    );
  }
}
