import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generateWeddingDatesPdf() async {
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
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
    color: const PdfColor.fromInt(0xFF015B40),
  );

  final tableTextStyle = pw.TextStyle(
    font: poppinsFont,
    fontSize: 10,
  );

  // Listas para armazenar os casais
  Map<String, List<Map<String, dynamic>>> groupedMembers = {};

  final response = await Supabase.instance.client
      .from('membros')
      .select('nomeCompleto, casamentoRolSeparado');
  
  final data = response as List<dynamic>;


  if (data.isNotEmpty) {
    for (var item in data) {
      String? weddingDate = item['casamentoRolSeparado'];

      if (weddingDate != null && weddingDate.isNotEmpty) {
        // Agrupar membros pela data de casamento
        groupedMembers.putIfAbsent(weddingDate, () => []).add({
          'name': item['nomeCompleto'] ?? 'Nome não disponível',
          'weddingDate': weddingDate,
        });
      }
    }
  } else {
     print("Nenhum dado encontrado no Supabase.");
  }

  // Filtrar apenas datas com exatamente 2 membros
  List<Map<String, dynamic>> weddingList = [];
  groupedMembers.forEach((date, members) {
    if (members.length == 2) {
      // Construir o casal e calcular os anos de casamento
      String coupleNames = '${members[0]['name'].split(" ")[0]} e ${members[1]['name'].split(" ")[0]}';
      DateTime weddingDate = DateFormat('dd/MM/yyyy').parse(date);
      int yearsOfMarriage = DateTime.now().year - weddingDate.year;
      if (DateTime.now().month < weddingDate.month || 
          (DateTime.now().month == weddingDate.month && DateTime.now().day < weddingDate.day)) {
        yearsOfMarriage--;
      }

      weddingList.add({
        'weddingDate': date,
        'coupleNames': coupleNames,
        'yearsOfMarriage': yearsOfMarriage.toString(),
      });
    }
  });

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
                "Lista de Datas de Casamento",
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
              2: const pw.FlexColumnWidth(1),
            },
            children: [
              // Cabeçalho da tabela
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Center(
                      child: pw.Text(
                        "Data de Casamento",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Center(
                      child: pw.Text(
                        "Casal",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Center(
                      child: pw.Text(
                        "Anos de Casamento",
                        style: tableHeaderStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              // Dados da tabela
              ...weddingList.map((wedding) {
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        wedding['weddingDate'],
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        wedding['coupleNames'],
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        wedding['yearsOfMarriage'],
                        style: tableTextStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                );
              }),
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
  final file = File("${directory.path}/lista_de_casamento.pdf");
  await file.writeAsBytes(await pdf.save());

  // Compartilhe o arquivo PDF
  // ignore: deprecated_member_use
  Share.shareFiles([
    file.path
  ]);
}