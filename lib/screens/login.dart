import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa o pacote flutter_svg
import 'package:softwareipj_app/screens/report.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'dart:ui'; // Necessário para o BackdropFilter

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
        MaterialPageRoute(builder: (context) => const Report()),
      );
    } else {
      // Exibe uma mensagem de erro
      errorMessage.value = "Usuário ou senha incorreto! Verifique suas informações e tente novamente.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o tema é escuro ou claro
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define a cor de fundo com opacidade apenas no modo escuro
    final Color backgroundWithOpacity = isDarkMode
        ? Colors.black.withOpacity(0.75) // Escurece no modo escuro
        : Colors.transparent; // Sem opacidade no modo claro (imagem original)

    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/Igreja_Fundo_Login.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Aplica desfoque e cor de fundo apenas no modo escuro
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Efeito fosco para ambos os temas
              child: Container(
                color: backgroundWithOpacity, // Aplica o fundo escuro com opacidade apenas no modo escuro
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
                color: Theme.of(context).primaryColor, // Acessa a cor definida no iconTheme

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
                            color: Theme.of(context).primaryColor,
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
                            color: Theme.of(context).primaryColor,
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
