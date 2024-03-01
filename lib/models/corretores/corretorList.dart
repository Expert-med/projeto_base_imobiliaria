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

    QuerySnapshot querySnapshot = await firestore.collection('corretores').get();

    List<Corretor> corretores = [];

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((corretorDoc) {
        Map<String, dynamic> data = corretorDoc.data() as Map<String, dynamic>;

        corretores.add(Corretor(
          id: corretorDoc.id,
          name: data['name'] ?? '',
          tipoUsuario: data['tipoUsuario'] ?? 0,
          email: data['email'] ?? '',
          logoUrl: data['logo_url']?? '',
          dataCadastro: data['data_cadastro'] ?? '',
          uid: data['uid'] ?? '',
          permissoes: data['permissoes'] ?? '',
          imoveisCadastrados: List<String>.from(data['imoveis_cadastrados'] ?? []),
          visitas: List<String>.from(data['visitas'] ?? []),
          negociacoes: List<String>.from(data['negociacoes'] ?? []),
          contato: data['contato'] ?? {},
          dadosProfissionais: data['dados_profissionais'] ?? {},
          metas: data['metas'] ?? {},
          desempenhoAtualMetas: data['desempenho_atual_metas'] ?? {},
          infoBanner: data['info_banner'] ?? {},
        ));
      });
    } else {
      print('Nenhum documento encontrado na coleção de corretores.');
    }

    return corretores;
  } catch (error) {
    print('Erro ao buscar corretores: $error');
    return []; 
  }
}


Future<void> adicionarNegociacaoAoCorretor(String idCorretor, String idNegociacao) async {
  try {
    DocumentReference corretorRef = FirebaseFirestore.instance.collection('corretores').doc(idCorretor);

    DocumentSnapshot corretorDoc = await corretorRef.get();

    if (corretorDoc.exists) {
      List<dynamic> negociacoes = corretorDoc['negociacoes'] ?? [];

      negociacoes.add(idNegociacao);

      await corretorRef.update({'negociacoes': negociacoes});

      print('Negociação adicionada com sucesso ao corretor com ID: $idCorretor');
    } else {
      print('Corretor com ID: $idCorretor não encontrado');
    }
  } catch (e) {
    print('Erro ao adicionar negociação ao corretor: $e');
  }
}


Future<void> adicionarVisitaAoCorretor(String idCorretor, String idVisita) async {
  try {
    DocumentReference corretorRef = FirebaseFirestore.instance.collection('corretores').doc(idCorretor);

    DocumentSnapshot corretorDoc = await corretorRef.get();

    if (corretorDoc.exists) {
      List<dynamic> negociacoes = corretorDoc['visitas'] ?? [];

      negociacoes.add(idVisita);

      await corretorRef.update({'visitas': negociacoes});

      print('Negociação adicionada com sucesso ao corretor com ID: $idCorretor');
    } else {
      print('Corretor com ID: $idCorretor não encontrado');
    }
  } catch (e) {
    print('Erro ao adicionar negociação ao corretor: $e');
  }
}
}
