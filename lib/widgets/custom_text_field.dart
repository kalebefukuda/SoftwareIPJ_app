import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? icon; // Pode ser qualquer Widget, como um ícone SVG

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.icon, int? width,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode(); // FocusNode para detectar o foco

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Atualiza o estado quando o foco muda
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Libera o FocusNode quando o widget é removido
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Fundo branco com opacidade
        border: Border.all(
          color: _focusNode.hasFocus ?  const Color(0xFF015B40) : Colors.transparent, // Cor da borda quando focada ou não
          width: _focusNode.hasFocus ? 2.0 : 1.0, // Espessura da borda mais fina
        ),
        borderRadius: BorderRadius.circular(25), // Define o raio da borda
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        focusNode: _focusNode, // Associa o FocusNode ao campo de texto
        decoration: InputDecoration(
          labelText: widget.hintText,
          floatingLabelStyle: const TextStyle(
            fontSize: 16, // Tamanho ajustado do rótulo flutuante
            color: Color(0xFF015B40), // Cor do rótulo flutuante
          ),
          border: InputBorder.none, // Remove a borda interna padrão
          prefixIcon: widget.icon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: widget.icon,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Reduzido para campos mais finos
          filled: true,
          fillColor: Colors.transparent, // Tornar o campo de entrada transparente
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
