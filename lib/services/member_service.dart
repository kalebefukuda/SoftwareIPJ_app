import 'package:cloud_firestore/cloud_firestore.dart';

class MemberService {
  final CollectionReference membersCollection =
      FirebaseFirestore.instance.collection('members'); 

  /// Adiciona um novo membro ao Firestore.
  Future<void> addMember(Map<String, dynamic> memberData) async {
    try {
      await membersCollection.add(memberData);
      print("Membro adicionado com sucesso");
    } catch (e) {
      print("Erro ao adicionar membro: $e");
      rethrow; 
    }
  }

  /// Atualiza os dados de um membro existente.
  Future<void> updateMember(String memberId, Map<String, dynamic> memberData) async {
    try {
      await membersCollection.doc(memberId).update(memberData);
      print("Membro atualizado com sucesso");
    } catch (e) {
      print("Erro ao atualizar membro: $e");
      rethrow;
    }
  }

  /// Deleta um membro do Firestore.
  Future<void> deleteMember(String memberId) async {
    try {
      await membersCollection.doc(memberId).delete();
      print("Membro deletado com sucesso");
    } catch (e) {
      print("Erro ao deletar membro: $e");
      rethrow;
    }
  }

  
  Future<DocumentSnapshot> getMember(String memberId) async {
    try {
      return await membersCollection.doc(memberId).get(); 
    } catch (e) {
      print("Erro ao obter membro: $e");
      rethrow;
    }
  }

  
  Future<List<QueryDocumentSnapshot>> getAllMembers() async {
    try {
      QuerySnapshot querySnapshot = await membersCollection.get(); 
      return querySnapshot.docs; 
    } catch (e) {
      print("Erro ao obter lista de membros: $e");
      rethrow;
    }
  }
}
