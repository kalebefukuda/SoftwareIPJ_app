import 'package:softwareipj/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart'; // Pacote para selecionar a imagem
import '../utils/constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/sidebar.dart'; // Adiciona a sidebar
import '../widgets/custom_banner.dart';
import 'create_members.dart';

class ViewMemberScreen extends StatefulWidget {
  final ValueNotifier<ThemeModeOptions> themeModeNotifier;
  final Function(ThemeModeOptions) onThemeToggle;
  final Map<String, dynamic>? memberData; // Dados do membro, se for uma edição
  final bool isReadOnly; // Adicione esta propriedade

  const ViewMemberScreen({
    super.key,
    required this.onThemeToggle,
    this.memberData,
    this.isReadOnly = true,
    required this.themeModeNotifier,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ViewMemberScreenState createState() => _ViewMemberScreenState();
}

class _ViewMemberScreenState extends State<ViewMemberScreen> {
  int currentIndex = 2;
  bool _isBannerVisible = false; // Controla a visibilidade do banner
  final String _bannerMessage = ''; // Armazena a mensagem do banner
  final Color _bannerColor = Colors.green; // Armazena a cor do banner
  final TextEditingController nomeCompletoController = TextEditingController();
  final TextEditingController comunganteController = TextEditingController();
  final TextEditingController numeroRolController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController cidadeNascimentoController = TextEditingController();
  final TextEditingController estadoNascimentoController = TextEditingController();
  final TextEditingController nomePaiController = TextEditingController();
  final TextEditingController nomeMaeController = TextEditingController();
  final TextEditingController escolaridadeController = TextEditingController();
  final TextEditingController profissaoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController enderecotController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController cidadeAtualController = TextEditingController();
  final TextEditingController estadoAtualController = TextEditingController();
  final TextEditingController residenciaController = TextEditingController();
  final TextEditingController estadoCivilController = TextEditingController();
  final TextEditingController religiaoController = TextEditingController();
  final TextEditingController dataBatismoController = TextEditingController();
  final TextEditingController oficianteBatismoController = TextEditingController();
  final TextEditingController dataProfissaoController = TextEditingController();
  final TextEditingController oficianteProfissaoController = TextEditingController();
  final TextEditingController dataAdmissaoController = TextEditingController();
  final TextEditingController ataAdmissaoController = TextEditingController();
  final TextEditingController formaAdmissaoController = TextEditingController();
  final TextEditingController dataDemissaoController = TextEditingController();
  final TextEditingController ataDemissaoController = TextEditingController();
  final TextEditingController formaDemissaoController = TextEditingController();
  final TextEditingController dataRolSeparadoController = TextEditingController();
  final TextEditingController ataRolSeparadoController = TextEditingController();
  final TextEditingController casamentoRolSeparadoController = TextEditingController();
  final TextEditingController dataDiscRolSeparadoController = TextEditingController();
  final TextEditingController ataDiscRolSeparadoController = TextEditingController();
  final TextEditingController discRolSeparadoController = TextEditingController();
  final TextEditingController dataDiacController = TextEditingController();
  final TextEditingController reeleitoDiac1Controller = TextEditingController();
  final TextEditingController reeleitoDiac2Controller = TextEditingController();
  final TextEditingController reeleitoDiac3Controller = TextEditingController();
  final TextEditingController dataPresbController = TextEditingController();
  final TextEditingController reeleitoPresb1Controller = TextEditingController();
  final TextEditingController reeleitoPresb2Controller = TextEditingController();
  final TextEditingController reeleitoPresb3Controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Se houver memberData, preencha os controladores com os dados do membro
    if (widget.memberData != null) {
      nomeCompletoController.text = widget.memberData!['nomeCompleto'] ?? '';
      comunganteController.text = widget.memberData!['comungante'] ?? '';
      numeroRolController.text = widget.memberData!['numeroRol']?.toString() ?? '';
      dataNascimentoController.text = widget.memberData!['dataNascimento'] ?? '';
      sexoController.text = widget.memberData!['sexo'] ?? '';
      cidadeNascimentoController.text = widget.memberData!['cidadeNascimento'] ?? '';
      estadoNascimentoController.text = widget.memberData!['estadoNascimento'] ?? '';
      nomePaiController.text = widget.memberData!['nomePai'] ?? '';
      nomeMaeController.text = widget.memberData!['nomeMae'] ?? '';
      escolaridadeController.text = widget.memberData!['escolaridade'] ?? '';
      profissaoController.text = widget.memberData!['profissao'] ?? '';
      emailController.text = widget.memberData!['email'] ?? '';
      telefoneController.text = widget.memberData!['telefone'] ?? '';
      celularController.text = widget.memberData!['celular'] ?? '';
      cepController.text = widget.memberData!['cep'] ?? '';
      bairroController.text = widget.memberData!['bairro'] ?? '';
      enderecotController.text = widget.memberData!['endereco'] ?? '';
      complementoController.text = widget.memberData!['complemento'] ?? '';
      cidadeAtualController.text = widget.memberData!['cidadeAtual'] ?? '';
      estadoAtualController.text = widget.memberData!['estadoAtual'] ?? '';
      residenciaController.text = widget.memberData!['residencia'] ?? '';
      estadoCivilController.text = widget.memberData!['estadoCivil'] ?? '';
      religiaoController.text = widget.memberData!['religiao'] ?? '';
      dataBatismoController.text = widget.memberData!['dataBatismo'] ?? '';
      oficianteBatismoController.text = widget.memberData!['oficianteBatismo'] ?? '';
      dataProfissaoController.text = widget.memberData!['dataProfissao'] ?? '';
      oficianteProfissaoController.text = widget.memberData!['oficianteProfissao'] ?? '';
      dataAdmissaoController.text = widget.memberData!['dataAdmissao'] ?? '';
      ataAdmissaoController.text = widget.memberData!['ataAdmissao'] ?? '';
      formaAdmissaoController.text = widget.memberData!['formaAdmissao'] ?? '';
      dataDemissaoController.text = widget.memberData!['dataDemissao'] ?? '';
      ataDemissaoController.text = widget.memberData!['ataDemissao'] ?? '';
      formaDemissaoController.text = widget.memberData!['formaDemissao'] ?? '';
      dataRolSeparadoController.text = widget.memberData!['dataRolSeparado'] ?? '';
      ataRolSeparadoController.text = widget.memberData!['ataRolSeparado'] ?? '';
      casamentoRolSeparadoController.text = widget.memberData!['casamentoRolSeparado'] ?? '';
      dataDiscRolSeparadoController.text = widget.memberData!['dataDiscRolSeparado'] ?? '';
      ataDiscRolSeparadoController.text = widget.memberData!['ataDiscRolSeparado'] ?? '';
      discRolSeparadoController.text = widget.memberData!['discRolSeparado'] ?? '';
      dataDiacController.text = widget.memberData!['dataDiac'] ?? '';
      reeleitoDiac1Controller.text = widget.memberData!['reeleitoDiac1'] ?? '';
      reeleitoDiac2Controller.text = widget.memberData!['reeleitoDiac2'] ?? '';
      reeleitoDiac3Controller.text = widget.memberData!['reeleitoDiac3'] ?? '';
      dataPresbController.text = widget.memberData!['dataPresb'] ?? '';
      reeleitoPresb1Controller.text = widget.memberData!['reeleitoPresb1'] ?? '';
      reeleitoPresb2Controller.text = widget.memberData!['reeleitoPresb2'] ?? '';
      reeleitoPresb3Controller.text = widget.memberData!['reeleitoPresb3'] ?? '';
    }
  }

  @override
  void dispose() {
    cepController.dispose();
    bairroController.dispose();
    enderecotController.dispose();
    complementoController.dispose();
    cidadeAtualController.dispose();
    estadoAtualController.dispose();
    super.dispose();
  }

  // Definindo a função _hideBanner
  void _hideBanner() {
    setState(() {
      _isBannerVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Esconde o teclado ao tocar fora dos campos
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          scrolledUnderElevation: 0,
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
          title: Text(
            'Cadastro',
            style: Theme.of(context).textTheme.titleLarge, // Usa o estilo do tema para o AppBar
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 0.0), // Adiciona um padding inferior maior
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  // Adicionando o círculo de foto no início
                  MouseRegion(
                    cursor: SystemMouseCursors.click, // Define o cursor como 'pointer' ao passar o mouse
                    child: GestureDetector(
                      onTap: widget.isReadOnly ? null : _pickImage, // Desabilita a seleção de imagem se for apenas leitura
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                        child: ClipOval(
                          child: (widget.memberData != null && (widget.memberData?['imagemMembro'] ?? '').isNotEmpty)
                              ? Image.network(
                                  widget.memberData?['imagemMembro'] ?? '',
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
                                    'assets/images/user-round.svg',
                                    height: 50,
                                    width: 50,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                )
                              : SvgPicture.asset(
                                  'assets/images/user-round.svg',
                                  height: 50,
                                  width: 50,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Informações Pessoais')),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomTextField(
                      controller: nomeCompletoController,
                      hintText: 'Nome Completo',
                      obscureText: false,
                      readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          hintText: 'Comungante',
                          controller: comunganteController,
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: numeroRolController,
                          hintText: 'Numero de Rol',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          hintText: 'Sexo',
                          controller: sexoController,
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: dataNascimentoController,
                          hintText: 'Data de nascimento',
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                          obscureText: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          hintText: 'Cidade Nasc.',
                          controller: cidadeNascimentoController,
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Expanded(
                        flex: 1,
                        child: CustomTextField(
                          hintText: 'UF Nasc.',
                          controller: estadoNascimentoController,
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: nomePaiController,
                    hintText: 'Nome do Pai',
                    obscureText: false,
                    readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: nomeMaeController,
                    hintText: 'Nome da Mãe',
                    obscureText: false,
                    readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: escolaridadeController,
                    hintText: 'Escolaridade',
                    obscureText: false,
                    readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: profissaoController,
                    hintText: 'Profissão',
                    obscureText: false,
                    readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'E-mail',
                    obscureText: false,
                    readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          controller: telefoneController,
                          hintText: 'Telefone',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: celularController,
                          hintText: 'Celular',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Localização Atual')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          controller: cepController,
                          hintText: 'CEP',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: bairroController,
                          hintText: 'Bairro',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: enderecotController,
                    hintText: 'Endereço',
                    obscureText: false,
                    readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: complementoController,
                    hintText: 'Complemento',
                    obscureText: false,
                    readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          hintText: 'Cidade',
                          controller: cidadeAtualController,
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Expanded(
                        flex: 1,
                        child: CustomTextField(
                          hintText: 'UF',
                          controller: estadoAtualController,
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Outras informações')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          hintText: 'Local Residência',
                          controller: residenciaController,
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          hintText: 'Estado Civil',
                          controller: estadoCivilController,
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                      hintText: 'Religião Procedente',
                      obscureText: false,
                      readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                      controller: religiaoController),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Batismo')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CustomTextField(
                          controller: dataBatismoController,
                          hintText: 'Data',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          controller: oficianteBatismoController,
                          hintText: 'Oficiante',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Profissão de Fé')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CustomTextField(
                          controller: dataProfissaoController,
                          hintText: 'Data',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          controller: oficianteProfissaoController,
                          hintText: 'Oficiante',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Admissão')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CustomTextField(
                          controller: dataAdmissaoController,
                          hintText: 'Data',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          controller: ataAdmissaoController,
                          hintText: 'Ata',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: CustomTextField(
                      hintText: 'Forma',
                      controller: formaAdmissaoController,
                      obscureText: false,
                      readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Demissão')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CustomTextField(
                          controller: dataDemissaoController,
                          hintText: 'Data',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          controller: ataDemissaoController,
                          hintText: 'Ata',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: CustomTextField(
                      hintText: 'Forma',
                      controller: formaDemissaoController,
                      obscureText: false,
                      readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Rol Separado')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          controller: dataRolSeparadoController,
                          hintText: 'Data',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: CustomTextField(
                          controller: ataRolSeparadoController,
                          hintText: 'Ata',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: casamentoRolSeparadoController,
                          hintText: 'Casamento',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          controller: dataDiscRolSeparadoController,
                          hintText: 'Data Disc.',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: ataDiscRolSeparadoController,
                          hintText: 'Ata Disc.',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: discRolSeparadoController,
                          hintText: 'Disciplina',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Eleições Diácono')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          controller: dataDiacController,
                          hintText: 'Data',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: CustomTextField(
                          controller: reeleitoDiac1Controller,
                          hintText: 'Reeleito em',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          controller: reeleitoDiac2Controller,
                          hintText: 'Reeleito em',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: CustomTextField(
                          controller: reeleitoDiac3Controller,
                          hintText: 'Reeleito em',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Eleições Presbitero')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          controller: dataPresbController,
                          hintText: 'Data',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: CustomTextField(
                          controller: reeleitoPresb1Controller,
                          hintText: 'Reeleito em',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          controller: reeleitoPresb2Controller,
                          hintText: 'Reeleito em',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: CustomTextField(
                          controller: reeleitoPresb3Controller,
                          hintText: 'Reeleito em',
                          obscureText: false,
                          readOnly: widget.isReadOnly, // Use a flag para habilitar/desabilitar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: CustomButton(
                      text: 'Editar',
                      onPressed: () {
                        // Navegue para a tela de edição do membro com os dados atuais do membro
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateMembersScreen(
                              memberData: widget.memberData, // Passe os dados do membro para a tela de edição
                              onThemeToggle: widget.onThemeToggle, // Passe a função de alternar tema
                              themeModeNotifier: widget.themeModeNotifier, // Passe o ValueNotifier para o modo escuro
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 100), //Esse Widget é para dar uma espaçamento final para a sidebar não sobrepor os itens da tela
                ],
              ),
            ),
            BottomSidebar(currentIndex: currentIndex, onTabTapped: onTabTapped, onThemeToggle: widget.onThemeToggle, themeModeNotifier: widget.themeModeNotifier, isKeyboardVisible: MediaQuery.of(context).viewInsets.bottom != 0),
            if (_isBannerVisible)
              Positioned(
                top: 10, // Posiciona o banner próximo ao topo
                right: 0, // Alinha o banner à direita
                child: CustomBanner(
                  message: _bannerMessage, // Usa a mensagem do estado
                  backgroundColor: _bannerColor, // Usa a cor do estado
                  onDismissed: _hideBanner, // Callback para ocultar o banner após a animação,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

/* ----------------------FUNÇÕES----------------- */

  // Função para pegar a imagem da galeria
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
// Atualiza o estado com a imagem selecionada
      });
    }
  }

  // Função que utiliza o estilo do tema para os títulos
  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium, // Usa o estilo definido no tema
      ),
    );
  }
}
