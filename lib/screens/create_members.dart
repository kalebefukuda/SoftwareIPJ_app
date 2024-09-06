import 'package:flutter/material.dart';

class CreateMembersScreen extends StatelessWidget {
  // Controladores para cada campo de texto
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

  CreateMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Membros'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Informações Pessoais'),
            buildTextField('Nome Completo', fullNameController),
            buildTextField('Nome do Pai', fatherNameController),
            buildTextField('Nome da Mãe', motherNameController),
            buildTextField('Data de Nascimento', dobController),
            buildTextField('Telefone', phoneController),
            buildTextField('Celular', mobileController),
            buildTextField('Email', emailController),
            buildTextField('Endereço', addressController),
            buildTextField('Complemento', complementController),
            buildTextField('CEP', cepController),
            buildTextField('Bairro', districtController),
            buildTextField('Localização Atual', currentLocationController),
            buildTextField('Local de Nascimento', birthPlaceController),
            buildTextField('Profissão', professionController),
            buildTextField('Escolaridade', educationController),
            buildTextField('Religião Procedente', religionController),
            buildTextField('Estado Civil', maritalStatusController),
            buildSectionTitle('Informações de Admissão'),
            buildTextField('Data de Admissão', admissionDateController),
            buildTextField('Forma de Admissão', admissionFormController),
            buildTextField('Oficiante de Admissão', admissionOfficerController),
            buildSectionTitle('Informações de Batismo'),
            buildTextField('Data de Batismo', baptismDateController),
            buildTextField('Oficiante de Batismo', baptismOfficerController),
            buildSectionTitle('Profissão de Fé'),
            buildTextField('Data de Profissão de Fé', faithProfessionDateController),
            buildTextField('Oficiante de Profissão de Fé', faithProfessionOfficerController),
            buildSectionTitle('Informações de Demissão'),
            buildTextField('Data de Demissão', demissionDateController),
            buildTextField('Forma de Demissão', demissionFormController),
            buildTextField('Oficiante de Demissão', demissionOfficerController),
            buildSectionTitle('Outras Informações'),
            buildTextField('Data de Rol Separado', separatedRollDateController),
            buildTextField('Data de Disciplina', disciplineDateController),
            buildTextField('Motivo de Disciplina', disciplineReasonController),
            buildSectionTitle('Eleições'),
            buildTextField('Data de Eleição de Diácono', electionDeaconDateController),
            buildTextField('Data de Reeleição de Diácono', reelectionDeaconDateController),
            buildTextField('Data de Eleição de Presbítero', electionElderDateController),
            buildTextField('Data de Reeleição de Presbítero', reelectionElderDateController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Adicione a lógica de cadastro aqui
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
