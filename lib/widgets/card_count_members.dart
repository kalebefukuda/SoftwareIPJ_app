import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MembersCountCard extends StatelessWidget {
  const MembersCountCard({super.key});

  Future<Map<String, int>> _fetchMemberData() async {
    // Simula a futura chamada para uma API para buscar as informações dos membros
    await Future.delayed(const Duration(seconds: 2));
    return {
      'total': 200,
      'homens': 120,
      'mulheres': 80,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _fetchMemberData(), // Simula a chamada para uma API futura
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Exibe indicador de progresso enquanto carrega
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar os dados dos membros');
        } else if (snapshot.hasData) {
          final memberData = snapshot.data!;
          // Define o caminho da imagem SVG baseado no tema atual (claro ou escuro)
          final svgPath = Theme.of(context).brightness == Brightness.dark
              ? 'assets/images/4_card_dark1.svg'
              : 'assets/images/4_card_light1.svg';

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary, // Cor de fundo do card
              borderRadius: BorderRadius.circular(35), // Bordas arredondadas
            ),
            child: Row(
              children: [
                // Divisão esquerda: imagem
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      bottomLeft: Radius.circular(35),
                    ),
                    child: SvgPicture.asset(
                      svgPath, // Caminho da imagem baseado no tema
                      fit: BoxFit.cover,
                      height: 323, // Altura do card
                    ),
                  ),
                ),
                // Divisão direita: três quadrados para contagem dos membros
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start, // Garante que a coluna também comece do início
                    children: [
                      _buildMemberCountBox(context, memberData['total']!),
                      const SizedBox(height: 60),
                      _buildMemberCountBox(context, memberData['homens']!),
                      const SizedBox(height: 30),
                      _buildMemberCountBox(context, memberData['mulheres']!),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink(); // Caso padrão se não houver dados
      },
    );
  }

  // Método para construir cada "quadrado" com a contagem de membros
  Widget _buildMemberCountBox(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary, // Cor de fundo dos quadrados
        borderRadius: BorderRadius.circular(35),
      ),
      width: 80,
      child: Center(
        child: Text(
          '$count',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
