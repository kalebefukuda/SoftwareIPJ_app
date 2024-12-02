// lib/widgets/screen_scale_wrapper.dart

import 'package:flutter/material.dart';

/// Um widget que aplica uma escala fixa de texto à tela.
class ScreenScaleWrapper extends StatelessWidget {
  final Widget child;

  const ScreenScaleWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // Mantém outras configurações, mas fixa o textScaleFactor
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
      child: child,
    );
  }
}