import 'package:flutter/material.dart';
import 'package:softwareipj/widgets/screen_scale_wrapper.dart';

class CustomDropdown extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final TextEditingController controller;
  final String? hintText;
  final Color? borderColor; // Adicione o parâmetro para borda

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.controller,
    this.hintText,
    this.borderColor,
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
        height: 55, // Altura do campo para combinar com outros campos
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor, // Cor de fundo definida pelo tema
          borderRadius: BorderRadius.circular(15), // Radius para borda
          border: Border.all(
            color: widget.borderColor ?? (_focusNode.hasFocus ? Theme.of(context).primaryColor : Colors.transparent), // Usa a borda fornecida
            width: 2.0,
          ),
        ),
        child: DropdownButtonFormField<String>(
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: Theme.of(context).textTheme.bodyMedium, // Estilo do rótulo baseado no tema
            floatingLabelStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor, // Cor do rótulo quando o campo está focado
            ),
            border: InputBorder.none, // Remove a borda interna padrão
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            filled: true,
            fillColor: Colors.transparent, // Preenchimento transparente, controlado pelo container externo
          ),
          value: widget.controller.text.isEmpty ? null : widget.controller.text, // Valor padrão (nenhum selecionado)
          icon: Padding(
            padding: const EdgeInsets.only(right: 0), // Ajusta a seta para o lado direito
            child: Icon(Icons.arrow_drop_down, size: 24, color: Theme.of(context).primaryColor), // Ícone com cor do tema
          ),
          iconSize: 24,
          style: _focusNode.hasFocus || widget.controller.text.isNotEmpty
              ? Theme.of(context).textTheme.bodyLarge // Texto preto/branco quando focado ou preenchido
              : Theme.of(context).textTheme.bodyMedium, // Texto cinza quando não está preenchido
          onChanged: (String? newValue) {
            widget.controller.text = newValue ?? '';
          },
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: ScreenScaleWrapper(child: Text(value)),
            );
          }).toList(),
          dropdownColor: Theme.of(context).inputDecorationTheme.fillColor, // Cor do dropdown definida pelo tema
        ),
      ),
    );
  }
}
