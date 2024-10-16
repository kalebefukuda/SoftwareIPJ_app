import 'package:flutter/material.dart';
import 'login.dart'; // Certifique-se de importar a tela de login


class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();

    // Delay de 1,6 segundos antes de navegar para a tela de login
    Future.delayed(const Duration(seconds: 1, milliseconds: 600), () {
      // Navegar para a tela de login com animação de dissolve
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600), // Duração da animação de transição
          pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(onThemeToggle: widget.onThemeToggle,
                  isDarkModeNotifier: widget.isDarkModeNotifier,),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animação de "dissolve" (fade)
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).appBarTheme.backgroundColor, // Usa a cor definida no AppBarTheme como fundo
        child: Center(
          child: Image.asset(
            "assets/images/Logo_IPB.png",
            height: 100,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
