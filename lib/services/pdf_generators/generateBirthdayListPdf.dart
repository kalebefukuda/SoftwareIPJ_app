import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generateBirthdayListPdf() async {
  final pdf = pw.Document();

  // Inicializar a configuração de data para Português do Brasil
  await initializeDateFormatting('pt_BR', null);

  // Carregar a fonte Poppins
  final poppinsFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Regular.ttf'));

  // Carregar a imagem da logo
  final imageData = await rootBundle.load('assets/images/IPJ86Ver02_2.png');
  final image = pw.MemoryImage(imageData.buffer.asUint8List());

  // Estilização global
  final headerStyle = pw.TextStyle(
    font: poppinsFont,
    fontSize: 18,
    fontWeight: pw.FontWeight.bold,
  );

  final tableHeaderStyle = pw.TextStyle(
    font: poppinsFont,
    fontSize: 14,
    fontWeight: pw.FontWeight.bold,
    color: const PdfColor.fromInt(0xFF015B40),
  );

  final tableTextStyle = pw.TextStyle(
    font: poppinsFont,
    fontSize: 10,
  );

  List<Map<String, dynamic>> birthdayList = [];

  final response = await Supabase.instance.client
      .from('membros')
      .select('nomeCompleto, dataNascimento')
      .neq('dataNascimento', '');

  final data = response as List<dynamic>;

    if (data.isNotEmpty) {
      for (var item in data) {
        String? birthday = item['dataNascimento'];

        if (birthday != null && birthday.isNotEmpty) {
          try {
            DateTime birthDate = DateFormat('dd/MM/yyyy').parse(birthday);
            String formattedDate = DateFormat('dd/MM/yyyy').format(birthDate);

            birthdayList.add({
              "name": item['nomeCompleto'],
              "birthday": formattedDate,
              "age": calculateAge(birthDate),
            });
          } catch (e) {
            print("Erro ao converter a data ($birthday): $e");
          }
        }
      }

      // Ordenar a lista de aniversariantes por nome
      birthdayList.sort((a, b) => a["name"].compareTo(b["name"]));
    } else {
      print("Nenhum dado encontrado no Supabase.");
    }

  // Paginação do conteúdo
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Cabeçalho com a logo e o título
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(image, height: 40), // Logo no canto superior esquerdo
              ],
            ),
            pw.SizedBox(height: 20),
            // Título centralizado horizontalmente
            pw.Center(
              child: pw.Text(
                "Lista de Aniversariantes",
                style: headerStyle,
              ),
            ),
            pw.Divider(thickness: 0.5, color: PdfColors.black), // Linha de divisão
          ],
        );
      },
      build: (pw.Context context) {
        return [
          // Tabela com dados
          pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
            },
            children: [
              // Cabeçalho da tabela
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      "Nome",
                      style: tableHeaderStyle,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      "Data de Nascimento",
                      style: tableHeaderStyle,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      "Idade",
                      style: tableHeaderStyle,
                      textAlign: pw.TextAlign.center,
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
                      child: pw.Text(
                        member["name"],
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        member["birthday"],
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        member["age"].toString(),
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ];
      },
      footer: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Divider(thickness: 0.5, color: PdfColors.black), // Linha de divisão no rodapé
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Data atual no lado esquerdo
                  pw.Text(
                    DateFormat('EEEE, dd MMMM yyyy', 'pt_BR').format(DateTime.now()),
                    style: pw.TextStyle(font: poppinsFont, fontSize: 10),
                  ),
                  // Numeração de páginas no lado direito
                  pw.Text(
                    'Página ${context.pageNumber} de ${context.pagesCount}',
                    style: pw.TextStyle(font: poppinsFont, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  // Salve o PDF no dispositivo
  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/lista_aniversariantes.pdf");
  await file.writeAsBytes(await pdf.save());

  // Compartilhe o arquivo PDF
  Share.shareFiles([
    file.path
  ]);

  print("PDF salvo em: ${file.path}");
}

// Função para calcular a idade
int calculateAge(DateTime birthDate) {
  DateTime today = DateTime.now();
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}
