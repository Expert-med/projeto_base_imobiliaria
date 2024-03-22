import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewImovel with ChangeNotifier {
  final String id;
  final Map<String, dynamic> atualizacoes;
  final Map<String, dynamic> detalhes;
  final Map<String, dynamic> caracteristicas;
  final Map<String, dynamic> localizacao;
  final Map<String, dynamic> preco;
  final String link_imovel;
  final String link_virtual_tour;
  final String codigo_imobiliaria;
  final String data_cadastro;
  final String data;
  final List<String> imagens;
  final String curtidas;
  final int finalidade;
  final int tipo;
  bool isFavorite;

  NewImovel({
    required this.id,
    required this.detalhes,
    required this.caracteristicas,
    required this.localizacao,
    required this.preco,
    required this.link_imovel,
    required this.link_virtual_tour,
    required this.codigo_imobiliaria,
    required this.data_cadastro,
    required this.data,
    required this.imagens,
    required this.curtidas,
    required this.finalidade,
    required this.tipo,
    required this.atualizacoes,
    this.isFavorite = false,
  });

  void toggleFavorite() async {
  // Obter o usuário atual
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('clientes')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference userDocRef = querySnapshot.docs[0].reference;

        // Adicionar ou remover o código do produto na lista 'imoveis_favoritos' do documento do usuário
        if (isFavorite) {
          // Se for favorito, remover o código do produto da lista
          await userDocRef.update({
            'imoveis_favoritos': FieldValue.arrayRemove([id]),
          });
        } else {
          // Se não for favorito, adicionar o código do produto à lista
          await userDocRef.update({
            'imoveis_favoritos': FieldValue.arrayUnion([id]),
          });
        }
        isFavorite = !isFavorite;
        notifyListeners();
      } else {
        print('Nenhum cliente encontrado com o uid ${user.uid}');
        
        // Se não encontrou cliente, buscar em corretores
        await _toggleFavoriteForCorretores(user);
      }
    } catch (error) {
      print('Erro ao acessar o documento do usuário: $error');
      
      // Se ocorrer um erro ao buscar em clientes, buscar em corretores
      await _toggleFavoriteForCorretores(user);
    }
  }
}

Future<void> _toggleFavoriteForCorretores(User user) async {
  print('Buscando em corretores...');
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('corretores')
        .where('uid', isEqualTo: user.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference userDocRef = querySnapshot.docs[0].reference;

      if (isFavorite) {
        await userDocRef.update({
          'imoveis_favoritos': FieldValue.arrayRemove([id]),
        });
      } else {
        await userDocRef.update({
          'imoveis_favoritos': FieldValue.arrayUnion([id]),
        });
      }

      isFavorite = !isFavorite;
      notifyListeners();
    } else {
      print('Nenhum corretor encontrado com o uid ${user.uid}');
    }
  } catch (error) {
    print('Erro ao buscar em corretores: $error');
  }
}


  Object? toJson() {}
}
