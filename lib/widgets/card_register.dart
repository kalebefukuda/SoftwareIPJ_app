import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CardRegister extends StatefulWidget {
  const CardRegister({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardRegisterState createState() => _CardRegisterState();
}

class _CardRegisterState extends State<CardRegister> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      width: double.infinity, // Definindo largura como infinita para expandir ao máximo possível
      height: 100, // Ajuste na altura para dar mais espaço ao conteúdo
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PhosphorIcon(
              PhosphorIcons.userPlus(PhosphorIconsStyle.bold),
              size: 50,
              color: Colors.white,
          ),
          // Texto do cadastro
          Expanded(
            child: Text(
              'Cadastro de Membros',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Centraliza o texto no espaço disponível
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
