import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io'; // Para lidar com o arquivo de imagem selecionado
import 'package:image_picker/image_picker.dart'; // Pacote para selecionar a imagem
import '../utils/constants/text_font.dart';
import '../utils/constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/local.dart'; // Importe o widget personalizado
import '../widgets/custom_drop_down.dart'; // Campo de dropdown

class CreateMembersScreen extends StatefulWidget {
  const CreateMembersScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateMembersScreenState createState() => _CreateMembersScreenState();
}

class _CreateMembersScreenState extends State<CreateMembersScreen> {
  // Controladores para cada campo de texto
  final TextEditingController nomeCompletoController = TextEditingController();
  final TextEditingController comunganteController = TextEditingController();
  final TextEditingController numeroRolController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController cidadeNascimentoController = TextEditingController();
  final TextEditingController estadoNascimentoController = TextEditingController();
  final TextEditingController nomePaiontroller = TextEditingController();
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

  // Função para pegar a imagem da galeria
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Atualiza o estado com a imagem selecionada
      });
    }
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
        title: Text(
          'Cadastro',
          style: Theme.of(context).textTheme.titleLarge, // Usa o estilo do tema para o AppBar
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta o tamanho para que o conteúdo não se expanda indefinidamente
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Adicionando o círculo de foto no início
            MouseRegion(
              cursor: SystemMouseCursors.click, // Define o cursor como 'pointer' ao passar o mouse
              child: GestureDetector(
                onTap: _pickImage, // Função para selecionar a imagem
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/user-round.svg',
                              height: 80,
                              width: 80,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Insira sua foto',
                              style: TextFonts.poppinsGreenMedium,
                            ),
                          ],
                        )
                      : ClipOval(
                          child: Image.file(
                            _selectedImage!,
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            buildSectionTitle(context, 'Informações Pessoais'), // Usa o estilo do tema
            const SizedBox(height: 20),
            CustomTextField(
              controller: nomeCompletoController,
              hintText: 'Nome Completo',
              obscureText: false,
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
                  child: CustomTextField(
                    controller: dataNascimentoController,
                    hintText: 'Data de nascimento',
                    obscureText: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            LocalField(
              cityController: cidadeNascimentoController,
              stateController: estadoNascimentoController,
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: nomePaiontroller,
              hintText: 'Nome do Pai',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: nomeMaeController,
              hintText: 'Nome da Mãe',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: escolaridadeController,
              hintText: 'Escolaridade',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: profissaoController,
              hintText: 'Profissão',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              hintText: 'E-mail',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: telefoneController,
                    hintText: 'Telefone',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  child: CustomTextField(
                    controller: celularController,
                    hintText: 'Celular',
                    obscureText: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            buildSectionTitle(context, 'Localização Atual'), // Usa o estilo do tema
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: cepController,
                    hintText: 'CEP',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  child: CustomTextField(
                    controller: bairroController,
                    hintText: 'Bairro',
                    obscureText: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: enderecotController,
              hintText: 'Endereço',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: complementoController,
              hintText: 'Complemento',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            LocalField(
              cityController: cidadeAtualController,
              stateController: estadoAtualController,
              obscureText: false,
            ),
            const SizedBox(height: 30),
            buildSectionTitle(context, 'Outras informações'),
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
            buildSectionTitle(context, 'Batismo'),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CustomTextField(
                    controller: dataBatismoController,
                    hintText: 'Data',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  flex: 2,
                  child: CustomTextField(
                    controller: oficianteBatismoController,
                    hintText: 'Oficiante',
                    obscureText: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            buildSectionTitle(context, 'Profissão de Fé'),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CustomTextField(
                    controller: dataProfissaoController,
                    hintText: 'Data',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  flex: 2,
                  child: CustomTextField(
                    controller: oficianteProfissaoController,
                    hintText: 'Oficiante',
                    obscureText: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            buildSectionTitle(context, 'Admissão'),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CustomTextField(
                    controller: dataAdmissaoController,
                    hintText: 'Data',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  flex: 2,
                  child: CustomTextField(
                    controller: ataAdmissaoController,
                    hintText: 'Ata',
                    obscureText: false,
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
            buildSectionTitle(context, 'Demissão'),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CustomTextField(
                    controller: dataDemissaoController,
                    hintText: 'Data',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  flex: 2,
                  child: CustomTextField(
                    controller: ataDemissaoController,
                    hintText: 'Ata',
                    obscureText: false,
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
            buildSectionTitle(context, 'Rol Separado'),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: dataRolSeparadoController,
                    hintText: 'Data',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  child: CustomTextField(
                    controller: ataRolSeparadoController,
                    hintText: 'Ata',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  child: CustomTextField(
                    controller: casamentoRolSeparadoController,
                    hintText: 'Casamento',
                    obscureText: false,
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
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  child: CustomTextField(
                    controller: ataDiscRolSeparadoController,
                    hintText: 'Ata Disc.',
                    obscureText: false,
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
            buildSectionTitle(context, 'Eleições Diácono'),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: dataDiacController,
                    hintText: 'Data',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  child: CustomTextField(
                    controller: reeleitoDiac1Controller,
                    hintText: 'Reeleito em',
                    obscureText: false,
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
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  child: CustomTextField(
                    controller: reeleitoDiac3Controller,
                    hintText: 'Reeleito em',
                    obscureText: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            buildSectionTitle(context, 'Eleições Presbítero'),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: dataPresbController,
                    hintText: 'Data',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  child: CustomTextField(
                    controller: reeleitoPresb1Controller,
                    hintText: 'Reeleito em',
                    obscureText: false,
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
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os dois campos
                Flexible(
                  child: CustomTextField(
                    controller: reeleitoPresb3Controller,
                    hintText: 'Reeleito em',
                    obscureText: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Salvar',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
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
