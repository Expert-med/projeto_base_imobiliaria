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
                logoUrl: resultado['imageUrl'],
                name: resultado['name'],
                tipoUsuario: resultado['tipo_usuario'],
                contato: resultado['contato'],
                UID: resultado['uid'],
                historico: List<String>.from(resultado['historico'] ?? []),
                historicoBusca:
                    List<String>.from(resultado['historico_busca'] ?? []),
                imoveisFavoritos:
                    List<String>.from(resultado['imoveis_favoritos'] ?? []),
                preferencias: resultado['preferencias'] ?? [],
                visitas: resultado['visitas'] ?? [],
              );

              clientes.add(imovel);
            }
          },
        );

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

      final querySnapshot = await firestore
          .collection('corretores')
          .where('uid', isEqualTo: corretorId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;

        final collection = firestore
            .collection('corretores')
            .doc(docId)
            .collection('meus_clientes');

        final querySnapshotClientes = await collection.get();

        List<Clientes> clientesList = [];

        for (DocumentSnapshot clienteSnapshot in querySnapshotClientes.docs) {
  final clienteId = clienteSnapshot['clienteId'];
  final clienteDoc = await firestore.collection('clientes').doc(clienteId).get();

  if (clienteDoc.exists) {
    dynamic preferenciasData = clienteDoc['preferencias'];
    List<Map<String, dynamic>> preferencias = [];

    if (preferenciasData is List<dynamic>) {
      preferencias = preferenciasData
          .map<Map<String, dynamic>>(
              (etapa) => etapa as Map<String, dynamic>)
          .toList();
    } else if (preferenciasData is Map<String, dynamic>) {
      // Se `preferenciasData` for um mapa, adiciona-o à lista `preferencias`
      preferencias.add(preferenciasData);
    }

    Clientes cliente = Clientes(
      id: clienteDoc.id,
      name: clienteDoc['name'],
      email: clienteDoc['email'],
      logoUrl: clienteDoc['imageUrl'],
      tipoUsuario: clienteDoc['tipo_usuario'],
      contato: clienteDoc['contato'],
      UID: clienteDoc['uid'],
      historico: List<String>.from(clienteDoc['historico'] ?? []),
      historicoBusca:
          List<String>.from(clienteDoc['historico_busca'] ?? []),
      imoveisFavoritos:
          List<String>.from(clienteDoc['imoveis_favoritos'] ?? []),
      preferencias: preferencias,
      visitas:  List<String>.from(clienteDoc['visitas'] ?? []),
    );
    clientesList.add(cliente);
  } else {
    print('Cliente com ID $clienteId não encontrado na coleção de clientes.');
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
        dynamic preferenciasData = clienteDoc['preferencias'];
    List<Map<String, dynamic>> preferencias = [];

    if (preferenciasData is List<dynamic>) {
      preferencias = preferenciasData
          .map<Map<String, dynamic>>(
              (etapa) => etapa as Map<String, dynamic>)
          .toList();
    } else if (preferenciasData is Map<String, dynamic>) {
      // Se `preferenciasData` for um mapa, adiciona-o à lista `preferencias`
      preferencias.add(preferenciasData);
    }
        final cliente = Clientes(
          id: clienteDoc.id,
      name: clienteDoc['name'],
      email: clienteDoc['email'],
      logoUrl: clienteDoc['imageUrl'],
      tipoUsuario: clienteDoc['tipo_usuario'],
      contato: clienteDoc['contato'],
      UID: clienteDoc['uid'],
      historico: List<String>.from(clienteDoc['historico'] ?? []),
      historicoBusca:
          List<String>.from(clienteDoc['historico_busca'] ?? []),
      imoveisFavoritos:
          List<String>.from(clienteDoc['imoveis_favoritos'] ?? []),
      preferencias: preferencias,
       visitas:  List<String>.from(clienteDoc['visitas'] ?? []),
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

  Future<void> adicionarNegociacaoAoCliente(String idCliente, String idNegociacao) async {
  try {
    DocumentReference corretorRef = FirebaseFirestore.instance.collection('clientes').doc(idCliente);

    DocumentSnapshot corretorDoc = await corretorRef.get();

    if (corretorDoc.exists) {
      List<dynamic> negociacoes = corretorDoc['negociacoes'] ?? [];

      negociacoes.add(idNegociacao);

      await corretorRef.update({'negociacoes': negociacoes});

      print('Negociação adicionada com sucesso ao corretor com ID: $idCliente');
    } else {
      print('Corretor com ID: $idCliente não encontrado');
    }
  } catch (e) {
    print('Erro ao adicionar negociação ao corretor: $e');
  }
}


  Future<void> adicionarVisitaAoCliente(String idCliente, String idVisita) async {
  try {
    DocumentReference corretorRef = FirebaseFirestore.instance.collection('clientes').doc(idCliente);

    DocumentSnapshot corretorDoc = await corretorRef.get();

    if (corretorDoc.exists) {
      List<dynamic> visitas = corretorDoc['visitas'] ?? [];

      visitas.add(idVisita);

      await corretorRef.update({'visitas': visitas});

      print('Negociação adicionada com sucesso ao corretor com ID: $idCliente');
    } else {
      print('Corretor com ID: $idCliente não encontrado');
    }
  } catch (e) {
    print('Erro ao adicionar negociação ao corretor: $e');
  }
}

void filterClientes(String searchTerm) {
    // Converter o termo de pesquisa para minúsculas para fazer uma comparação sem diferenciação de maiúsculas e minúsculas
    final String searchTermLower = searchTerm.toLowerCase();

    // Filtrar os clientes com base no termo de pesquisa
    List<Clientes> clientesFiltrados = _items.where((cliente) =>
        cliente.name.toLowerCase().contains(searchTermLower)).toList();

    // Notificar os ouvintes sobre as alterações na lista de clientes filtrados
    notifyListeners();
  }

void clear() {
    _items.clear();
    notifyListeners();
  }
}
