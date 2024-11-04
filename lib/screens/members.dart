import 'package:SoftwareIPJ/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<Map<String, dynamic>> membersData = []; 

  @override
  void initState() {
    super.initState();
    _fetchMembers(); 
  }

  Future<void> _fetchMembers() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('members').get();

      setState(() {
        membersData = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print("Erro ao buscar membros: $e");
    }
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('120 Homens',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 16)),
                  const SizedBox(width: 20),
                  Text('80 Mulheres',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  hintStyle: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFFB5B5B5),
                      fontWeight: FontWeight.w400),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 1),
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
              Text(
                'Todos os membros:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ...membersData.map((member) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: member['foto'] != null
                            ? NetworkImage(member['foto'])
                            : AssetImage('assets/images/avatar_placeholder.png')
                                as ImageProvider, // Placeholder caso não haja imagem
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              member['nomeCompleto'] ?? 'Nome não disponível',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              member['telefone'] ?? 'Telefone não disponível',
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
              }).toList(),
              const SizedBox(height: 100),
            ],
          ),
          BottomSidebar(
            currentIndex: currentIndex,
            onTabTapped: onTabTapped,
            onThemeToggle: widget.onThemeToggle,
            isDarkModeNotifier: widget.isDarkModeNotifier,
            isKeyboardVisible: MediaQuery.of(context).viewInsets.bottom != 0,
          ),
        ],
      ),
    );
  }
}
