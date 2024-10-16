import 'package:flutter/material.dart';
import 'package:softwareipj_app/screens/report.dart';
import '../widgets/card_register.dart';
import '../widgets/card_members.dart';
import '../widgets/card_report_home.dart';
import '../widgets/card_count_members.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final ValueNotifier<bool> isDarkModeNotifier;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkModeNotifier,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abre o menu lateral
              },
              icon: Icon(
                Icons.menu,
                size: 30,
                color: Theme.of(context).iconTheme.color,
              ),
              splashColor: Colors.transparent, // Remove a sombra ao clicar
              highlightColor: Colors.transparent, // Remove o destaque ao clicar
              focusColor: Colors.transparent, // Remove o destaque ao focar
              hoverColor: Colors.transparent, // Remove o destaque ao passar o mouse por cima
            );
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Image.asset(
              'assets/images/Logo_IPB.png',
              height: 50,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(
        onThemeToggle: widget.onThemeToggle,
        isDarkModeNotifier: widget.isDarkModeNotifier,
      ), // Utilize o CustomDrawer como menu lateral
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Card de cadastro de membros, ocupando toda a largura
            const CardRegister(),
            const SizedBox(height: 29),
            // Cards de membros e relatório na mesma linha, ocupando cada um metade da largura do card acima
            Row(
              children: [
                const Expanded(
                  child: CardMembers(),
                ),
                const SizedBox(width: 29), // Espaço entre os dois cards
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Report(
                            onThemeToggle: widget.onThemeToggle,
                            isDarkModeNotifier: widget.isDarkModeNotifier
                          ), // Navega para a tela de relatório ao clicar no CardReport
                        ),
                      );
                    },
                    child: const CardReport(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 29),
            // Adicionando o card de contagem de membros
            const MembersCountCard(),
          ],
        ),
      ),
    );
  }
}
