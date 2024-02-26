import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewImovel with ChangeNotifier {
  final String id;
  final String tipo_imovel;
  final Map<String, dynamic> detalhes;
  final String link_imovel;
  final String link_virtual_tour;
  final String imobiliaria;
  final String status;
  final String data_cadastro;

  bool isFavorite;

  NewImovel({
    required this.id,
    required this.tipo_imovel,
    required this.detalhes,
    required this.link_imovel,
    required this.link_virtual_tour,
    required this.imobiliaria,
    required this.status,
    required this.data_cadastro,
    this.isFavorite = false,
  });

  void toggleFavorite() async {
    // Obter o usuário atual
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('clientes')
            .where('email', isEqualTo: user.email)
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
          print('Nenhum usuário encontrado com o email ${user.email}');
        }
      } catch (error) {
        print('Erro ao acessar o documento do usuário: $error');
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('corretores')
            .where('email', isEqualTo: user.email)
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
          print('Nenhum usuário encontrado com o email ${user.email}');
        }
      }
    }
  }
}
