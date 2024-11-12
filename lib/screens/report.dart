import 'package:flutter/material.dart';
// import 'package:SoftwareIPJ/screens/home.dart';
// import '../utils/constants/text_font.dart';
import '../app.dart';
import '../utils/constants/app_colors.dart';
import '../widgets/card_report.dart';
import '../widgets/sidebar.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';

class Report extends StatefulWidget {
  final Function(ThemeModeOptions) onThemeToggle;
  final ValueNotifier<ThemeModeOptions> themeModeNotifier;

  const Report({
    super.key,
    required this.onThemeToggle,
    required this.themeModeNotifier,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  int currentIndex = 3;

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
        // automaticallyImplyLeading: false, //Desabilita o botão de qualquer jeito, ignorando a biblioteca do FLUTTER
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Appcolors.white,
          ),
        ),
        title: Text('Relatórios', style: Theme.of(context).textTheme.titleLarge),
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
              SizedBox(height: 100), //Esse Widget é para dar uma espaçamento final para a sidebar não sobrepor os itens da tela
            ],
          ),
          BottomSidebar(
              currentIndex: currentIndex,
              onTabTapped: onTabTapped,
              onThemeToggle: widget.onThemeToggle, // Passando o parâmetro necessário
              themeModeNotifier: widget.themeModeNotifier, // Passando o parâmetro necessário
              isKeyboardVisible: MediaQuery.of(context).viewInsets.bottom != 0),
        ],
      ),
    );
  }
}
