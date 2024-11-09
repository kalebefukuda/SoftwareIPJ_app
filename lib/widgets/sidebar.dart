import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
    // Reduzimos a duração da animação para ser mais rápida, minimizando a sensação de atraso
    const duration = Duration(milliseconds: 300);

    return AnimatedSlide(
      offset: isKeyboardVisible ? const Offset(0, 1) : const Offset(0, 0),
      duration: duration,
      curve: Curves.easeOut, // Curva que acelera para fora, removendo um pouco do atraso
      child: AnimatedOpacity(
        opacity: isKeyboardVisible ? 0.0 : 1.0,
        duration: duration,
        curve: Curves.easeOut, // Curva consistente com a animação de deslocamento
        child: Align(
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
                        color: Theme.of(context).inputDecorationTheme.fillColor?.withOpacity(0.70),
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
                            icon: PhosphorIcon(
                              PhosphorIcons.house(PhosphorIconsStyle.bold),
                              color: currentIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.tertiary,
                              size: currentIndex == 0 ? 30 : 24,
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
                            icon: PhosphorIcon(
                              PhosphorIcons.userPlus(PhosphorIconsStyle.bold),
                              color: currentIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.tertiary,
                              size: currentIndex == 1 ? 30 : 24,

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
                            icon: PhosphorIcon(
                              PhosphorIcons.users(PhosphorIconsStyle.bold),
                              color: currentIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.tertiary,
                              size: currentIndex == 2 ? 30 : 24,

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
                            icon: PhosphorIcon(
                              PhosphorIcons.file(PhosphorIconsStyle.bold),
                              color: currentIndex == 3 ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.tertiary,
                              size: currentIndex == 3 ? 30 : 24,

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
