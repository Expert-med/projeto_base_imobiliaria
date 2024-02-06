import 'package:cloud_firestore/cloud_firestore.dart';

class BuscarLocaisArmazenamento{

  
  Future<Map<String, dynamic>> buscarDadosLocaisArmPorId(
      DocumentReference hospitalDoc, int idLocal) async {
    try {
      final snapshot = await hospitalDoc
          .collection("locais_armazenamento")
          .where("id", isEqualTo: idLocal)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final locaisArmazenamentoData = snapshot.docs[0].data() as Map<String, dynamic>;
        return locaisArmazenamentoData;
      } else {
        print("Não foram encontradas caixas no banco de dados.");
        return {};
      }
    } catch (error) {
      print('Erro ao buscar as embalagens: $error');
      return {};
    }
  }
}