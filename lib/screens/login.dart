import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CustomTextField(
              hintText: 'Nome de Usuário',
              obscureText: false,
            ),
            SizedBox(height: 16.0),
            CustomTextField(
              hintText: 'Senha',
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            CustomButton(
              text: 'Entrar',
              onPressed: () {
                // Adicione a lógica de login aqui
              },
            ),
          ],
        ),
      ),
    );
  }
}