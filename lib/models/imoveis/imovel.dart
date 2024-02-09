import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Imovel with ChangeNotifier {
  final String codigo;
  final String data;
  final List<Map<String, dynamic>> infoList;
  final String link;
  bool isFavorite;

  Imovel({
    required this.codigo,
    required this.data,
    required this.infoList,
    required this.link,
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
              'imoveis_favoritos': FieldValue.arrayRemove([codigo]),
            });
          } else {
            // Se não for favorito, adicionar o código do produto à lista
            await userDocRef.update({
              'imoveis_favoritos': FieldValue.arrayUnion([codigo]),
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
              'imoveis_favoritos': FieldValue.arrayRemove([codigo]),
            });
          } else {
            await userDocRef.update({
              'imoveis_favoritos': FieldValue.arrayUnion([codigo]),
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
