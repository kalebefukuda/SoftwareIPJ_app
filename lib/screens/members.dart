// ignore_for_file: library_private_types_in_public_api

import '../app.dart';
import 'package:softwareipj/screens/view_member_screen.dart';
import 'package:softwareipj/screens/create_members.dart';
import 'package:softwareipj/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/member_service.dart';
import '../widgets/custom_banner.dart';
import 'package:diacritic/diacritic.dart';

class Members extends StatefulWidget {
  final Function(ThemeModeOptions) onThemeToggle;
  final ValueNotifier<ThemeModeOptions> themeModeNotifier;
  final String? successMessage;

  const Members({
    super.key,
    required this.onThemeToggle,
    this.successMessage,
    required this.themeModeNotifier,
  });

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  int currentIndex = 2;
  List<Map<String, dynamic>> membersData = [];
  List<Map<String, dynamic>> filteredMembers = [];
  Map<String, double> slidePositions = {};
  String? currentlySlidMemberId;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  int maleCount = 0;
  int femaleCount = 0;
  int yesCommunicantCount = 0;
  int noCommunicantCount = 0;
  bool filterMen = false;
  bool filterWomen = false;
  bool filterCommunicant = false;
  bool filterNonCommunicant = false;
  final MemberService memberService = MemberService();

  bool _isBannerVisible = false;
  String _bannerMessage = '';
  Color _bannerColor = Colors.green;

