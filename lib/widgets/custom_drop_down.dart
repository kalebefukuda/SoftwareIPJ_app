import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final TextEditingController controller;
  final String? hintText;

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.controller,
    this.hintText,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Aplica o radius diretamente no ClipRRect
      child: Container(
        height: 52, // Altura do campo para combinar com outros campos
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor, // Cor de fundo definida pelo tema
          borderRadius: BorderRadius.circular(15), // Radius para borda
          border: Border.all(
            color: _focusNode.hasFocus ? const Color(0xFF015B40) : Colors.transparent,
            width: _focusNode.hasFocus ? 2.0 : 1.0,
          ),
        ),
        child: DropdownMenuTheme(
          data: DropdownMenuThemeData(
            menuStyle: MenuStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55), // Define cantos arredondados no menu
                ),
              ),
            ),
          ),
          child: DropdownButtonFormField<String>(
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              floatingLabelStyle: const TextStyle(
                fontSize: 16,
                color: Color(0xFF015B40), // Cor do rótulo quando o campo está focado
              ),
              border: InputBorder.none, // Remove a borda interna padrão
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              filled: true,
              fillColor: Colors.transparent, // Preenchimento transparente, controlado pelo container externo
            ),
            value: widget.controller.text.isEmpty ? null : widget.controller.text, // Valor padrão (nenhum selecionado)
            icon: const Padding(
              padding: EdgeInsets.only(right: 0), // Ajusta a seta para o lado direito
              child: Icon(Icons.arrow_drop_down, size: 24),
            ),
            iconSize: 24,
            iconEnabledColor: const Color(0xFF015B40),
            style: _focusNode.hasFocus || widget.controller.text.isNotEmpty
                ? Theme.of(context).textTheme.bodyLarge // Texto preto/branco quando focado ou preenchido
                : Theme.of(context).textTheme.bodyMedium, // Texto cinza quando não está preenchido
            onChanged: (String? newValue) {
              widget.controller.text = newValue ?? '';
            },
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            dropdownColor: Theme.of(context).inputDecorationTheme.fillColor, // Cor do dropdown
          ),
        ),
      ),
    );
  }
}