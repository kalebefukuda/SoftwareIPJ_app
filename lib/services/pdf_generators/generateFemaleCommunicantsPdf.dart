import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generateFemaleCommunicantsPdf() async {
  final pdf = pw.Document();

  await initializeDateFormatting('pt_BR', null);

  final poppinsFont =
      pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Regular.ttf'));

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
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
    color: const PdfColor.fromInt(0xFF015B40),
  );

  final tableTextStyle = pw.TextStyle(
    font: poppinsFont,
    fontSize: 10,
  );

  List<Map<String, String>> membersList = [];

  // Obtenha os dados do Supabase com filtro por sexo "Feminino" e comungante "SIM"
    final response = await Supabase.instance.client
        .from('membros')
        .select('nomeCompleto, dataNascimento, numeroRol, residencia')
        .eq('sexo', 'Feminino')
        .eq('comungante', 'SIM');

    if (response.isEmpty) {
      print("Nenhum dado encontrado no Supabase.");
      return;
    }

    final data = response as List<dynamic>;

    if (data.isNotEmpty) {
      for (var item in data) {
        membersList.add({
          "name": item['nomeCompleto'] ?? "Nome não disponível",
          "birthday": item['dataNascimento'] ?? "Data não disponível",
          "rol": item['numeroRol']?.toString() ?? "Rol não disponível",
          "residence": item['residencia'] ?? "Residência não disponível",
        });
      }
      // Ordenar por nome
      membersList.sort((a, b) => a["name"]!.compareTo(b["name"]!));
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
                "Lista de Comungantes - Feminino",
                style: headerStyle,
              ),
            ),
            pw.Divider(
                thickness: 0.5, color: PdfColors.black), // Linha de divisão
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
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1),
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
                      "Rol",
                      style: tableHeaderStyle,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      "Residência Local",
                      style: tableHeaderStyle,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
              // Dados da tabela
              ...membersList.map((member) {
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        member["name"]!,
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        member["birthday"]!,
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        member["rol"]!,
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        member["residence"]!,
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
            pw.Divider(
                thickness: 0.5,
                color: PdfColors.black), // Linha de divisão no rodapé
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Data atual no lado esquerdo
                  pw.Text(
                    DateFormat('EEEE, dd MMMM yyyy', 'pt_BR')
                        .format(DateTime.now()),
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
  final file = File("${directory.path}/lista_de_comungantes_fem.pdf");
  await file.writeAsBytes(await pdf.save());

  // Compartilhe o arquivo PDF
  Share.shareFiles([file.path]);

  print("PDF salvo em: ${file.path}");
}
