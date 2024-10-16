import 'package:flutter/material.dart';
import '../utils/constants/text_font.dart';
import '../utils/constants/app_colors.dart';
import '../widgets/card_report.dart';
import '../widgets/sidebar.dart';

class Report extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final ValueNotifier<bool> isDarkModeNotifier;

  const Report({
    super.key,
    required this.onThemeToggle,
    required this.isDarkModeNotifier,
  });

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  int currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(15.0),
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
          BottomSidebar(
            currentIndex: currentIndex,
            onTabTapped: onTabTapped,
            onThemeToggle: widget.onThemeToggle, // Passando o parâmetro necessário
            isDarkModeNotifier: widget.isDarkModeNotifier, // Passando o parâmetro necessário
          ),
        ],
      ),
    );
  }
}
