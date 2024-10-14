import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          // Ícone de membros
          SvgPicture.asset(
            'assets/images/members.svg',
            width: 50,
            height: 50,
          ),
        ],
      ),
    );
  }
}
