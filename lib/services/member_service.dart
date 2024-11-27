import 'package:supabase_flutter/supabase_flutter.dart';

class MemberService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Adiciona um novo membro ao Supabase.
  Future<void> addMember(Map<String, dynamic> memberData) async {
    try {
      final response = await supabase.from('membros').insert(memberData);
      if (response.error != null) {
        throw Exception('Erro ao adicionar membro: ${response.error!.message}');
      }
      print("Membro adicionado com sucesso");
    } catch (e) {
      print("Erro ao adicionar membro: $e");
      rethrow;
    }
  }

  /// Atualiza os dados de um membro existente no Supabase.
  Future<void> updateMember(
      String memberId, Map<String, dynamic> memberData) async {
    try {
      final response =
          await supabase.from('membros').update(memberData).eq('id', memberId);
      if (response.error != null) {
        throw Exception('Erro ao atualizar membro: ${response.error!.message}');
      }
      print("Membro atualizado com sucesso");
    } catch (e) {
      print("Erro ao atualizar membro: $e");
      rethrow;
    }
  }

  /// Deleta um membro do Supabase.
  Future<void> deleteMember(String memberId) async {
    try {
      final response =
          await supabase.from('membros').delete().eq('id', memberId);
      if (response.error != null) {
        throw Exception('Erro ao deletar membro: ${response.error!.message}');
      }
      print("Membro deletado com sucesso");
    } catch (e) {
      print("Erro ao deletar membro: $e");
      rethrow;
    }
  }

  /// Obtém os dados de um membro do Supabase.
  Future<Map<String, dynamic>?> getMember(String memberId) async {
    try {
      final response =
          await supabase.from('membros').select().eq('id', memberId).single();

      if (response == null) {
        throw Exception('Nenhum membro encontrado com o ID fornecido.');
      }

      return response;
    } catch (e) {
      print("Erro ao obter membro: $e");
      rethrow;
    }
  }

  /// Obtém a contagem de membros por gênero e status de comungante.
  Future<Map<String, int>> getMemberCountByGenderAndCommunicant() async {
    try {
      final response = await supabase.from('membros').select();

      if (response == null || response.isEmpty) {
        throw Exception('Nenhum dado encontrado na tabela membros.');
      }

      int maleCount = 0;
      int femaleCount = 0;
      int yesCommunicantCount = 0;
      int noCommunicantCount = 0;

      // Itera sobre os resultados
      for (var member in response as List<dynamic>) {
        String? gender = member['sexo'];
        if (gender == 'Masculino') maleCount++;
        if (gender == 'Feminino') femaleCount++;

        String? communicant = member['comungante'];
        if (communicant == 'SIM') yesCommunicantCount++;
        if (communicant == 'NÃO') noCommunicantCount++;
      }

      return {
        'Masculino': maleCount,
        'Feminino': femaleCount,
        'SIM': yesCommunicantCount,
        'NÃO': noCommunicantCount,
      };
    } catch (e) {
      print("Erro ao contar membros: $e");
      rethrow;
    }
  }
}
