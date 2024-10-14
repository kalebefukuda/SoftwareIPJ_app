import 'package:flutter/material.dart';
import '../widgets/card_register.dart';
import '../widgets/card_members.dart';
import '../widgets/card_report_home.dart';
import '../widgets/card_count_members.dart'; // Importe o novo widget

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Abre o menu lateral
          },
          icon: Icon(
            Icons.menu,
            size: 30,
            color: Theme.of(context).iconTheme.color,
          ),
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            // Card de cadastro de membros, ocupando toda a largura
            CardRegister(),
            SizedBox(height: 29),
            // Cards de membros e relatório na mesma linha, ocupando cada um metade da largura do card acima
            Row(
              children: [
                Expanded(
                  child: CardMembers(),
                ),
                SizedBox(width: 29), // Espaço entre os dois cards
                Expanded(
                  child: CardReport(),
                ),
              ],
            ),
            SizedBox(height: 29),
            // Adicionando o card de contagem de membros
            MembersCountCard(),
          ],
        ),
      ),
    );
  }
}
