import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Clientes.dart';

class ClientesList with ChangeNotifier {
  late final List<Clientes> _items;

  ClientesList() {
    _items = [];
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    final List<Clientes> clientes = await buscarClientes();
    _items.addAll(clientes);
    notifyListeners();
  }

  Future<List<Clientes>> buscarClientes() async {
    CollectionReference<Map<String, dynamic>> clientesRef =
        FirebaseFirestore.instance.collection('clientes');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await clientesRef.get();

      List<Clientes> clientes = [];

      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final resultado = doc.data();
        final infoList = resultado['info'] ?? <String, dynamic>{};
        final imovel = Clientes(
          email: resultado['email'],
          id: resultado['id'],
          imageUrl: resultado['imageUrl'],
          name: resultado['name'],
          tipoUsuario: resultado['tipo_usuario'],
        );

        clientes.add(imovel);
      });
  print('clientes: $clientes');
      return clientes;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  

  List<Clientes> get items => [..._items];

  void addCliente(Clientes cliente) {
    _items.add(cliente);
    notifyListeners();
  }
}
