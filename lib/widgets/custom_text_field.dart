import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.icon,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus(); // Remove o foco e esconde o teclado
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Aplica o radius diretamente no ClipRRect
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor, // Usa a cor de fundo do tema
          borderRadius: BorderRadius.circular(15), // Aplica o radius ao container
          border: Border.all(
            color: isFocused ? Theme.of(context).primaryColor : Colors.transparent, // Usa a cor primária do tema quando focado
            width: isFocused ? 2.0 : 1.0,
          ),
        ),
        child: GestureDetector(
          onTap: _unfocusKeyboard, // Quando o usuário toca fora do campo de texto
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: TextInputAction.done, // Exibe o botão "Done"
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            validator: widget.validator,
            decoration: InputDecoration(
              labelText: widget.hintText,
              floatingLabelStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor, // Usa a cor primária do tema quando o campo está focado
              ),
              labelStyle: Theme.of(context).textTheme.bodyMedium, // Cor inicial para o rótulo
              border: InputBorder.none, // Remove a borda interna padrão
              prefixIcon: widget.icon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: widget.icon,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              filled: true,
              fillColor: Colors.transparent, // O preenchimento será feito pelo container externo
            ),
            style: _focusNode.hasFocus || widget.controller.text.isNotEmpty
                ? Theme.of(context).textTheme.bodyLarge // Texto preto/branco quando focado ou preenchido
                : Theme.of(context).textTheme.bodyMedium, // Texto cinza quando não está preenchido
          ),
        ),
      ),
    );
  }
}

// CustomDateTextField para campos de data
class CustomDateTextField extends CustomTextField {
  CustomDateTextField({
    Key? key,
    required String hintText,
    required TextEditingController controller,
    void Function(String value)? onChanged,
  }) : super(
          key: key,
          hintText: hintText,
          obscureText: false,
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(8),
            TextInputFormatter.withFunction((oldValue, newValue) {
              return TextEditingValue(
                text: _formatDate(newValue.text),
                selection: TextSelection.collapsed(offset: _formatDate(newValue.text).length),
              );
            }),
          ],
          onChanged: onChanged,
        );

  static String _formatDate(String input) {
    input = input.replaceAll(RegExp(r'\D'), ''); // Remove tudo que não é dígito
    String dia = '';
    String mes = '';
    String ano = '';

    if (input.length >= 2) {
      dia = input.substring(0, 2);
    } else {
      dia = input;
    }

    if (input.length >= 4) {
      mes = input.substring(2, 4);
    } else if (input.length > 2) {
      mes = input.substring(2);
    }

    if (input.length >= 5) {
      ano = input.substring(4);
    }

    String formatted = dia;
    if (mes.isNotEmpty) {
      formatted += '/$mes';
    }
    if (ano.isNotEmpty) {
      formatted += '/$ano';
    }

    return formatted;
  }
}