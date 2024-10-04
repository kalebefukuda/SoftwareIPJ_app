import 'package:flutter/material.dart';
import '../utils/constants/text_font.dart';
import '../utils/constants/app_colors.dart';
import '../widgets/card_report.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor:  Theme.of(context).appBarTheme.backgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Função de retorno
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
      body: ListView(  // Substituímos Column por ListView para permitir a rolagem
        padding: const EdgeInsets.all(16.0),
        children: const [
          CardReport("Lista de\nAniversariantes"),
          CardReport("Lista de Chamada\nAssembleia"),
          CardReport("Lista de\nComungantes Mas"),
          CardReport("Lista de\nComungantes Fem"),
          CardReport("Lista de Não\nComungantes Mas"),
          CardReport("Lista de Não\nComungantes Fem"),
          CardReport("Lista de\nComungantes Sede"),
          CardReport("Lista de\nDatas de Casamento"),
        ],
      ),
    );
  }
}
