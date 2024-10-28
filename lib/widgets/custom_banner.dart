import 'package:flutter/material.dart';

class CustomBanner extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Duration duration;

  const CustomBanner({
    Key? key,
    required this.message,
    required this.backgroundColor,
    this.duration = const Duration(seconds: 3), // Duração padrão de 3 segundos
  }) : super(key: key);

  @override
  _CustomBannerState createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializa o AnimationController e as animações
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Inicia a animação ao carregar
    _animationController.forward();

    // Fecha o banner após o tempo definido
    Future.delayed(widget.duration, () {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) {
            setState(() {}); // Atualiza para remover o banner
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        margin: const EdgeInsets.only(top: 50.0), // Ajuste da margem superior
        color: widget.backgroundColor,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                if (mounted) {
                  _animationController.reverse().then((_) {
                    if (mounted) {
                      setState(() {}); // Atualiza para remover o banner
                    }
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