  @override
  void initState() {
    super.initState();
    if (widget.successMessage != null) {
      _showBanner(widget.successMessage!, const Color(0xFF015B40));
    }
    _fetchMembers();
    _getMemberCounts();

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _resetSlidePositions();
      }
    });

    _searchController.addListener(_filterMembers);
  }

  Future<void> _getMemberCounts() async {
    try {
      Map<String, int> counts = await memberService.getMemberCountByGenderAndCommunicant();
      setState(() {
        maleCount = counts['Masculino'] ?? 0;
        femaleCount = counts['Feminino'] ?? 0;
        yesCommunicantCount = counts['SIM'] ?? 0;
        noCommunicantCount = counts['NÃO'] ?? 0;
      });
    } catch (e) {
      print("Erro ao obter contagem de membros: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetSlidePositions();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
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

        // Ordena a lista de membros em ordem alfabética pelo nome completo
        membersData.sort((a, b) {
          String nameA = a['nomeCompleto']?.toLowerCase() ?? '';
          String nameB = b['nomeCompleto']?.toLowerCase() ?? '';
          return nameA.compareTo(nameB);
        });

        // Copia a lista ordenada para filteredMembers
        filteredMembers = List.from(membersData);
      });
    } catch (e) {
      print("Erro ao buscar membros: $e");
    }
  }

  void _filterMembers() {
    String query = removeDiacritics(_searchController.text.toLowerCase());
    setState(() {
      filteredMembers = membersData.where((member) {
        // Remove os acentos do nome completo antes de comparar
        String nomeCompleto = member['nomeCompleto'] ?? '';
        bool matchesQuery = removeDiacritics(nomeCompleto.toLowerCase()).contains(query);

        // Filtra por gênero
        bool matchesGender = true;
        if (filterMen) {
          matchesGender = member['sexo'] == 'Masculino';
        } else if (filterWomen) {
          matchesGender = member['sexo'] == 'Feminino';
        }

        // Filtra por comungantes
        bool matchesCommunicant = true;
        if (filterCommunicant) {
          matchesCommunicant = member['comungante'] == 'SIM';
        } else if (filterNonCommunicant) {
          matchesCommunicant = member['comungante'] == 'NÃO';
        } else if (member['comungante'] == null) {
          matchesCommunicant = false; // Exclua membros sem o campo 'comungante'
        }

        // Retorna se todos os critérios forem atendidos
        return matchesQuery && matchesGender && matchesCommunicant;
      }).toList();
    });
  }

  Color? _getFilterBackgroundColor(BuildContext context, bool isActive) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode) {
      return isActive ? Theme.of(context).iconTheme.color : Theme.of(context).inputDecorationTheme.fillColor;
    }

    return isActive ? Theme.of(context).iconTheme.color?.withOpacity(0.3) : Theme.of(context).inputDecorationTheme.fillColor;
  }

  void _toggleGenderFilter(String filterType) {
    setState(() {
      if (filterType == 'Masculino') {
        filterMen = !filterMen;
        if (filterMen) filterWomen = false;
      } else if (filterType == 'Feminino') {
        filterWomen = !filterWomen;
        if (filterWomen) filterMen = false;
      } else if (filterType == 'SIM') {
        filterCommunicant = !filterCommunicant;
        if (filterCommunicant) filterNonCommunicant = false;
      } else if (filterType == 'NÃO') {
        filterNonCommunicant = !filterNonCommunicant;
        if (filterNonCommunicant) filterCommunicant = false;
      }
      _filterMembers(); // Chama a função para aplicar os filtros
    });
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
        _showBanner('Membro excluído!', const Color.fromARGB(255, 154, 27, 27));
      } else {
        print("Erro: Documento não encontrado na coleção 'members'.");
      }
    } catch (e) {
      print("Erro ao mover membro para a coleção 'deleted_members': $e");
      _showBanner('Erro ao excluir membro.', const Color.fromARGB(255, 154, 27, 27));
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
          themeModeNotifier: widget.themeModeNotifier,
        ),
      ),
    ).then((_) {
      _resetSlidePositions();
    });
  }

  void _viewMember(Map<String, dynamic> member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewMemberScreen(
          memberData: member,
          onThemeToggle: widget.onThemeToggle,
          themeModeNotifier: widget.themeModeNotifier,
        ),
      ),
    ).then((_) {
      _resetSlidePositions();
    });
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

  void _showBanner(String message, Color color) {
    setState(() {
      _bannerMessage = message;
      _bannerColor = color;
      _isBannerVisible = true;
    });
  }

  void _resetSlidePositions() {
    setState(() {
      slidePositions.updateAll((key, value) => 0.0);
      currentlySlidMemberId = null;
    });
  }

  void _hideBanner() {
    setState(() {
      _isBannerVisible = false;
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleGenderFilter('Masculino'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getFilterBackgroundColor(context, filterMen),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: filterMen ? const EdgeInsets.symmetric(vertical: 7.0, horizontal: 14) : const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                          child: Text(
                            '$maleCount Homens',
                            style: filterMen
                                ? Theme.of(context).textTheme.titleSmall
                                : Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: 14,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _toggleGenderFilter('Feminino'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getFilterBackgroundColor(context, filterWomen),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: filterWomen ? const EdgeInsets.symmetric(vertical: 7.0, horizontal: 14) : const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                          child: Text(
                            '$femaleCount Mulheres',
                            style: filterWomen
                                ? Theme.of(context).textTheme.titleSmall
                                : Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: 14,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _toggleGenderFilter('SIM'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getFilterBackgroundColor(context, filterCommunicant),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: filterCommunicant ? const EdgeInsets.symmetric(vertical: 7.0, horizontal: 14) : const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                          child: Text(
                            '$yesCommunicantCount Comungantes',
                            style: filterCommunicant
                                ? Theme.of(context).textTheme.titleSmall
                                : Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: 14,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _toggleGenderFilter('NÃO'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getFilterBackgroundColor(context, filterNonCommunicant),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: filterNonCommunicant ? const EdgeInsets.symmetric(vertical: 7.0, horizontal: 14) : const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                          child: Text(
                            '$noCommunicantCount Não Comungantes',
                            style: filterNonCommunicant
                                ? Theme.of(context).textTheme.titleSmall
                                : Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: 14,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
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
                ...filteredMembers.map((member) {
                  String memberId = member['id'];
                  return GestureDetector(
                    onHorizontalDragUpdate: (details) => _onHorizontalDragUpdate(details, memberId),
                    onHorizontalDragEnd: (details) => _onHorizontalDragEnd(details, memberId),
                    onTap: () {
                      _viewMember(member);
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
                                      member['celular'] ?? ['telefone'],
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
                }).toList(),
                const SizedBox(height: 100),
              ],
            ),
            if (_isBannerVisible)
              Positioned(
                top: 10,
                right: 0,
                child: CustomBanner(
                  message: _bannerMessage,
                  backgroundColor: _bannerColor,
                  onDismissed: _hideBanner,
                ),
              ),
            BottomSidebar(
              currentIndex: currentIndex,
              onTabTapped: onTabTapped,
              onThemeToggle: widget.onThemeToggle,
              themeModeNotifier: widget.themeModeNotifier,
              isKeyboardVisible: MediaQuery.of(context).viewInsets.bottom != 0,
            ),
          ],
        ),
      ),
    );
  }
}
