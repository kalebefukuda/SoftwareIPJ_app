import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/member_service.dart';

class MembersCountCard extends StatelessWidget {
  MembersCountCard({super.key});

  final MemberService memberService = MemberService();

  Future<Map<String, int>> _fetchMemberData() async {
    try {
      // Usa a função do serviço para obter as contagens reais
      Map<String, int> counts = await memberService.getMemberCountByGender();
      return {
        'total': (counts['Masculino'] ?? 0) + (counts['Feminino'] ?? 0),
        'homens': counts['Masculino'] ?? 0,
        'mulheres': counts['Feminino'] ?? 0,
      };
    } catch (e) {
      print("Erro ao carregar dados dos membros: $e");
      return {'total': 0, 'homens': 0, 'mulheres': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _fetchMemberData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar os dados dos membros');
        } else if (snapshot.hasData) {
          final memberData = snapshot.data!;
          final svgPath = Theme.of(context).brightness == Brightness.dark
              ? 'assets/images/4_card_dark1.svg'
              : 'assets/images/4_card_light1.svg';

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      bottomLeft: Radius.circular(35),
                    ),
                    child: SvgPicture.asset(
                      svgPath,
                      fit: BoxFit.cover,
                      height: 323,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnimatedCountBox(context, memberData['total']!),
                      const SizedBox(height: 60),
                      _buildAnimatedCountBox(context, memberData['homens']!),
                      const SizedBox(height: 30),
                      _buildAnimatedCountBox(context, memberData['mulheres']!),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAnimatedCountBox(BuildContext context, int targetCount) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: targetCount),
      duration: const Duration(seconds: 2),
      builder: (context, count, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(35),
          ),
          width: 80,
          child: Center(
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 19,
                  ),
            ),
          ),
        );
      },
    );
  }
}
