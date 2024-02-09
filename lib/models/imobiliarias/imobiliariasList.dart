import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imobiliarias/imobiliaria.dart';

class ImobiliariaList with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;

  late final List<Imobiliaria> _items;

  ImobiliariaList() {
    _items = [];
    _carregarImoveis();
  }

  Future<void> _carregarImoveis() async {
    final List<Imobiliaria> imoveis = await lerImobiliarias();
    _items.addAll(imoveis);
    notifyListeners();
  }

  Future<List<Imobiliaria>> lerImobiliarias() async {
  final List<Imobiliaria> imobiliarias = [];

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("imobiliarias").get();

    snapshot.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> seletoresList = [];

      if (data['seletores'] != null) {
        seletoresList.add(Map<String, dynamic>.from(data['seletores']));
      }

      Imobiliaria imobiliaria = Imobiliaria(
        id: document.id,
        nome: data['nome'],
        url_base: data['url_base'],
        url_logo: data['url_logo'],
        seletoresList: seletoresList,
      );

      // Adicionando a instância à lista de imobiliárias
      imobiliarias.add(imobiliaria);
    });

    if (imobiliarias.isEmpty) {
      print('Nenhum dado encontrado na coleção "imobiliarias"');
    }
  } catch (error) {
    print('Erro ao buscar dados da coleção "imobiliarias": $error');
  }

  return imobiliarias;
}

  List<Imobiliaria> get items => [..._items];

  void addProduct(Imobiliaria imobiliaria) {
    _items.add(imobiliaria);
    notifyListeners();
  }
}
