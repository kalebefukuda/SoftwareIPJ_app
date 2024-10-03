import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa o pacote flutter_svg
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'dart:ui'; // Necessário para o BackdropFilter
import 'home.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<String> errorMessage = ValueNotifier<String>("");

  LoginScreen({super.key});

  // Função de login, verifica as credenciais
  void login(BuildContext context) async {
    String usuario = loginController.text;
    String senha = passwordController.text;

    // Verificação de usuário e senha
    if (usuario == "ipj" && senha == "ipj") {
      // Navega para a tela Home usando o Navigator.push
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      // Exibe uma mensagem de erro
      errorMessage.value = "Usuário ou senha incorreto! Verifique suas informações e tente novamente.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pega a cor do fundo do tema e adiciona a opacidade
    final Color backgroundWithOpacity = Theme.of(context)
        .scaffoldBackgroundColor
        .withOpacity(0.7); // Define a opacidade de 80%

    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo com efeito fosco
          Positioned.fill(
            child: Image.asset(
              'assets/images/Igreja_Fundo_Login.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Efeito fosco
              child: Container(
                color: backgroundWithOpacity, // Aplica a cor com opacidade
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
                'assets/images/Logo_IPB.png',
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
                          icon: SvgPicture.asset(
                            'assets/images/user.svg',
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
                          icon: SvgPicture.asset(
                            'assets/images/lock.svg',
                            height: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40), // Espaço antes do botão de login
                      CustomButton(
                        text: 'Entrar',
                        onPressed: () => login(context), // Chama a função login no onPressed
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                        valueListenable: errorMessage,
                        builder: (context, value, child) {
                          return Text(
                            textAlign: TextAlign.center, // Centraliza o texto
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
