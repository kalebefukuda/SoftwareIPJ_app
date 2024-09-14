import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? icon;
  final Color? fillColor;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.icon,
    this.fillColor = const Color(0xFFE7E7E7), // Valor padrão para cor de preenchimento
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

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Aplica o radius diretamente no ClipRRect
      child: Container(
        decoration: BoxDecoration(
          color: widget.fillColor, // Aplica a cor de fundo
          borderRadius: BorderRadius.circular(15), // Aplica o radius ao container
          border: Border.all(
            color: isFocused ? const Color(0xFF015B40) : Colors.transparent,
            width: isFocused ? 2.0 : 1.0,
          ),
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: widget.hintText,
            floatingLabelStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xFF015B40), // Cor do rótulo quando o campo está focado
            ),
            labelStyle: Theme.of(context).textTheme.bodyMedium, // Cor inicial para o rótulo
            border: InputBorder.none, // Remove a borda interna padrão
            prefixIcon: widget.icon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: widget.icon,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            filled: true,
            fillColor: Colors.transparent, // O preenchimento será feito pelo container externo
          ),
          style: _focusNode.hasFocus || widget.controller.text.isNotEmpty
              ? Theme.of(context).textTheme.bodyLarge // Texto preto/branco quando focado ou preenchido
              : Theme.of(context).textTheme.bodyMedium, // Texto cinza quando não está preenchido
        ),
      ),
    );
  }
}