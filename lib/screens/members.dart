// ignore_for_file: library_private_types_in_public_api

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:softwareipj/screens/home.dart';

import '../app.dart';
import 'package:softwareipj/screens/view_member_screen.dart';
import 'package:softwareipj/screens/create_members.dart';
import 'package:softwareipj/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../services/member_service.dart';
import '../widgets/custom_banner.dart';
import 'package:diacritic/diacritic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  String? _selectedSort; // Variável para armazenar o tipo de ordenação selecionado

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
      final response = await Supabase.instance.client.from('membros').select();
      if (response.isEmpty) {
        setState(() {
          maleCount = 0;
          femaleCount = 0;
          yesCommunicantCount = 0;
          noCommunicantCount = 0;
        });
      }

      List members = response as List;
      setState(() {
        maleCount = members.where((m) => m['sexo'] == 'Masculino').length;
        femaleCount = members.where((m) => (m['sexo']) == 'Feminino').length;
        yesCommunicantCount = members.where((m) => (m['comungante']) == 'SIM').length;
        noCommunicantCount = members.where((m) => (m['comungante']) == 'NÃO').length;
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
      final response = await Supabase.instance.client.from('membros').select();

      if (response.isEmpty) {
        _showBanner('Nenhum membro cadastrado', const Color.fromARGB(255, 10, 54, 216));
      }

      setState(() {
        membersData = (response as List<dynamic>).map((data) => data as Map<String, dynamic>).toList();

        // Ordena os membros por nome
        membersData.sort((a, b) {
          String nameA = a['nomeCompleto']?.toString().toLowerCase() ?? '';
          String nameB = b['nomeCompleto']?.toString().toLowerCase() ?? '';
          return nameA.compareTo(nameB);
        });

        filteredMembers = List.from(membersData);
      });
    } catch (e) {
      print("Erro ao buscar membros: $e");
      _showBanner('Erro ao buscar membros', const Color.fromARGB(255, 154, 27, 27));
    }
  }

  void _filterMembers() {
    String query = removeDiacritics(_searchController.text.toLowerCase());
    setState(() {
      filteredMembers = membersData.where((member) {
        String nomeCompleto = member['nomeCompleto']?.toString() ?? '';
        String numeroRol = member['numeroRol']?.toString() ?? '';

        bool matchesQuery = removeDiacritics(nomeCompleto.toLowerCase()).contains(query) || numeroRol.contains(query);

        bool matchesGender = filterMen
            ? member['sexo']?.toString() == 'Masculino'
            : filterWomen
                ? member['sexo']?.toString() == 'Feminino'
                : true;

        bool matchesCommunicant = filterCommunicant
            ? member['comungante']?.toString() == 'SIM'
            : filterNonCommunicant
                ? member['comungante']?.toString() == 'NÃO'
                : true;

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

  Future<void> _deleteMember(int memberId) async {
    try {
      // Passo 1: Buscar os dados do membro da tabela `membros`
      final memberResponse = await Supabase.instance.client.from('membros').select().eq('id', memberId).single();

      if (memberResponse == null) {
        throw Exception('Membro não encontrado no banco de dados.');
      }

      // Extrai os dados do membro como um mapa
      final memberData = Map<String, dynamic>.from(memberResponse);

      // Passo 2: Adicionar o timestamp de exclusão
      memberData['deleted_at'] = DateTime.now().toIso8601String();

      // Passo 3: Inserir o membro na tabela `membros_deleted`
      final insertResponse = await Supabase.instance.client.from('membros_deleted').insert(memberData).select();

      if (insertResponse == null || insertResponse.isEmpty) {
        throw Exception('Erro ao mover membro para a tabela de backup.');
      }

      // Passo 4: Remover o membro da tabela `membros`
      final deleteResponse = await Supabase.instance.client.from('membros').delete().eq('id', memberId).select();

      if (deleteResponse == null || deleteResponse.isEmpty) {
        throw Exception('Erro ao excluir membro da tabela principal.');
      }

      // Exibe mensagem de sucesso no app
      _showBanner('Membro Excluido!', const Color.fromARGB(255, 154, 27, 27));
      await _fetchMembers(); // Atualiza a lista de membros
      await _getMemberCounts(); // Atualiza as contagens de gênero e comungantes
    } catch (e) {
      print("Erro ao excluir membro: $e");
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

  void _sortByAge() {
    _filterMembers();
    setState(() {
      filteredMembers.sort((a, b) {
        // Extrai as datas de nascimento
        String? dateAString = a['dataNascimento'] as String?;
        String? dateBString = b['dataNascimento'] as String?;

        // Converte as datas para objetos DateTime
        DateTime? dateA = dateAString != null ? _parseDate(dateAString) : null;
        DateTime? dateB = dateBString != null ? _parseDate(dateBString) : null;

        // Se ambas as datas são nulas, considera como iguais
        if (dateA == null && dateB == null) return 0;

        // Se apenas uma das datas é nula, coloca ela como "mais velha"
        if (dateA == null) return 1;
        if (dateB == null) return -1;

        // Calcula as idades e compara
        int ageA = DateTime.now().difference(dateA).inDays ~/ 365;
        int ageB = DateTime.now().difference(dateB).inDays ~/ 365;

        return ageA.compareTo(ageB); // Ordena em ordem crescente
      });
    });
  }

  void _sortByRol() {
    _filterMembers();
    setState(() {
      filteredMembers.sort((a, b) {
        int rolA = int.tryParse(a['numeroRol'] ?? '0') ?? 0;
        int rolB = int.tryParse(b['numeroRol'] ?? '0') ?? 0;
        return rolA.compareTo(rolB);
      });
    });
  }

  void _sortAlphabetically() {
    _filterMembers();
    setState(() {
      filteredMembers.sort((a, b) {
        String nameA = a['nomeCompleto']?.toString().toLowerCase() ?? '';
        String nameB = b['nomeCompleto']?.toString().toLowerCase() ?? '';
        return nameA.compareTo(nameB);
      });
    });
  }

  int? _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return null;

    try {
      final birthDate = _parseDate(dateOfBirth);
      if (birthDate == null) return null;

      final today = DateTime.now();
      int age = today.year - birthDate.year;

      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      print('Erro ao calcular a idade: $e');
      return null;
    }
  }

  DateTime? _parseDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        // Reorganiza a data para o formato ISO 8601
        final formattedDate = '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
        return DateTime.parse(formattedDate);
      }
    } catch (e) {
      print('Erro ao converter data: $e');
    }
    return null; // Retorna null se a conversão falhar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  onThemeToggle: widget.onThemeToggle,
                  themeModeNotifier: widget.themeModeNotifier,
                ),
              ),
              (route) => false, // Remove todas as rotas da pilha
            );
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Pesquisar',
                          hintStyle: const TextStyle(
                            fontSize: 17,
                            color: Color(0xFFB5B5B5),
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 20,
                            color: Color(0xFFB5B5B5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      icon: Icon(
                        PhosphorIcons.funnelSimple(),
                        size: 25.0,
                      ),
                      onSelected: (value) {
                        setState(() {
                          _selectedSort = value; // Atualiza a seleção
                        });

                        if (value == 'Idade') {
                          _sortByAge();
                        } else if (value == 'Número de Rol') {
                          _sortByRol();
                        } else if (value == 'Alfabética') {
                          _sortAlphabetically();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Idade',
                          child: Text(
                            'Idade (1-100)',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _selectedSort == 'Idade' ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey,
                                  fontWeight: _selectedSort == 'Idade' ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Número de Rol',
                          child: Text(
                            'Número de Rol (0-999)',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _selectedSort == 'Número de Rol' ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey,
                                  fontWeight: _selectedSort == 'Número de Rol' ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Alfabética',
                          child: Text(
                            'Ordem Alfabética (A-Z)',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _selectedSort == 'Alfabética' ? Theme.of(context).textTheme.titleMedium?.color : Colors.grey,
                                  fontWeight: _selectedSort == 'Alfabética' ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      offset: const Offset(0, 50),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Todos os membros:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ...filteredMembers.map((member) {
                  String memberId = member['id'].toString();
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
                                backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                                backgroundImage: (member['imagemMembro'] != null && member['imagemMembro'] is String)
                                    ? NetworkImage(member['imagemMembro']) // Usa a URL pública
                                    : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
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
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone_iphone_rounded,
                                          color: const Color(0xFFB5B5B5),
                                          size: 16,
                                        ),
                                        Text(
                                          member['celular'] ?? 'Telefone não disponível',
                                          style: const TextStyle(),
                                        ),
                                      ],
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
