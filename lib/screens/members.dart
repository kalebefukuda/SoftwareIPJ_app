import 'package:SoftwareIPJ/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class Members extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final ValueNotifier<bool> isDarkModeNotifier;

  const Members({
    super.key,
    required this.onThemeToggle,
    required this.isDarkModeNotifier,
  });

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  int currentIndex = 2;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<String> members = [
    'Kalebe Fukuda de Oliveira',
    'João Silva',
    'Maria Souza',
    'Ana Pereira',
    'Pedro Santos'
  ];

  final List<String> phoneNumbers = [
    '66 999755645',
    '66 999756546',
    '66 999123456',
    '66 999987654',
    '66 999765432'
  ];

  final List<String> avatars = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
        title: Text('Membros', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              // Contagem de membros
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('120 Homens',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 16)),
                  SizedBox(width: 20),
                  Text('80 Mulheres',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              // Barra de pesquisa
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  hintStyle: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFFB5B5B5),
                      fontWeight: FontWeight.w400),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 1), // Controla a altura do TextField
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFB5B5B5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Lista de membros
              Text(
                'Todos os membros:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ...List.generate(members.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(avatars[index]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              members[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phoneNumbers[index],
                              style: const TextStyle(
                                color: Color(0xFFB5B5B5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 100),
            ],
          ),
          BottomSidebar(
            currentIndex: currentIndex,
            onTabTapped: onTabTapped,
            onThemeToggle: widget.onThemeToggle,
            isDarkModeNotifier: widget.isDarkModeNotifier,
          ),
        ],
      ),
    );
  }
}
