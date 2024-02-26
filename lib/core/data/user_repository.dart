// No arquivo user_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/clientes/Clientes.dart';
import '../../models/corretores/corretor.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<dynamic> loadCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      QuerySnapshot corretorQuery = await FirebaseFirestore.instance
          .collection('corretores')
          .where('uid', isEqualTo: userId)
          .get();

      if (corretorQuery.docs.isNotEmpty) {
        DocumentSnapshot corretorSnapshot = corretorQuery.docs.first;
        print('é corretor');
        return Corretor(
          id: corretorSnapshot['id'] ?? '',
          name: corretorSnapshot['name'] ?? '',
          email: corretorSnapshot['email'] ?? '',
          logoUrl:
              corretorSnapshot['logoUrl'] ?? '', // Preencha conforme necessário
          dataCadastro: corretorSnapshot['data_cadastro'] ??
              '', // Preencha conforme necessário
          permissoes: corretorSnapshot['permissoes'] ??
              '', // Preencha conforme necessário
          uid: corretorSnapshot['uid'] ?? '',
          tipoUsuario: corretorSnapshot['tipo_usuario'] ?? '',
          imoveisCadastrados: List<String>.from(
                  corretorSnapshot['imoveis_cadastrados'] ?? []) ??
              [],
          visitas: List<String>.from(corretorSnapshot['visitas'] ?? []) ?? [],
          negociacoes: List<String>.from(corretorSnapshot['negociacoes'] ?? []) ?? [],
          contato: corretorSnapshot['contato'] ?? {},
          dadosProfissionais: corretorSnapshot['dados_profissionais'] ?? [],
          metas: corretorSnapshot['metas'] ?? [],
          desempenhoAtualMetas: corretorSnapshot['desempenho_atual'] ?? {},
          infoBanner: corretorSnapshot['info_banner'] ?? {},
        );
      }

      // Verificar na coleção 'clientes'
      QuerySnapshot clienteQuery = await FirebaseFirestore.instance
          .collection('clientes')
          .where('uid', isEqualTo: userId)
          .get();

      if (clienteQuery.docs.isNotEmpty) {
        DocumentSnapshot clienteSnapshot = clienteQuery.docs.first;
        print('é cliente');
        return Clientes(
          id: clienteSnapshot['id'],
          name: clienteSnapshot['name'],
          email: clienteSnapshot['email'],
          logoUrl: clienteSnapshot['imageUrl'],
          tipoUsuario: clienteSnapshot['tipo_usuario'],
          contato: clienteSnapshot['contato'],
          UID: clienteSnapshot['uid'],
          historico: List<String>.from(clienteSnapshot['historico'] ?? []),
          historicoBusca:
              List<String>.from(clienteSnapshot['historico_busca'] ?? []),
          imoveisFavoritos:
              List<String>.from(clienteSnapshot['imoveis_favoritos'] ?? []),
         preferencias: clienteSnapshot['preferencias'] is List
    ? List<Map<String, dynamic>>.from(clienteSnapshot['preferencias'])
    : [clienteSnapshot['preferencias']],

        );
      }
    }

    return null; // Retornar null se não houver dados de usuário válidos
  }
}
