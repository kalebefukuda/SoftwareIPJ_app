import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa o pacote flutter_svg
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'dart:ui'; // Necessário para o BackdropFilter

class LoginScreen extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<String> errorMessage = ValueNotifier<String>("");

  LoginScreen({super.key});

  void login(BuildContext context) async {
    String usuario = loginController.text;
    String senha = passwordController.text;

    if (usuario == "ipj" && senha == "ipj") {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      errorMessage.value =
          "Usuário ou senha incorreto! Verifique suas informações e tente novamente.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagem de fundo com efeito fosco
        Positioned.fill(
          child: Image.asset(
            'assets/Igreja_Fundo_Login.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Efeito fosco
            child: Container(
              color: Colors.white.withOpacity(0.2), // Leve camada de opacidade
            ),
          ),
        ),
        // Logo da empresa
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              'assets/Logo_IPB.png',
              height: 100,
            ),
          ),
        ),
        // Formulário de login
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150), // Espaço entre a logo e os campos
                    // Campo de Login com largura ajustada
                    SizedBox(
                      width: 300, // Ajuste a largura do campo de texto aqui
                      child: CustomTextField(
                        controller: loginController,
                        hintText: 'Login',
                        obscureText: false,
                        icon: SvgPicture.asset( // Usando o ícone SVG
                          'assets/user-round.svg',
                          height: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo de Senha com largura ajustada
                    SizedBox(
                      width: 300, // Ajuste a largura do campo de texto aqui
                      child: CustomTextField(
                        controller: passwordController,
                        hintText: 'Senha',
                        obscureText: true,
                        icon: SvgPicture.asset( // Usando o ícone SVG
                          'assets/lock.svg',
                          height: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40), // Espaço antes do botão de login
                    CustomButton(
                      text: 'Entrar',
                      onPressed: () => login(context),
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder(
                      valueListenable: errorMessage,
                      builder: (context, value, child) {
                        return Text(
                          textAlign: TextAlign.center, // Centraliza o texto horizontalmente
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
    );
  }
}
