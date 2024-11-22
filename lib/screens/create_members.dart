// ignore_for_file: unused_local_variable
import '../app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../utils/constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/local.dart';
import '../widgets/custom_drop_down.dart';
import '../widgets/sidebar.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../widgets/custom_banner.dart';
import '../screens/members.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateMembersScreen extends StatefulWidget {
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

  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>(); // Adicionei o GlobalKey para o formulário
  final Map<String, bool> _fieldErrors = {}; // Mapeia campos com erro para borda vermelha

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

  Future<String?> _uploadImageToSupabase(File imageFile) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$timestamp.jpg';

      print('Iniciando upload... Arquivo: $fileName');
      print('Tamanho do arquivo: ${imageFile.lengthSync()} bytes');

      final response = await Supabase.instance.client.storage.from('membros_storage').upload(fileName, imageFile);

      print('Resposta do Supabase: $response');

      if (response.isEmpty) {
        print('Erro ao fazer upload: Resposta vazia');
        return null;
      }

      final publicUrl = Supabase.instance.client.storage.from('membros_storage').getPublicUrl(fileName);
      print('URL pública gerada: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  // Validação dos campos
  Future<void> _validateFields() async {
    setState(() {
      _fieldErrors.clear();
    });

    // Verifica campos obrigatórios e adiciona ao mapa de erros
    if (nomeCompletoController.text.trim().isEmpty) {
      _fieldErrors['nomeCompleto'] = true;
    }
    if (dataNascimentoController.text.trim().isEmpty) {
      _fieldErrors['dataNascimento'] = true;
    }
    if (numeroRolController.text.trim().isEmpty) {
      _fieldErrors['numeroRol'] = true;
    }
    if (residenciaController.text.trim().isEmpty) {
      _fieldErrors['residenciaLocal'] = true;
    }
    if (celularController.text.trim().isEmpty) {
      _fieldErrors['celular'] = true;
    }
    if (comunganteController.text.trim().isEmpty) {
      _fieldErrors['comungante'] = true;
    }
    if (sexoController.text.trim().isEmpty) {
      _fieldErrors['sexo'] = true;
    }

    // Verifica duplicidade do número de rol
    if (numeroRolController.text.trim().isNotEmpty) {
      bool isDuplicate = await _isNumeroRolDuplicado(numeroRolController.text);
      if (isDuplicate) {
        _fieldErrors['numeroRol'] = true;
      }
    }

    // Após validar, role para o primeiro campo com erro
    if (_fieldErrors.isNotEmpty) {
      _scrollToFirstError();
    }
  }

  void _scrollToFirstError() {
    // Encontra o índice do primeiro erro
    final firstErrorFieldKey = _fieldErrors.keys.first;
    double offset = 0.0;

    // Define a posição de rolagem com base no campo com erro
    if (firstErrorFieldKey == 'nomeCompleto') {
      offset = 100; // Posição aproximada do campo Nome Completo
    } else if (firstErrorFieldKey == 'comungante') {
      offset = 150; // Posição aproximada do campo Comuga te
    } else if (firstErrorFieldKey == 'numeroRol') {
      offset = 150; // Posição aproximada do campo Número de Rol
    } else if (firstErrorFieldKey == 'sexo') {
      offset = 200; // Posição aproximada do campo Sexo
    } else if (firstErrorFieldKey == 'dataNascimento') {
      offset = 200; // Posição aproximada do campo Data
    } else if (firstErrorFieldKey == 'celular') {
      offset = 800; // Posição aproximada do campo ComungCelularante
    } else if (firstErrorFieldKey == 'residenciaLocal') {
      offset = 1350; // Posição aproximada do campo Residencia Local
    }

    // Rola até a posição calculada
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

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
      String? imageUrl;
      final user = Supabase.instance.client.auth.currentUser;

      // Verifica se há uma imagem selecionada
      if (_selectedImage != null) {
        imageUrl = await _uploadImageToSupabase(_selectedImage!);
        if (imageUrl == null) {
          _showBanner('Erro ao fazer upload da imagem.', const Color.fromARGB(255, 154, 27, 27));
          return false; // Retorna falso se o upload falhar
        }
      }

      // Cria o mapa com os dados do membro
      Map<String, dynamic> memberData = {
        'nomeCompleto': nomeCompletoController.text,
        'comungante': comunganteController.text,
        'numeroRol': numeroRolController.text,
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
        'imagemMembro': imageUrl,
      };

      // Verifica se é uma edição ou criação
      if (widget.memberData != null) {
        // É uma edição, então faz update
        final response = await Supabase.instance.client.from('membros').update(memberData).eq('id', widget.memberData!['id']).select();

        if (response.isEmpty) {
          throw Exception('Erro ao atualizar membro no banco de dados');
        }

        _showBanner('Membro atualizado com sucesso!', const Color(0xFF015B40));
      } else {
        // É uma criação, então insere um novo registro
        final response = await Supabase.instance.client.from('membros').insert(memberData).select();

        if (response.isEmpty) {
          throw Exception('Erro ao salvar membro no banco de dados');
        }

        _showBanner('Membro salvo com sucesso!', const Color(0xFF015B40));
      }

      return true;
    } catch (e) {
      _showBanner('Erro ao salvar membro.', const Color.fromARGB(255, 154, 27, 27));
      print("Erro ao salvar membro: $e");
      return false;
    }
  }

  Future<bool> _isNumeroRolDuplicado(String numeroRol) async {
    if (numeroRol.isEmpty) return false;

    try {
      final response = await Supabase.instance.client.from('membros').select('id').eq('numeroRol', numeroRol);

      if (response.isEmpty) {
        return false;
      }

      if (widget.memberData != null) {
        return response.any((data) => data['id'] != widget.memberData!['id']);
      }
      return true;
    } catch (e) {
      print("Erro ao verificar número de rol duplicado: $e");
      return false;
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
    _scrollController.dispose();
    super.dispose();
  }

  void _showBanner(String message, Color color) {
    setState(() {
      _bannerMessage = message; // Define a mensagem do banner
      _bannerColor = color; // Define a cor do banner
      _isBannerVisible = true;
    });
  }

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
          key: _formKey, // Associa a chave do formulário
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 0.0), // Adiciona um padding inferior maior
              child: ListView(
                controller: _scrollController, // Adicione o controlador aqui
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
                        child: ClipOval(
                          child: _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                )
                              : (widget.memberData != null && widget.memberData!['imagemMembro'] != null && widget.memberData!['imagemMembro'].isNotEmpty)
                                  ? Image.network(
                                      widget.memberData!['imagemMembro'],
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
                    child: CustomCapitalizedTextField(
                      controller: nomeCompletoController,
                      hintText: 'Nome Completo',
                      textInputAction: TextInputAction.next,
                      borderColor: _fieldErrors['nomeCompleto'] == true ? Colors.red : null,
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
                          borderColor: _fieldErrors['comungante'] == true ? Colors.red : null,
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
                          ],
                          onChanged: (value) async {
                            // Verifica duplicação ao alterar o valor
                            if (value.isNotEmpty) {
                              bool isDuplicate = await _isNumeroRolDuplicado(value);
                              setState(() {
                                _fieldErrors['numeroRol'] = isDuplicate; // Define o erro em caso de duplicação
                              });
                            } else {
                              setState(() {
                                _fieldErrors['numeroRol'] = true; // Erro se estiver vazio
                              });
                            }
                          },
                          borderColor: _fieldErrors['numeroRol'] == true ? Colors.red : null, // Mostra a borda vermelha em caso de erro
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
                          borderColor: _fieldErrors['sexo'] == true ? Colors.red : null,
                        ),
                      ),
                      const SizedBox(width: 20), // Espaço entre os dois campos
                      Flexible(
                        child: CustomDateTextField(
                          controller: dataNascimentoController,
                          hintText: 'Data de nascimento',
                          borderColor: _fieldErrors['dataNascimento'] == true ? Colors.red : null,
                        ),
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
                          borderColor: _fieldErrors['celular'] == true ? Colors.red : null,
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
                          borderColor: _fieldErrors['residenciaLocal'] == true ? Colors.red : null,
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
                        _validateFields(); // Valida os campos obrigatórios
                        if (_fieldErrors.isEmpty) {
                          bool success = await _saveMember();
                          if (success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Members(
                                  onThemeToggle: widget.onThemeToggle,
                                  themeModeNotifier: widget.themeModeNotifier,
                                  successMessage: 'Membro salvo com sucesso!',
                                ),
                              ),
                            );
                          }
                        } else {
                          _showBanner('Preencha os campos obrigatórios.', Color.fromARGB(255, 154, 27, 27));
                        }
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
                top: 10,
                right: 0,
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
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        _showBanner('Seleção de imagem cancelada.', const Color.fromARGB(255, 142, 85, 0));
      }
    } catch (e) {
      _showBanner('Erro ao selecionar ou fazer upload da imagem: $e', const Color.fromARGB(255, 154, 27, 27));
    }
  }

  // Função que utiliza o estilo do tema para os títulos
  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
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
