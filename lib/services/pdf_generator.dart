import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart'; // Pacote para formatar datas

Future<void> generateBirthdayListPdf() async {
  final pdf = pw.Document();
  List<Map<String, dynamic>> birthdayList = [];

  // Obtenha os dados do Firestore
  final snapshot = await FirebaseFirestore.instance
      .collection('members')
      .where('dataNascimento', isGreaterThan: "")
      .get();

  // Verifique se os dados estão sendo recuperados corretamente
  if (snapshot.docs.isNotEmpty) {
    for (var doc in snapshot.docs) {
      var data = doc.data();
      String birthday = data['dataNascimento'];

      // Tente converter a data no formato correto
      try {
        // Converta a data do formato dd/MM/yyyy para yyyy-MM-dd
        DateTime birthDate = DateFormat('dd/MM/yyyy').parse(birthday);
        String formattedDate = DateFormat('dd/MM/yyyy').format(birthDate);

        // Adicione os dados à lista
        birthdayList.add({
          "name": data['nomeCompleto'],
          "birthday": formattedDate,
          "age": calculateAge(birthDate.toIso8601String()),
        });
      } catch (e) {
        print("Erro ao converter a data: $e");
      }
    }
  } else {
    print("Nenhum dado encontrado no Firestore.");
  }

  // Crie a página do PDF
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(32),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Lista de Aniversariantes",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                columnWidths: {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(1),
                },
                children: [
                  // Cabeçalho da tabela
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "Nome",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "Data de Nascimento",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "Idade",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Dados da tabela
                  ...birthdayList.map((member) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(member["name"]),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(member["birthday"]),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(member["age"].toString()),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  // Salve o PDF no dispositivo
  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/lista_aniversariantes.pdf");
  await file.writeAsBytes(await pdf.save());

  // Compartilhe o arquivo PDF
  Share.shareFiles([file.path]);

  print("PDF salvo em: ${file.path}");
}

// Função para calcular a idade
int calculateAge(String birthday) {
  DateTime birthDate = DateTime.parse(birthday);
  DateTime today = DateTime.now();
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}