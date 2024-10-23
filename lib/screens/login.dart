import 'package:SoftwareIPJ/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'dart:ui';

class LoginScreen extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<String> errorMessage = ValueNotifier<String>("");

  final void Function(bool value) onThemeToggle;
  final ValueNotifier<bool> isDarkModeNotifier;

  LoginScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkModeNotifier,
  });

  void login(BuildContext context) async {
    String usuario = loginController.text;
    String senha = passwordController.text;

    if (usuario == "" && senha == "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            onThemeToggle: onThemeToggle,
            isDarkModeNotifier: isDarkModeNotifier,
          ),
        ),
      );
    } else {
      errorMessage.value = "Usuário ou senha incorreto! Verifique suas informações e tente novamente.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundWithOpacity = isDarkTheme
        ? Colors.black.withOpacity(0.75)
        : Colors.transparent;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Igreja_Fundo_Login.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(color: backgroundWithOpacity),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/Logo_IPB.png',
                height: 100,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 150),
                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          controller: loginController,
                          hintText: 'Login',
                          obscureText: false,
                          icon: SvgPicture.asset(
                            'assets/images/user.svg',
                            height: 24,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          controller: passwordController,
                          hintText: 'Senha',
                          obscureText: true,
                          icon: SvgPicture.asset(
                            'assets/images/lock.svg',
                            height: 23,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        text: 'Entrar',
                        onPressed: () => login(context),
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                        valueListenable: errorMessage,
                        builder: (context, value, child) {
                          return Text(
                            textAlign: TextAlign.center,
                            value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
