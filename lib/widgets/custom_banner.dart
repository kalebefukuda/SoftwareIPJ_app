import 'package:flutter/material.dart';

class CustomBanner extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Duration duration;
  final VoidCallback onDismissed; // Callback para notificar o término da animação de saída

  const CustomBanner({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.onDismissed, // Adiciona o callback onDismissed como obrigatório
    this.duration = const Duration(seconds: 3), // Duração padrão de 3 segundos
  });

  @override
  _CustomBannerState createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializa o AnimationController e a animação de deslize
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Configura a animação para começar fora da tela pela direita e entrar na tela
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),  // Começa fora da tela à direita
      end: Offset.zero,                // Fica visível no canto direito
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Anima a entrada do banner ao carregar
    _animationController.forward();

    // Após a duração definida, inicia a animação de saída
    Future.delayed(widget.duration, () {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) {
            widget.onDismissed(); // Chama o callback onDismissed após a animação de saída
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
    return Align(
      alignment: Alignment.topRight, // Posiciona o banner no canto superior direito
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          margin: const EdgeInsets.only(top: 10.0), // Ajusta para próximo do cabeçalho
          color: widget.backgroundColor,
          width: MediaQuery.of(context).size.width * 0.5, // Define largura para 50% da tela
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
                      widget.onDismissed(); // Chama o callback quando o botão de fechar é pressionado
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}