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
    final List<Imovel> imoveis = await lerImoveis();
    _items.addAll(imoveis);
    notifyListeners();
  }

  Future<List<Imovel>> lerImoveis() async {
    print('Entrou em lerImoveis agora');

    final List<Map<String, dynamic>> infoList = [];
    final List<Imovel> imoveis = [];

    final firebaseApp = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: 'https://imob-projeto-expmed-default-rtdb.firebaseio.com/',
    );
    DatabaseReference imoveisRef =
        rtdb.ref().child('imobiliarias/-NpvkuGYUlb2YswfRZ3Y/imoveis');

    await imoveisRef.onValue.first.then((event) async {
      final data = event.snapshot.value;

      if (data != null) {
        if (data is Map<String, dynamic>) {
          data.forEach((key, value) {
            final Map<String, dynamic>? infoData =
                value['info'] as Map<String, dynamic>?;

            if (infoData != null) {
              final Map<String, dynamic> infoMap = {
                'area_privativa': infoData['area_privativa'] ?? '',
                'area_privativa_casa': infoData['area_privativa_casa'] ?? '',
                'area_total': infoData['area_total'] ?? '',
                'image_urls': infoData['image_urls'] ?? '',
                'latitude': infoData['latitude'] ?? 0.0,
                'localizacao': infoData['localizacao'] ?? '',
                'longitude': infoData['longitude'] ?? 0.0,
                'mobilia': infoData['mobilia'] ?? '',
                'nome_imovel': infoData['nome_imovel'] ?? '',
                'perfil': infoData['perfil'] ?? '',
                'preco_original': infoData['preco_original'] ?? 0.0,
                'preco_promocional': infoData['preco_promocional'] ?? 0.0,
                'terreno': infoData['terreno'] ?? '',
                'total_dormitorios': infoData['total_dormitorios'] ?? 0,
                'total_suites': infoData['total_suites'] ?? 0,
                'total_garagem': infoData['total_garagem'] ?? 0,
              };

              infoList.add(infoMap);
            } else {
              print('Dados de info não encontrados para a chave $key');
            }

            final imovel = Imovel(
              codigo: key,
              data: value['data'],
              infoList: infoList,
              link: value['link'],
            );
            imoveis.add(imovel);
          });

          // Após obter a lista de imóveis, chame a função para salvar os imóveis favoritos
          await salvarImoveisFavoritos(imoveis);
        } else {
          print('Dados no formato inválido');
        }
      } else {
        print('Nenhum dado encontrado');
      }
    });

    return imoveis;
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
