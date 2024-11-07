import 'package:SoftwareIPJ/screens/view_member_screen.dart'; // Importar a nova tela de visualização
import 'package:SoftwareIPJ/screens/create_members.dart';
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
  Map<String, double> slidePositions = {};
  String? currentlySlidMemberId;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchMembers();

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _resetSlidePositions();
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchMembers() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('members').get();

      setState(() {
        membersData = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>
                })
            .toList();
      });
    } catch (e) {
      print("Erro ao buscar membros: $e");
    }
  }

  Future<void> _deleteMember(String memberId) async {
    try {
      DocumentSnapshot memberSnapshot = await FirebaseFirestore.instance.collection('members').doc(memberId).get();

      if (memberSnapshot.exists) {
        Map<String, dynamic> memberData = memberSnapshot.data() as Map<String, dynamic>;
        memberData['deletedAt'] = DateTime.now().toIso8601String();

        await FirebaseFirestore.instance.collection('deleted_members').doc(memberId).set(memberData);
        await FirebaseFirestore.instance.collection('members').doc(memberId).delete();

        _fetchMembers();
      } else {
        print("Erro: Documento não encontrado na coleção 'members'.");
      }
    } catch (e) {
      print("Erro ao mover membro para a coleção 'deleted_members': $e");
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
              title: const Center(
                child: Text(
                  'Confirmar Exclusão',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Você realmente deseja excluir este membro?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  void _editMember(Map<String, dynamic> member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateMembersScreen(
          memberData: member,
          onThemeToggle: widget.onThemeToggle,
          isDarkModeNotifier: widget.isDarkModeNotifier,
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, String memberId) {
    setState(() {
      if (currentlySlidMemberId != null && currentlySlidMemberId != memberId) {
        slidePositions[currentlySlidMemberId!] = 0.0;
      }

      currentlySlidMemberId = memberId;

      slidePositions[memberId] = (slidePositions[memberId] ?? 0.0) + details.delta.dx;
      slidePositions[memberId] = slidePositions[memberId]!.clamp(-130.0, 0.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details, String memberId) {
    setState(() {
      if (slidePositions[memberId]! < -50) {
        slidePositions[memberId] = -130.0;
      } else {
        slidePositions[memberId] = 0.0;
        currentlySlidMemberId = null;
      }
    });
  }

  void _resetSlidePositions() {
    setState(() {
      slidePositions.updateAll((key, value) => 0.0);
      currentlySlidMemberId = null;
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
      body: GestureDetector(
        onTap: _resetSlidePositions,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(15.0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('120 Homens', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16)),
                    const SizedBox(width: 20),
                    Text('80 Mulheres', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar',
                    hintStyle: const TextStyle(fontSize: 17, color: Color(0xFFB5B5B5), fontWeight: FontWeight.w400),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ...membersData.map((member) {
                  String memberId = member['id'];
                  return GestureDetector(
                    onHorizontalDragUpdate: (details) => _onHorizontalDragUpdate(details, memberId),
                    onHorizontalDragEnd: (details) => _onHorizontalDragEnd(details, memberId),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewMemberScreen(
                            memberData: member,
                            onThemeToggle: widget.onThemeToggle,
                            isDarkModeNotifier: widget.isDarkModeNotifier,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => _editMember(member),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF015B40),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool confirm = await _confirmDelete(context);
                                  if (confirm) {
                                    _deleteMember(member['id']);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 154, 27, 27),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(slidePositions[memberId] ?? 0.0, 0, 0),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: member['foto'] != null && member['foto'] is String ? NetworkImage(member['foto']) : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      member['nomeCompleto'] ?? 'Nome não disponível',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
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
              isKeyboardVisible: MediaQuery.of(context).viewInsets.bottom != 0,
            ),
          ],
        ),
      ),
    );
  }
}