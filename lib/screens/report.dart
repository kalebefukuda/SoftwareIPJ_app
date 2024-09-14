import 'package:flutter/material.dart';
import '../utils/constants/text_font.dart';
import '../utils/constants/app_colors.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Appcolors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Encapsulado em uma função anônima
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Appcolors.white,
          ),
        ),
        title: const Text('Relatórios', style: TextFonts.poppinsMedium),
        centerTitle: true,
      ),
      body: const Card(),
    );
  }
}
