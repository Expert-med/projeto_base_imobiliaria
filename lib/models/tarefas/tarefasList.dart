import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/tarefas/tarefas.dart';

class TarefasLista with ChangeNotifier {
  late final List<TarefasCorretor> _items;

  TarefasLista() {
    _items = [];
    _carregarNegociacoes();
  }

  Future<void> _carregarNegociacoes() async {
    final List<TarefasCorretor> negociacoes = await buscarMinhasTarefas();
    _items.addAll(negociacoes);
    notifyListeners();
  }

  Future<List<TarefasCorretor>> buscarMinhasTarefas() async {
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
            .collection('minhas_tarefas');

        final querySnapshotTarefas = await collection.get();

        List<TarefasCorretor> tarefasList = [];

        for (DocumentSnapshot tarefaSnapshot in querySnapshotTarefas.docs) {
          final tarefaData = tarefaSnapshot.data() as Map<String, dynamic>;
          final tarefa = TarefasCorretor(
            id: tarefaSnapshot.id,
            titulo: tarefaData['titulo'],
            descricao: tarefaData['descricao'],
            feita: tarefaData['feita'],
          );
          tarefasList.add(tarefa);
        }

        return tarefasList; // Retorna a lista de tarefas após o loop for
      } else {
        return []; // Retorna uma lista vazia se não houver documentos
      }
    } catch (error) {
      print('Erro ao buscar tarefas do corretor: $error');
      throw error;
    }
  }

  Future<void> adicionarTarefa(TarefasCorretor tarefaAdd) async {
    print('Add tarefa ${tarefaAdd.id} | ${tarefaAdd.titulo}| ${tarefaAdd.descricao}| ${tarefaAdd.feita}');
    final user = FirebaseAuth.instance.currentUser;
    final corretorId = user?.uid ?? '';

    try {
      final firestore = FirebaseFirestore.instance;

      final corretoresRef = firestore.collection('corretores');

      final querySnapshot =
          await corretoresRef.where('uid', isEqualTo: corretorId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;

        final collection =
            corretoresRef.doc(docId).collection('minhas_tarefas');

        // Adiciona a nova tarefa à coleção de tarefas no Firestore
       await collection.doc(tarefaAdd.id).set({
  'id': tarefaAdd.id,
  'titulo': tarefaAdd.titulo,
  'descricao': tarefaAdd.descricao,
  'feita': false,
});

        _items.add(tarefaAdd);
        notifyListeners();
      } else {
        throw Exception('Corretor não encontrado com o ID fornecido');
      }
    } catch (error) {
      print('Erro ao adicionar tarefa: $error');
      throw error;
    }
  }

Future<void> atualizarTarefaFirestore(TarefasCorretor tarefa) async {
    final user = FirebaseAuth.instance.currentUser;
    final corretorId = user?.uid ?? '';

    try {
      final firestore = FirebaseFirestore.instance;

      final corretoresRef = firestore.collection('corretores');

      final querySnapshot =
          await corretoresRef.where('uid', isEqualTo: corretorId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;

        final collection = corretoresRef.doc(docId).collection('minhas_tarefas');

        await collection.doc(tarefa.id.toString()).set({'id': tarefa.id,
          'titulo': tarefa.titulo,
          'descricao': tarefa.descricao,
          'feita': tarefa.feita!,});

        
      } else {
        throw Exception('Corretor não encontrado com o ID fornecido');
      }
    } catch (error) {
      print('Erro ao adicionar cliente: $error');
      throw error;
    }
  }



  List<TarefasCorretor> get items => [..._items];

  void addProduct(TarefasCorretor product) {
    _items.add(product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
