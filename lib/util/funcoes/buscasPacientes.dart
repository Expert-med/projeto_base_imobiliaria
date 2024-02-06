import 'package:cloud_firestore/cloud_firestore.dart';

class BuscasPaciente {

    Future<List<Map<String, dynamic>>> buscarPacientes(
      DocumentReference hospitalDoc, String cpf) async {
    try {
      final QuerySnapshot snapshot = await hospitalDoc
          .collection("pacientes")
          .where("cpf", isEqualTo: cpf)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> caixaAtual = snapshot.docs
            .map((caixaAtual) => caixaAtual.data() as Map<String, dynamic>)
            .toList();

        return caixaAtual; // Retorna a lista de caixas encontradas.
      } else {
        print("Não foram encontradas caixas no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as caixas: $error');
    }

    return []; // Retorna uma lista vazia se ocorrer um erro ou não encontrar caixas.
  }
  
}