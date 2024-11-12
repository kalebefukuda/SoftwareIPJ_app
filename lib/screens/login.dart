import 'package:SoftwareIPJ/app.dart';
import 'package:SoftwareIPJ/screens/home.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:ui';

class LoginScreen extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<String> errorMessage = ValueNotifier<String>("");

  final void Function(ThemeModeOptions) onThemeToggle;
  final ValueNotifier<ThemeModeOptions> themeModeNotifier;
  final ValueNotifier<bool> isTextFieldFocused = ValueNotifier<bool>(false); // Notifier para monitorar o foco dos campos

  LoginScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeModeNotifier,
  });

  void login(BuildContext context) {
    String usuario = loginController.text;
    String senha = passwordController.text;

    // Simulação de login bem-sucedido com credenciais vazias (personalize conforme necessário)
    if (usuario == "" && senha == "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            onThemeToggle: onThemeToggle,
            themeModeNotifier: themeModeNotifier,
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
    final Color backgroundWithOpacity = isDarkTheme ? Colors.black.withOpacity(0.75) : Colors.transparent;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Esconde o teclado ao tocar fora dos campos
        isTextFieldFocused.value = false; // Remove o foco ao tocar fora
      },
      child: Scaffold(
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
                  height: 80,
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
                            textInputAction: TextInputAction.next,
                            icon: PhosphorIcon(
                              Icons.person_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 30,
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
                            textInputAction: TextInputAction.done,
                            icon: PhosphorIcon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                              size: 30,
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
                                fontWeight: FontWeight.w500,
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
      ),
    );
  }
}