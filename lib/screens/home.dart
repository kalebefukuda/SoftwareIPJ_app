import 'package:SoftwareIPJ/screens/create_members.dart';
import 'package:SoftwareIPJ/screens/members.dart';
import 'package:SoftwareIPJ/screens/report.dart';
import 'package:flutter/material.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // Define a altura do AppBar
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0), // Adiciona padding horizontal no AppBar
          child: AppBar(
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
                    size: 40,
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
                  height: 80,
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(
        onThemeToggle: widget.onThemeToggle,
        isDarkModeNotifier: widget.isDarkModeNotifier,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateMembersScreen(
                      onThemeToggle: widget.onThemeToggle,
                      isDarkModeNotifier: widget.isDarkModeNotifier,
                    ),
                  ),
                );
              },
              child: const CardRegister(),
            ),
            const SizedBox(height: 29),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Members(
                            onThemeToggle: widget.onThemeToggle,
                            isDarkModeNotifier: widget.isDarkModeNotifier,
                          ),
                        ),
                      );
                    },
                    child: const CardMembers(),
                  ),
                ),
                const SizedBox(width: 29),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Report(
                            onThemeToggle: widget.onThemeToggle,
                            isDarkModeNotifier: widget.isDarkModeNotifier,
                          ),
                        ),
                      );
                    },
                    child: const CardReport(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 29),
            const MembersCountCard(),
          ],
        ),
      ),
    );
  }
}