import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CardReport extends StatefulWidget {
  const CardReport({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardReportState createState() => _CardReportState();
}

class _CardReportState extends State<CardReport> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PhosphorIcon(
            PhosphorIcons.file(PhosphorIconsStyle.bold),
            size: 50,
            color: Colors.white,
          )
          // Ícone de relatório
          // SvgPicture.asset(
          //   'assets/images/file.svg',
          //   width: 50,
          //   height: 50,
          // ),
        ],
      ),
    );
  }
}
