import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'imovel.dart';

class ImovelList with ChangeNotifier {
  late final List<Imovel> _items;

  ImovelList() {
    _items = [];
    _carregarImoveis();
  }

  Future<void> _carregarImoveis() async {
    final List<Imovel> imoveis = await buscarImoveis();
    _items.addAll(imoveis);
    notifyListeners();
  }

  List<Imovel> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Future<List<Imovel>> buscarImoveis() async {
    print('entrou em buscarImoveis');
    CollectionReference<Map<String, dynamic>> imoveisRef =
        FirebaseFirestore.instance.collection('imoveis');

    try {
      print("entrou no try");
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await imoveisRef.get();

      List<Imovel> imoveis = [];

      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final resultado = doc.data();
        final infoList = resultado['info'] ?? <String, dynamic>{};
        final imovel = Imovel(
          codigo: resultado['codigo'],
          data: resultado['data'],
          infoList: resultado['info'] ?? {},
          link: resultado['link'],
        );
        print(
            'imovel encontrado: ${resultado['codigo']} ${resultado['data']} ${resultado['link']} ${resultado['info']}');
        imoveis.add(imovel);
      });
      print(imoveis);
      return imoveis;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<void> salvarImoveisFavoritos(List<Imovel> imoveis) async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (email != null) {
      final clientesRef = FirebaseFirestore.instance.collection('clientes');
      final querySnapshot =
          await clientesRef.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        final List<dynamic> imoveisFavoritos = userData['imoveis_favoritos'];

        List<String> listaImoveisString = [];

        for (var imovel in imoveisFavoritos) {
          listaImoveisString.add(imovel.toString());
        }
        print('listaImoveisString $listaImoveisString');
        // Agora você tem todos os imóveis favoritos do usuário como strings
        // na lista listaImoveisString. Você pode fazer o que quiser com ela.
        marcarImoveisFavoritos(imoveis, listaImoveisString);
      } else {
        print('Usuário não encontrado na coleção "clientes"');
      }
    } else {
      print('Usuário não autenticado.');
    }
  }

  Future<void> marcarImoveisFavoritos(
      List<Imovel> imoveis, List<String> imoveisFavoritos) async {
    print('marcarImoveisFavoritos');
    print(imoveisFavoritos);
    for (int i = 0; i < imoveis.length; i++) {
      bool encontrado = false;
      for (int j = 0; j < imoveisFavoritos.length; j++) {
        if (imoveis[i].codigo == imoveisFavoritos[j]) {
          encontrado = true;
          break; // Se encontrado, não é necessário continuar o loop
        }
      }
      imoveis[i].isFavorite = encontrado;
    }
  }

  List<Imovel> get items => [..._items];

  void addProduct(Imovel product) {
    _items.add(product);
    notifyListeners();
  }
}
