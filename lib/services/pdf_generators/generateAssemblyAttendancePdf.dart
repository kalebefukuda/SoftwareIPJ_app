import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generateAssemblyAttendancePdf() async {
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

  List<String> memberNames = [];

  // Obtenha os dados do Firestore
  final snapshot = await FirebaseFirestore.instance.collection('members').get();

  if (snapshot.docs.isNotEmpty) {
    for (var doc in snapshot.docs) {
      var data = doc.data();
      String name = data['nomeCompleto'];
      memberNames.add(name);
    }
    memberNames.sort((a, b) => a.compareTo(b));
  } else {
    print("Nenhum dado encontrado no Firestore.");
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
                "Lista de Chamada da Assembleia",
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
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(1),
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
                      "Assinatura",
                      style: tableHeaderStyle,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
              // Dados da tabela
              ...memberNames.map((name) {
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        name,
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(0),
                      child: pw.Container(
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(width: 1, color: PdfColors.black),
                          ),
                        ),
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
  final file = File("${directory.path}/lista_de_chamada_assembleia.pdf");
  await file.writeAsBytes(await pdf.save());

  // Compartilhe o arquivo PDF
  Share.shareFiles([
    file.path
  ]);

  print("PDF salvo em: ${file.path}");
}