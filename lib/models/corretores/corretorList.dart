import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'corretor.dart';

class CorretorList with ChangeNotifier {
  late final List<Corretor> _items;

  CorretorList() {
    _items = [];
    _carregarCorretores();
  }

  Future<void> _carregarCorretores() async {
    final List<Corretor> corretores = await buscarCorretores();
    _items.addAll(corretores);
    notifyListeners();
  }

 Future<List<Corretor>> buscarCorretores() async {
  try {
    final firestore = FirebaseFirestore.instance;

    // Consulta para obter todos os documentos da coleção "corretores"
    QuerySnapshot querySnapshot = await firestore.collection('corretores').get();

    List<Corretor> corretores = [];

    // Verifica se a consulta retornou documentos
    if (querySnapshot.docs.isNotEmpty) {
      // Iterar sobre os documentos obtidos e criar objetos Corretor
      querySnapshot.docs.forEach((corretorDoc) {
        Map<String, dynamic> data = corretorDoc.data() as Map<String, dynamic>;
        corretores.add(Corretor(
          id: corretorDoc.id,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          imageBanner: data['imageBanner'] ?? '',
          permissoes: data['permissoes'] ?? '',
          tipoUsuario: data['tipoUsuario'] ?? 0,
          creci: data['creci'] ?? '',
          textoCorretor: data['texto_corretor'] ?? '',
          imoveisCadastrados: List<String>.from(data['imoveis_cadastrados'] ?? []),
          contato: data['contato'] ?? '',
        ));
      });
    } else {
      print('Nenhum documento encontrado na coleção de corretores.');
    }

    return corretores;
  } catch (error) {
    print('Erro ao buscar corretores: $error');
    return []; // Retorna uma lista vazia em caso de erro
  }
}

}
