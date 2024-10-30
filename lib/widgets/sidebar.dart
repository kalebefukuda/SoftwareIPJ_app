import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../screens/home.dart';
import '../screens/report.dart';
import '../screens/create_members.dart';
import '../screens/members.dart';

class BottomSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final Function(bool) onThemeToggle;
  final ValueNotifier<bool> isDarkModeNotifier;
  final bool isKeyboardVisible;

  const BottomSidebar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.onThemeToggle,
    required this.isDarkModeNotifier,
    required this.isKeyboardVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor?.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Ícone Casa
                          IconButton(
                            onPressed: currentIndex == 0
                                ? null
                                : () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          onThemeToggle: onThemeToggle,
                                          isDarkModeNotifier: isDarkModeNotifier,
                                        ),
                                      ),
                                      (Route<dynamic> route) => false, // Remove todas as rotas anteriores
                                    );
                                    onTabTapped(0);
                                  },
                            icon: SvgPicture.asset(
                              'assets/images/house.svg',
                              color: currentIndex == 0 ? Colors.grey : Theme.of(context).iconTheme.color,
                              height: 24,
                              width: 24,
                            ),
                          ),
                          // Ícone Criar Membro
                          IconButton(
                            onPressed: currentIndex == 1
                                ? null
                                : () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateMembersScreen(
                                          onThemeToggle: onThemeToggle,
                                          isDarkModeNotifier: isDarkModeNotifier,
                                        ),
                                      ),
                                    );
                                    onTabTapped(1);
                                  },
                            icon: SvgPicture.asset(
                              'assets/images/create_member.svg',
                              color: currentIndex == 1 ? Colors.grey : Theme.of(context).iconTheme.color,
                              height: 24,
                              width: 24,
                            ),
                          ),
                          // Ícone Membros
                          IconButton(
                            onPressed: currentIndex == 2
                                ? null
                                : () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Members(
                                          onThemeToggle: onThemeToggle,
                                          isDarkModeNotifier: isDarkModeNotifier,
                                        ),
                                      ),
                                    );
                                    onTabTapped(2);
                                  },
                            icon: SvgPicture.asset(
                              'assets/images/members.svg',
                              color: currentIndex == 2 ? Colors.grey : Theme.of(context).iconTheme.color,
                              height: 24,
                              width: 24,
                            ),
                          ),
                          // Ícone Arquivo
                          IconButton(
                            onPressed: currentIndex == 3
                                ? null
                                : () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Report(
                                          onThemeToggle: onThemeToggle,
                                          isDarkModeNotifier: isDarkModeNotifier,
                                        ),
                                      ),
                                    );
                                    onTabTapped(3);
                                  },
                            icon: SvgPicture.asset(
                              'assets/images/file.svg',
                              color: currentIndex == 3 ? Colors.grey : Theme.of(context).iconTheme.color,
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}