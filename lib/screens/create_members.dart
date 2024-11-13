import '../app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io'; // Para lidar com o arquivo de imagem selecionado
import 'package:image_picker/image_picker.dart'; // Pacote para selecionar a imagem
import '../utils/constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/local.dart'; // Importe o widget personalizado
import '../widgets/custom_drop_down.dart'; // Campo de dropdown
import '../widgets/sidebar.dart'; // Adiciona a sidebar
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../widgets/custom_banner.dart';
import '../services/member_service.dart';
import '../screens/members.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Importe o Firebase Storage

class CreateMembersScreen extends StatefulWidget {
  // final Function(bool) onThemeToggle;
  final Map<String, dynamic>? memberData; // Dados do membro, se for uma edição
  final Function(ThemeModeOptions) onThemeToggle;
  final ValueNotifier<ThemeModeOptions> themeModeNotifier;

  const CreateMembersScreen({
    super.key,
    required this.onThemeToggle,
    this.memberData,
    required this.themeModeNotifier,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CreateMembersScreenState createState() => _CreateMembersScreenState();
}

class _CreateMembersScreenState extends State<CreateMembersScreen> {
  int currentIndex = 1;
  bool _isBannerVisible = false; // Controla a visibilidade do banner
  String _bannerMessage = ''; // Armazena a mensagem do banner
  Color _bannerColor = Colors.green; // Armazena a cor do banner

  final MemberService _memberService = MemberService();

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
  File? _selectedImage;
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

  Future<bool> _saveMember() async {
    try {
      // Se houver uma imagem selecionada, faça o upload para o Firebase Storage
      String? imageUrl;
      if (_selectedImage != null) {
        // Crie uma referência ao Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('membros').child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Faça o upload do arquivo
        final uploadTask = storageRef.putFile(_selectedImage!);

        // Espere o upload ser concluído e pegue a URL da imagem
        final snapshot = await uploadTask.whenComplete(() {});
        imageUrl = await snapshot.ref.getDownloadURL();
      }
      // Cria o mapa com os dados do membro
      Map<String, dynamic> memberData = {
        'nomeCompleto': nomeCompletoController.text,
        'comungante': comunganteController.text,
        'numeroRol': int.tryParse(numeroRolController.text) ?? 0,
        'dataNascimento': dataNascimentoController.text,
        'sexo': sexoController.text,
        'cidadeNascimento': cidadeNascimentoController.text,
        'estadoNascimento': estadoNascimentoController.text,
        'nomePai': nomePaiController.text,
        'nomeMae': nomeMaeController.text,
        'escolaridade': escolaridadeController.text,
        'profissao': profissaoController.text,
        'email': emailController.text,
        'telefone': telefoneController.text,
        'celular': celularController.text,
        'cep': cepController.text,
        'bairro': bairroController.text,
        'endereco': enderecotController.text,
        'complemento': complementoController.text,
        'cidadeAtual': cidadeAtualController.text,
        'estadoAtual': estadoAtualController.text,
        'residencia': residenciaController.text,
        'estadoCivil': estadoCivilController.text,
        'religiao': religiaoController.text,
        'dataBatismo': dataBatismoController.text,
        'oficianteBatismo': oficianteBatismoController.text,
        'dataProfissao': dataProfissaoController.text,
        'oficianteProfissao': oficianteProfissaoController.text,
        'dataAdmissao': dataAdmissaoController.text,
        'ataAdmissao': ataAdmissaoController.text,
        'formaAdmissao': formaAdmissaoController.text,
        'dataDemissao': dataDemissaoController.text,
        'ataDemissao': ataDemissaoController.text,
        'formaDemissao': formaDemissaoController.text,
        'dataRolSeparado': dataRolSeparadoController.text,
        'ataRolSeparado': ataRolSeparadoController.text,
        'casamentoRolSeparado': casamentoRolSeparadoController.text,
        'dataDiscRolSeparado': dataDiscRolSeparadoController.text,
        'ataDiscRolSeparado': ataDiscRolSeparadoController.text,
        'discRolSeparado': discRolSeparadoController.text,
        'dataDiac': dataDiacController.text,
        'reeleitoDiac1': reeleitoDiac1Controller.text,
        'reeleitoDiac2': reeleitoDiac2Controller.text,
        'reeleitoDiac3': reeleitoDiac3Controller.text,
        'dataPresb': dataPresbController.text,
        'reeleitoPresb1': reeleitoPresb1Controller.text,
        'reeleitoPresb2': reeleitoPresb2Controller.text,
        'reeleitoPresb3': reeleitoPresb3Controller.text,
        'imageUrl': imageUrl, // Adicione a URL da imagem
      };

      // Chama o serviço para adicionar o membro
      if (widget.memberData != null) {
        // Atualize o membro existente
        await _memberService.updateMember(widget.memberData!['id'], memberData);
      } else {
        // Crie um novo membro
        await _memberService.addMember(memberData);
      }

      _showBanner('Membro salvo com sucesso!', const Color(0xFF015B40));
      return true; // Retorna true se o membro for salvo com sucesso
    } catch (e) {
      _showBanner('Erro ao salvar membro', const Color.fromARGB(255, 154, 27, 27));
      return false; // Retorna false se ocorrer um erro
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

  void _showBanner(String message, Color color) {
    setState(() {
      _bannerMessage = message; // Define a mensagem do banner
      _bannerColor = color; // Define a cor do banner
      _isBannerVisible = true;
    });
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
                      onTap: _pickImage, // Função para selecionar a imagem
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                        child: _selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/user-round.svg',
                                    height: 50,
                                    width: 50,
                                    color: Theme.of(context).iconTheme.color, // Usa a cor do iconTheme conforme o tema
                                  ),
                                ],
                              )
                            : ClipOval(
                                child: Image.file(
                                  _selectedImage!,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Informações Pessoais')),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomCapitalizedTextField(
                      controller: nomeCompletoController,
                      hintText: 'Nome Completo',
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDropdown(
                          labelText: 'Comungante',
                          controller: comunganteController,
                          items: const [
                            'SIM',
                            'NÃO'
                          ],
                          hintText: 'Comungante',
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: numeroRolController,
                          hintText: 'Numero de Rol',
                          obscureText: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number, // Apenas números
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3), // Limita a 3 caracteres
                          ], // Filtra apenas números
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDropdown(
                          labelText: 'Sexo',
                          controller: sexoController,
                          items: const [
                            'Masculino',
                            'Feminino'
                          ],
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomDateTextField(controller: dataNascimentoController, hintText: 'Data de nascimento'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LocalField(
                    cityController: cidadeNascimentoController,
                    stateController: estadoNascimentoController,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    onCityChanged: (value) {
                      final capitalized = capitalize(value);
                      if (capitalized != value) {
                        cidadeNascimentoController.value = cidadeNascimentoController.value.copyWith(
                          text: capitalized,
                          selection: TextSelection.collapsed(offset: capitalized.length),
                        );
                      }
                    },
                    cityLabelText: 'Cidade Nasc.', // Personaliza o rótulo
                    stateLabelText: 'UF Nasc.', // Personaliza o rótulo
                  ),
                  const SizedBox(height: 20),
                  CustomCapitalizedTextField(
                    controller: nomePaiController,
                    hintText: 'Nome do Pai',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  CustomCapitalizedTextField(
                    controller: nomeMaeController,
                    hintText: 'Nome da Mãe',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  CustomCapitalizedTextField(
                    controller: escolaridadeController,
                    hintText: 'Escolaridade',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  CustomCapitalizedTextField(
                    controller: profissaoController,
                    hintText: 'Profissão',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'E-mail',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress, // Teclado de email
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty || !isValidEmail(value)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          controller: telefoneController,
                          hintText: 'Telefone',
                          obscureText: false,
                          keyboardType: TextInputType.phone, // Teclado de telefone
                          inputFormatters: [
                            PhoneInputFormatter(), // Utiliza o formatter personalizado
                          ],
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: celularController,
                          hintText: 'Celular',
                          obscureText: false,
                          keyboardType: TextInputType.phone, // Teclado de telefone
                          inputFormatters: [
                            PhoneInputFormatter(), // Utiliza o formatter personalizado
                          ],
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
                        child: CustomCepTextField(
                          controller: cepController,
                          textInputAction: TextInputAction.next,
                          onEnderecoEncontrado: (endereco) {
                            setState(() {
                              bairroController.text = endereco['bairro'] ?? '';
                              enderecotController.text = endereco['logradouro'] ?? '';
                              cidadeAtualController.text = endereco['localidade'] ?? '';
                              estadoAtualController.text = endereco['uf'] ?? '';
                            });
                          },
                          onCepNaoEncontrado: () => _showBanner('CEP não encontrado.', const Color.fromARGB(255, 93, 14, 14)),
                          onErro: () => _showBanner('Erro de conexão. Verifique sua internet.', const Color.fromARGB(255, 93, 14, 14)),
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: bairroController,
                          hintText: 'Bairro',
                          obscureText: false,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: enderecotController,
                    hintText: 'Endereço',
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: complementoController,
                    hintText: 'Complemento',
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  LocalField(
                    cityController: cidadeAtualController,
                    stateController: estadoAtualController,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    onCityChanged: (value) {
                      final capitalized = capitalize(value);
                      if (capitalized != value) {
                        cidadeAtualController.value = cidadeAtualController.value.copyWith(
                          text: capitalized,
                          selection: TextSelection.collapsed(offset: capitalized.length),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Outras informações')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDropdown(
                          labelText: 'Local Residência',
                          controller: residenciaController,
                          items: const [
                            'Sede',
                            'Fora'
                          ],
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomDropdown(
                          labelText: 'Estado Civil',
                          controller: estadoCivilController,
                          items: const [
                            'Solteiro(a)',
                            'Casado(a)',
                            'Viuvo(a)',
                            'Divorciado(a)',
                            'Outros'
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomDropdown(
                      labelText: 'Religião Procedente',
                      items: const [
                        'Reformada',
                        'Pentecostal',
                        'Neo-Pentecostal',
                        'Católica Romana',
                        'Espiritismos e Assemelhados',
                        'Outros'
                      ],
                      controller: religiaoController),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Batismo')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CustomDateTextField(
                          controller: dataBatismoController,
                          hintText: 'Data',
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        flex: 2,
                        child: CustomCapitalizedTextField(
                          controller: oficianteBatismoController,
                          hintText: 'Oficiante',
                          textInputAction: TextInputAction.next,
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
                        child: CustomDateTextField(controller: dataProfissaoController, hintText: 'Data'),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        flex: 2,
                        child: CustomCapitalizedTextField(
                          controller: oficianteProfissaoController,
                          hintText: 'Oficiante',
                          textInputAction: TextInputAction.next,
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
                        child: CustomDateTextField(controller: dataAdmissaoController, hintText: 'Data'),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          controller: ataAdmissaoController,
                          hintText: 'Ata',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: CustomDropdown(
                      labelText: 'Forma',
                      controller: formaAdmissaoController,
                      items: const [
                        'Transferência',
                        'Batismo',
                        'Profissão de Fé',
                        'Batismo e Profissão de Fé',
                        'Jurisdição a pedido',
                        'Jurisdição Ex-Officio',
                        'Restauração',
                        'Designação e Presbitério'
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Demissão')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CustomDateTextField(controller: dataDemissaoController, hintText: 'Data'),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          controller: ataDemissaoController,
                          hintText: 'Ata',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: CustomDropdown(
                      labelText: 'Forma',
                      controller: formaDemissaoController,
                      items: const [
                        'Transferência',
                        'Batismo',
                        'Profissão de Fé',
                        'Batismo e Profissão de Fé',
                        'Jurisdição a pedido',
                        'Jurisdição Ex-Officio',
                        'Restauração',
                        'Designação e Presbitério'
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Rol Separado')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDateTextField(controller: dataRolSeparadoController, hintText: 'Data'),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: ataRolSeparadoController,
                          hintText: 'Ata',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomDateTextField(
                          controller: casamentoRolSeparadoController,
                          hintText: 'Casamento',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDateTextField(controller: dataDiscRolSeparadoController, hintText: 'Data Disc.'),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: ataDiscRolSeparadoController,
                          hintText: 'Ata Disc.',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomTextField(
                          controller: discRolSeparadoController,
                          hintText: 'Disciplina',
                          obscureText: false,
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
                        child: CustomDateTextField(controller: dataDiacController, hintText: 'Data'),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomDateTextField(controller: reeleitoDiac1Controller, hintText: 'Reeleito em'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDateTextField(controller: reeleitoDiac2Controller, hintText: 'Reeleito em'),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomDateTextField(controller: reeleitoDiac3Controller, hintText: 'Reeleito em'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(child: buildSectionTitle(context, 'Eleições Presbitero')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDateTextField(controller: dataPresbController, hintText: 'Data'),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomDateTextField(controller: reeleitoPresb1Controller, hintText: 'Reeleito em'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDateTextField(controller: reeleitoPresb2Controller, hintText: 'Reeleito em'),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomDateTextField(controller: reeleitoPresb3Controller, hintText: 'Reeleito em'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                      child: CustomButton(
                    text: 'Salvar',
                    onPressed: () async {
                      try {
                        // Use o bool retornado por _saveMember()
                        bool success = await _saveMember();

                        if (success) {
                          // Se o membro foi salvo com sucesso
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Members(
                                onThemeToggle: widget.onThemeToggle,
                                themeModeNotifier: widget.themeModeNotifier,
                                successMessage: 'Membro salvo com sucesso!', // Passe a mensagem
                              ),
                            ),
                          );
                        } else {
                          // Se a função _saveMember indicar falha
                          _showBanner('Erro ao salvar membro', const Color.fromARGB(255, 154, 27, 27));
                        }
                      } catch (e) {
                        // Em caso de exceção
                        _showBanner('Erro ao salvar membro', const Color.fromARGB(255, 154, 27, 27));
                        // ignore: avoid_print
                        print(e);
                      }
                    },
                  )),
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
  // Função para pegar a imagem da galeria
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        // Faz o upload da imagem para o Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('user_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        final uploadTask = storageRef.putFile(_selectedImage!);
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();

        print("Imagem carregada com sucesso: $imageUrl");
        // Aqui, você pode salvar `imageUrl` no Firestore para armazenar o link da imagem
      } else {
        _showBanner('Seleção de imagem cancelada.', const Color.fromARGB(255, 142, 85, 0));
      }
    } catch (e) {
      _showBanner('Erro ao selecionar ou fazer upload da imagem: $e', const Color.fromARGB(255, 154, 27, 27));
      print('Erro ao selecionar ou fazer upload da imagem: $e');
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

// Função para capitalizar cada palavra:
String capitalize(String input) {
  return input.split(' ').map((str) => str.isNotEmpty ? str[0].toUpperCase() + str.substring(1).toLowerCase() : '').join(' ');
}

// Função para validar o email:
bool isValidEmail(String email) {
  final RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return regex.hasMatch(email);
}

// Função para criar o formatter de telefone.
class PhoneInputFormatter extends MaskedInputFormatter {
  PhoneInputFormatter() : super('(##) #####-####');

  // Função para remover os caracteres especiais e salvar apenas números
  static String removeFormatting(String input) {
    return toNumericString(input);
  }
}
