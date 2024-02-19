import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Clientes.dart';

class ClientesList with ChangeNotifier {
  late final List<Clientes> _items;

  ClientesList() {
    _items = [];
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    final List<Clientes> clientes = await buscarClientesDoCorretor();
    _items.addAll(clientes);
    notifyListeners();
  }

  Future<List<Clientes>> buscarClientesNaoPertencemAoCorretor() async {
    final firestore = FirebaseFirestore.instance;

    final user = FirebaseAuth.instance.currentUser;
    final corretorId = user?.uid ?? '';
    final querySnapshot = await firestore
        .collection('corretores')
        .where('uid', isEqualTo: corretorId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs[0].id;

      // Obtém a referência da subcoleção 'meus_clientes' do corretor
      final collection = firestore
          .collection('corretores')
          .doc(docId)
          .collection('meus_clientes');

      try {
        // Obter os IDs dos clientes na subcoleção 'meus_clientes'
        QuerySnapshot<Map<String, dynamic>> meusClientesSnapshot =
            await collection.get();

        List<String> clientesIds = meusClientesSnapshot.docs
            .map((doc) => doc.data()['clienteId'] as String)
            .toList();

        // Obter todos os clientes
        CollectionReference<Map<String, dynamic>> clientesRef =
            FirebaseFirestore.instance.collection('clientes');

        QuerySnapshot<Map<String, dynamic>> todosClientesSnapshot =
            await clientesRef.get();

        List<Clientes> clientes = [];

        // Filtrar os clientes que não estão na lista de 'meus_clientes'
        todosClientesSnapshot.docs.forEach(
          (doc) {
            final resultado = doc.data();
            final clienteId = resultado['id'];

            if (!clientesIds.contains(clienteId)) {
              final imovel = Clientes(
                email: resultado['email'],
                id: clienteId,
                imageUrl: resultado['imageUrl'],
                name: resultado['name'],
                tipoUsuario: resultado['tipo_usuario'],
              );

              clientes.add(imovel);
            }
          },
        );

        print('clientes: $clientes');
        return clientes;
      } catch (e) {
        print('Erro ao buscar os clientes: $e');
        return []; // Retorna uma lista vazia em caso de erro
      }
    }

    return []; // Retorna uma lista vazia se o corretor não for encontrado
  }

  Future<List<Clientes>> buscarClientesDoCorretor() async {
    final user = FirebaseAuth.instance.currentUser;
    final corretorId = user?.uid ?? '';

    try {
      final firestore = FirebaseFirestore.instance;

      // Busca o documento do corretor pelo UID
      final querySnapshot = await firestore
          .collection('corretores')
          .where('uid', isEqualTo: corretorId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;

        // Obtém a referência da subcoleção 'meus_clientes' do corretor
        final collection = firestore
            .collection('corretores')
            .doc(docId)
            .collection('meus_clientes');

        // Busca todos os documentos da subcoleção 'meus_clientes' do corretor
        final querySnapshotClientes = await collection.get();

        // Lista para armazenar os clientes
        List<Clientes> clientesList = [];

        // Para cada documento em 'meus_clientes', busca os detalhes completos do cliente na coleção 'clientes'
        for (DocumentSnapshot clienteSnapshot in querySnapshotClientes.docs) {
          final clienteId = clienteSnapshot['clienteId'];
          // Busca o cliente na coleção 'clientes' pelo clienteId
          final clienteDoc =
              await firestore.collection('clientes').doc(clienteId).get();
          if (clienteDoc.exists) {
            // Converte o documento do cliente em um objeto Clientes
            Clientes cliente = Clientes(
              id: clienteDoc.id,
              name: clienteDoc['name'],
              email: clienteDoc['email'],
              imageUrl: clienteDoc['imageUrl'],
              tipoUsuario: clienteDoc['tipo_usuario'],
            );
            clientesList.add(cliente);
          } else {
            print(
                'Cliente com ID $clienteId não encontrado na coleção de clientes.');
          }
        }
        print('buscar clientes do corretor $clientesList');
        return clientesList;
      } else {
        throw Exception('Corretor não encontrado com o ID fornecido');
      }
    } catch (error) {
      print('Erro ao buscar clientes do corretor: $error');
      throw error;
    }
  }

  List<Clientes> get items => [..._items];

  void addCliente(Clientes cliente) {
    _items.add(cliente);
    notifyListeners();
  }

  Future<Clientes?> buscarClientePorId(String clienteId) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Referência para o documento do cliente
      final clienteDoc =
          await firestore.collection('clientes').doc(clienteId).get();

      if (clienteDoc.exists) {
        // Converte o documento do cliente em um objeto Clientes
        final cliente = Clientes(
          id: clienteDoc.id,
          name: clienteDoc['name'],
          email: clienteDoc['email'],
          imageUrl: clienteDoc['imageUrl'],
          tipoUsuario: clienteDoc['tipo_usuario'],
        );
        return cliente;
      } else {
        print(
            'Cliente com ID $clienteId não encontrado na coleção de clientes.');
        return null;
      }
    } catch (error) {
      print('Erro ao buscar cliente por ID: $error');
      return null;
    }
  }
}
