import 'package:flutter/material.dart';

class LocalField extends StatefulWidget {
  final bool obscureText;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final String cityLabelText;
  final String stateLabelText;
  final Widget? icon;
    final ValueChanged<String>? onCityChanged; // Adicionando o callback para mudanças no campo cidade


  // Definimos os estados diretamente no widget
  final List<String> states = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  LocalField({
    super.key,
    required this.cityController,
    required this.stateController,
    required this.obscureText,
    this.icon,
    this.cityLabelText = 'Cidade', // Define valores padrão
    this.stateLabelText = 'UF',
        this.onCityChanged, // Callback opcional para o campo cidade

  });

  @override
  State<LocalField> createState() => _LocalFieldState();
}

class _LocalFieldState extends State<LocalField> {
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cityFocusNode.addListener(() {
      setState(() {});
    });
    _stateFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cityFocusNode.dispose();
    _stateFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Campo de cidade (campo maior)
        Expanded(
          flex: 2, // O campo de cidade ocupará mais espaço
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor, // Aplica a cor de fundo do tema
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _cityFocusNode.hasFocus ? Theme.of(context).primaryColor : Colors.transparent, // Usa a cor primária do tema
                  width: _cityFocusNode.hasFocus ? 2.0 : 1.0,
                ),
              ),
              child: TextFormField(
                controller: widget.cityController,
                obscureText: widget.obscureText,
                focusNode: _cityFocusNode,
                onChanged: (value) {
                  // Capitaliza o valor e atualiza o campo se necessário
                  final capitalized = capitalize(value);
                  if (capitalized != value) {
                    widget.cityController.value = widget.cityController.value.copyWith(
                      text: capitalized,
                      selection: TextSelection.collapsed(offset: capitalized.length),
                    );
                  }
                  if (widget.onCityChanged != null) {
                    widget.onCityChanged!(capitalized);
                  }
                },
                decoration: InputDecoration(
                  labelText: widget.cityLabelText, // Usa o texto personalizado para o rótulo
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  floatingLabelStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor, // Usa a cor primária do tema quando o campo está focado
                  ),
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
                style: _cityFocusNode.hasFocus || widget.cityController.text.isNotEmpty
                    ? Theme.of(context).textTheme.bodyLarge // Texto preto/branco quando focado ou preenchido
                    : Theme.of(context).textTheme.bodyMedium, // Texto cinza quando não está preenchido
              ),
            ),
          ),
        ),
        const SizedBox(width: 20), // Espaço entre os dois campos

        // Campo de estado (campo menor)
        Expanded(
          flex: 1, // O campo de estado será menor
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: 55, // Ajusta a altura para combinar com o campo de cidade
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor, // Aplica a cor de fundo do tema
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _stateFocusNode.hasFocus ? Theme.of(context).primaryColor : Colors.transparent, // Usa a cor primária do tema
                  width: _stateFocusNode.hasFocus ? 2.0 : 1.0,
                ),
              ),
              child: DropdownButtonFormField<String>(
                focusNode: _stateFocusNode,
                decoration: InputDecoration(
                  labelText: widget.stateLabelText, // Usa o texto personalizado para o rótulo
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  floatingLabelStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor, // Cor do rótulo quando o campo está focado
                  ),
                  border: InputBorder.none, // Remove a borda interna padrão
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  filled: true,
                  fillColor: Colors.transparent, // O preenchimento será feito pelo container externo
                ),
                value: widget.stateController.text.isEmpty ? null : widget.stateController.text, // Valor padrão (nenhum selecionado)
                icon: const Padding(
                  padding: EdgeInsets.only(right: 0), // Ajusta a seta para o lado direito
                  child: Icon(Icons.arrow_drop_down, size: 24), // Ícone de seta para baixo
                ),
                iconSize: 24,
                iconEnabledColor: Theme.of(context).primaryColor, // Usa a cor primária para o ícone
                style: _stateFocusNode.hasFocus || widget.stateController.text.isNotEmpty
                    ? Theme.of(context).textTheme.bodyLarge // Texto preto/branco quando focado ou preenchido
                    : Theme.of(context).textTheme.bodyMedium, // Texto cinza quando não preenchido
                onChanged: (String? newValue) {
                  // Atualiza o valor selecionado no estado
                  widget.stateController.text = newValue ?? '';
                },
                items: widget.states.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                dropdownColor: Theme.of(context).inputDecorationTheme.fillColor, // Ajusta a cor do dropdown
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String capitalize(String input) {
  return input.split(' ').map((str) => str.isNotEmpty ? str[0].toUpperCase() + str.substring(1).toLowerCase() : '').join(' ');
}