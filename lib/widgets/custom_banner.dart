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

class _CustomBannerState extends State<CustomBanner> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _progressController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializa o AnimationController para a animação de deslize
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Configura a animação para começar fora da tela pela direita e entrar na tela
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Começa fora da tela à direita
      end: Offset.zero, // Fica visível no canto direito
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Inicializa o controlador para a barra de progresso com a duração do banner
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward(); // Inicia a contagem regressiva da barra de progresso

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
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight, // Posiciona o banner no canto superior direito
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Cor da sombra com leve transparência
                blurRadius: 8, // Desfoque da sombra
                offset: const Offset(2, 4), // Deslocamento horizontal e vertical da sombra
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          margin: const EdgeInsets.only(top: 10.0), // Ajusta para próximo do cabeçalho
          width: MediaQuery.of(context).size.width * 0.5, // Define largura para 50% da tela
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
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
                  ),
                ],
              ),
              // Barra de progresso no bottom do banner
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(162, 255, 255, 255)),
                      backgroundColor: const Color.fromARGB(41, 255, 255, 255), 
                      value: 1.0 - _progressController.value, // Progresso do lado esquerdo para o direito
                      minHeight: 4, // Altura da barra de progresso
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
