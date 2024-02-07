import 'dart:async';

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
    final List<Imovel> imoveis = await lerImobiliarias();
    _items.addAll(imoveis);
    notifyListeners();
  }

  Future<List<Imovel>> lerImobiliarias() async {
    print('entrou em LerImobiliarias agora');

    final List<Map<String, dynamic>> infoList = [];
    final List<Imovel> imoveis = [];

    final firebaseApp = Firebase.app();

    final rtdb = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL:
          'https://imob-projeto-expmed-default-rtdb.firebaseio.com/',
    );

    DatabaseReference imoveisRef = rtdb
        .ref()
        .child('imobiliarias/-NpvkuGYUlb2YswfRZ3Y/imoveis');

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
        } else {
          print('Dados no formato inválido');
        }
      } else {
        print('Nenhum dado encontrado');
      }
    });

    return imoveis;
  }

  List<Imovel> get items => [..._items];

  void addProduct(Imovel product) {
    _items.add(product);
    notifyListeners();
  }
}
