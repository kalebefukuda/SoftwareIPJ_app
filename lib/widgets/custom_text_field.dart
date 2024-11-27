// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final bool readOnly; // Adicione a propriedade readOnly
  final Color? borderColor; // Adicione o parâmetro para borda

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.icon,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.borderColor,
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Aplica o radius diretamente no ClipRRect
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor, // Usa a cor de fundo do tema
          borderRadius: BorderRadius.circular(15), // Aplica o radius ao container
          border: Border.all(
            color: _focusNode.hasFocus
                ? Theme.of(context).primaryColor // Prioridade para verde ao focar
                : (widget.borderColor ?? Colors.transparent), // Vermelha ou transparente se não focado
            width: 2.0,
          ),
        ),
        child: GestureDetector(
          onTap: _unfocusKeyboard, // Quando o usuário toca fora do campo de texto
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            focusNode: widget.readOnly ? null : _focusNode, // Desativa o FocusNode no modo de leitura
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            validator: widget.validator,
            readOnly: widget.readOnly, // Adicione a propriedade readOnly
            onEditingComplete: () {
              if (widget.textInputAction == TextInputAction.next) {
                FocusScope.of(context).nextFocus(); // Move para o próximo campo
              } else if (widget.textInputAction == TextInputAction.done) {
                FocusScope.of(context).unfocus(); // Fecha o teclado
              }
            },
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
    super.key,
    required super.hintText,
    required super.controller,
    super.textInputAction, // Repassa textInputAction para uso em "Próximo" ou "Concluído"
    super.onChanged,
    super.borderColor, // Inclua isso
  }) : super(
          obscureText: false,
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

// CustomCapitalizedTextField para capitalizar cada palavra automaticamente
class CustomCapitalizedTextField extends CustomTextField {
  CustomCapitalizedTextField({
    super.key,
    required super.hintText,
    required super.controller,
    final ValueChanged<String>? onChanged,
    super.textInputAction,
    bool? readOnly, // Repassa textInputAction para funcionar com "Próximo" e "Concluído"
    super.borderColor, // Inclua isso
  }) : super(
          obscureText: false,
          onChanged: (value) {
            final capitalized = _capitalize(value);
            if (capitalized != value) {
              controller.value = controller.value.copyWith(
                text: capitalized,
                selection: TextSelection.collapsed(offset: capitalized.length),
              );
            }
          },
        );
  static String _capitalize(String input) {
    return input.split(' ').map((str) => str.isNotEmpty ? str[0].toUpperCase() + str.substring(1).toLowerCase() : '').join(' ');
  }
}

class CustomCepTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(Map<String, String> endereco) onEnderecoEncontrado;
  final void Function()? onCepNaoEncontrado;
  final void Function()? onErro;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction; // Adiciona textInputAction ao CEP

  const CustomCepTextField({
    super.key,
    required this.controller,
    this.hintText = 'CEP',
    required this.onEnderecoEncontrado,
    this.onCepNaoEncontrado,
    this.onErro,
    this.onChanged,
    this.textInputAction,
  });

  @override
  _CustomCepTextFieldState createState() => _CustomCepTextFieldState();
}

class _CustomCepTextFieldState extends State<CustomCepTextField> {
  late MaskTextInputFormatter maskFormatter;

  @override
  void initState() {
    super.initState();
    maskFormatter = MaskTextInputFormatter(
      mask: '#####-###',
      filter: {
        "#": RegExp(r'[0-9]')
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: widget.hintText,
      obscureText: false,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      textInputAction: widget.textInputAction, // Passa o textInputAction para o campo CEP
      inputFormatters: [
        maskFormatter
      ],
      onChanged: (value) {
        String rawCep = maskFormatter.getUnmaskedText();
        if (rawCep.length == 8) {
          _buscarEnderecoPorCep(
            rawCep,
            widget.onEnderecoEncontrado,
            widget.onCepNaoEncontrado,
            widget.onErro,
          );
        }
        if (widget.onChanged != null) widget.onChanged!(value);
      },
    );
  }

  static Future<void> _buscarEnderecoPorCep(
    String cep,
    void Function(Map<String, String> endereco) onEnderecoEncontrado,
    void Function()? onCepNaoEncontrado,
    void Function()? onErro,
  ) async {
    try {
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('erro') && data['erro'] == true) {
          if (onCepNaoEncontrado != null) onCepNaoEncontrado();
        } else {
          onEnderecoEncontrado({
            'bairro': data['bairro'] ?? '',
            'logradouro': data['logradouro'] ?? '',
            'localidade': data['localidade'] ?? '',
            'uf': data['uf'] ?? '',
          });
        }
      } else {
        if (onErro != null) onErro();
      }
    } catch (e) {
      if (onErro != null) onErro();
    }
  }
}
