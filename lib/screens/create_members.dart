import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io'; // Para lidar com o arquivo de imagem selecionado
import 'package:image_picker/image_picker.dart'; // Pacote para selecionar a imagem
import '../utils/constants/text_font.dart';
import '../utils/constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/local.dart'; // Importe o widget personalizado


class CreateMembersScreen extends StatefulWidget {
  const CreateMembersScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateMembersScreenState createState() => _CreateMembersScreenState();
}

class _CreateMembersScreenState extends State<CreateMembersScreen> {
  // Controladores para cada campo de texto
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController admissionDateController = TextEditingController();
  final TextEditingController admissionFormController = TextEditingController();
  final TextEditingController admissionOfficerController = TextEditingController();
  final TextEditingController baptismDateController = TextEditingController();
  final TextEditingController baptismOfficerController = TextEditingController();
  final TextEditingController faithProfessionDateController = TextEditingController();
  final TextEditingController faithProfessionOfficerController = TextEditingController();
  final TextEditingController demissionDateController = TextEditingController();
  final TextEditingController demissionFormController = TextEditingController();
  final TextEditingController demissionOfficerController = TextEditingController();
  final TextEditingController separatedRollDateController = TextEditingController();
  final TextEditingController disciplineDateController = TextEditingController();
  final TextEditingController disciplineReasonController = TextEditingController();
  final TextEditingController electionDeaconDateController = TextEditingController();
  final TextEditingController reelectionDeaconDateController = TextEditingController();
  final TextEditingController electionElderDateController = TextEditingController();
  final TextEditingController reelectionElderDateController = TextEditingController();

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
        backgroundColor: Appcolors.green,
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
        title: const Text('Cadastro', style: TextFonts.poppinsMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Adicionando o círculo de foto no início
            MouseRegion(
              cursor: SystemMouseCursors.click, // Define o cursor como 'pointer' ao passar o mouse
              child: GestureDetector(
                onTap: _pickImage, // Função para selecionar a imagem
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: const Color(0xFFE7E7E7),
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
            const SizedBox(height: 10),
            CustomTextField(
              controller: fullNameController,
              hintText: 'Nome Completo',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: fatherNameController,
                    hintText: 'Nome do Pai',
                    obscureText: false,
                  ),
                ),
                const SizedBox(width: 10), // Espaço entre os dois campos
                Expanded(
                  child: CustomTextField(
                    controller: motherNameController,
                    hintText: 'Nome da Mãe',
                    obscureText: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LocalField(
              cityController: cityController,
              stateController: stateController,
              obscureText: false,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: dobController,
              hintText: 'Data de Nascimento',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: phoneController,
              hintText: 'Telefone',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: mobileController,
              hintText: 'Celular',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: addressController,
              hintText: 'Endereço',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: complementController,
              hintText: 'Complemento',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: cepController,
              hintText: 'CEP',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: districtController,
              hintText: 'Bairro',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Salvar',
              onPressed: () {
                // Adicione a lógica de cadastro aqui
              },
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
        style: Theme.of(context).textTheme.titleLarge, // Usa o estilo definido no tema
      ),
    );
  }
}
