import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/constants/app_colors.dart';
import '../services/pdf_generator.dart';

class CardReport extends StatefulWidget {
  final String nameReport;

  const CardReport(this.nameReport, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardReportState createState() => _CardReportState();
}

class _CardReportState extends State<CardReport> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      width: 312,
      height: 91,
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.nameReport,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Botão com hover
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovered = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? const Color(0xFF037955) // Cor durante o hover (#037955)
                      : Appcolors.green, // Cor padrão
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    switch (widget.nameReport) {
                      case "Lista de\nAniversariantes":
                        // Chame a função que gera o PDF da lista de aniversariantes
                        generateBirthdayListPdf();
                        break;
                      default:
                        // Caso padrão se nenhum dos casos anteriores for correspondido
                        print("Relatório não encontrado");
                        break;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Transparente para o AnimatedContainer controlar a cor
                    minimumSize: const Size(62, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: PhosphorIcon(
                    PhosphorIcons.fileArrowDown(PhosphorIconsStyle.bold), // Use o ícone com o estilo específico
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
