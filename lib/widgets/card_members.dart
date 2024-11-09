import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CardMembers extends StatefulWidget {
  const CardMembers({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardMembersState createState() => _CardMembersState();
}

class _CardMembersState extends State<CardMembers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Use o widget PhosphorIcon com o estilo correto
          PhosphorIcon(
            PhosphorIcons.users(PhosphorIconsStyle.bold), // Defina o estilo do ícone
            size: 50,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}