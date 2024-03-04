import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_imobiliaria/models/corretores/corretorList.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacao.dart';

import '../clientes/clientesList.dart';

class NegociacaoList with ChangeNotifier {
  late final List<Negociacao> _items;

  NegociacaoList() {
    _items = [];
    _carregarNegociacoes();
  }

  Future<void> _carregarNegociacoes() async {
    final List<Negociacao> negociacoes = await buscarMinhasNegociacoes();
    _items.addAll(negociacoes);
    notifyListeners();
  }

  Future<List<Negociacao>> buscarNegociacoes() async {
    CollectionReference<Map<String, dynamic>> negociacoesRef =
        FirebaseFirestore.instance.collection('negociacoes');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await negociacoesRef.get();

      List<Negociacao> negociacoes = [];

      querySnapshot.docs.forEach((doc) {
        final resultado = doc.data();

        // Convertendo o resultado para um mapa
        final Map<String, dynamic> resultados = resultado['resultados'] ?? {};

        final negociacao = Negociacao(
          id: resultado['id'] ?? '',
          imovel: resultado['imovel'] ?? '',
          cliente: resultado['cliente'] ?? '',
          corretor: resultado['corretor'] ?? '',
          etapas: resultado['etapas'] ??
              {}, // Usando um mapa vazio como valor padrão
          documentos: List<String>.from(resultado['documentos'] ?? []),
          resultados: resultados, // Usando o mapa de resultados
          data_cadastro: resultado['data_cadastro'] ?? '',
          data_ultima_atualizacao: resultado['data_ultima_atualizacao'] ?? '',
        );

        negociacoes.add(negociacao);
      });

      return negociacoes;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

 Future<List<Negociacao>> buscarMinhasNegociacoes() async {
  _items.clear();
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return [];
  }

  CollectionReference<Map<String, dynamic>> corretoresRef =
      FirebaseFirestore.instance.collection('corretores');
  QuerySnapshot<Map<String, dynamic>> corretoresSnapshot =
      await corretoresRef.where('uid', isEqualTo: user.uid).get();

  if (corretoresSnapshot.docs.isNotEmpty) {
    
    String corretorId = corretoresSnapshot.docs.first.id;
print("é corretor $corretorId");
    CollectionReference<Map<String, dynamic>> negociacoesRef =
        FirebaseFirestore.instance.collection('negociacoes');
    QuerySnapshot<Map<String, dynamic>> negociacoesSnapshot =
        await negociacoesRef.where('corretor', isEqualTo: corretorId).get();

    List<Negociacao> negociacoes = negociacoesSnapshot.docs.map((doc) {
      final resultado = doc.data();

      final Map<String, dynamic> resultados = resultado['resultados'] ?? {};

      return Negociacao(
        id: resultado['id'] ?? '',
        imovel: resultado['imovel'] ?? '',
        cliente: resultado['cliente'] ?? '',
        corretor: resultado['corretor'] ?? '',
        etapas: resultado['etapas'] ?? {},
        documentos: List<String>.from(resultado['documentos'] ?? []),
        resultados: resultados,
        data_cadastro: resultado['data_cadastro'] ?? '',
        data_ultima_atualizacao: resultado['data_ultima_atualizacao'] ?? '',
      );
    }).toList();

    return negociacoes;
  } else {
    CollectionReference<Map<String, dynamic>> clientesRef =
        FirebaseFirestore.instance.collection('clientes');
    QuerySnapshot<Map<String, dynamic>> clientesSnapshot =
        await clientesRef.where('uid', isEqualTo: user.uid).get();

    if (clientesSnapshot.docs.isNotEmpty) {
      String clienteId = clientesSnapshot.docs.first.id;
print("é cliente $clienteId");
      CollectionReference<Map<String, dynamic>> negociacoesRef =
          FirebaseFirestore.instance.collection('negociacoes');
      QuerySnapshot<Map<String, dynamic>> negociacoesSnapshot =
          await negociacoesRef.where('cliente', isEqualTo: clienteId).get();

      List<Negociacao> negociacoes = negociacoesSnapshot.docs.map((doc) {
        final resultado = doc.data();

        final Map<String, dynamic> resultados = resultado['resultados'] ?? {};

        return Negociacao(
          id: resultado['id'] ?? '',
          imovel: resultado['imovel'] ?? '',
          cliente: resultado['cliente'] ?? '',
          corretor: resultado['corretor'] ?? '',
          etapas: resultado['etapas'] ?? {},
          documentos: List<String>.from(resultado['documentos'] ?? []),
          resultados: resultados,
          data_cadastro: resultado['data_cadastro'] ?? '',
          data_ultima_atualizacao: resultado['data_ultima_atualizacao'] ?? '',
        );
      }).toList();

      return negociacoes;
    }
  }

  return []; // Se nenhum corretor ou cliente estiver associado ao usuário, retorne uma lista vazia
}
  Future<List<Negociacao>> adicionarNegociacao(
      String imovel, String cliente, String corretor) async {
    CollectionReference<Map<String, dynamic>> negociacoesRef =
        FirebaseFirestore.instance.collection('negociacoes');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await negociacoesRef.get();

      List<int> ids = querySnapshot.docs.map((doc) {
        return int.parse(doc.id);
      }).toList();

      int ultimoId = ids.isEmpty ? 0 : ids.reduce((a, b) => a > b ? a : b);
      int novoId = ultimoId + 1;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      final negociacao = Negociacao(
        id: novoId.toString(),
        imovel: imovel,
        cliente: cliente,
        corretor: corretor,
        etapas: {
          "visita": {
            "id": '',
            "status": "Não iniciado",
            "data": "",
            "observacao": "",
            "proposta_preco": "",
          },
          "proposta": {
            "status": "Não iniciado",
            "data": "",
            "observacao": "",
            "proposta_preco": "",
          },
          "fechamento": {
            "status": "Não iniciado",
            "data": "",
            "observacao": "",
            "proposta_preco": "",
          },
        },
        documentos: [],
        resultados: {
          'resultado': '',
          'data_conclusao': '',
          'preco_final': '',
          'motivo': '',
        },
        data_cadastro: formattedDate,
        data_ultima_atualizacao: formattedDate,
      );

      await negociacoesRef.doc(novoId.toString()).set({
        'id': negociacao.id,
        'imovel': negociacao.imovel,
        'cliente': negociacao.cliente,
        'corretor': negociacao.corretor,
        'etapas': negociacao.etapas,
        'documentos': negociacao.documentos,
        'resultados': negociacao.resultados,
        'data_cadastro': negociacao.data_cadastro,
        'data_ultima_atualizacao': negociacao.data_ultima_atualizacao,
      });

      List<Negociacao> negociacoes = [negociacao];
      CorretorList().adicionarNegociacaoAoCorretor(corretor, negociacao.id);
      ClientesList().adicionarNegociacaoAoCliente(cliente, negociacao.id);
      _items.add(negociacao);
      notifyListeners();
      return negociacoes;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return [];
    }
  }

  Future<void> atualizarNegociacao(Negociacao negociacao) async {
    CollectionReference<Map<String, dynamic>> negociacoesRef =
        FirebaseFirestore.instance.collection('negociacoes');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      await negociacoesRef.doc(negociacao.id).update({
        'imovel': negociacao.imovel,
        'cliente': negociacao.cliente,
        'corretor': negociacao.corretor,
        'etapas': negociacao.etapas,
        'documentos': negociacao.documentos,
        'resultados': negociacao.resultados,
        'data_ultima_atualizacao': formattedDate,
      });
      print('Negociação atualizada com sucesso!');
    } catch (e) {
      print('Erro ao atualizar a negociação: $e');
      throw e;
    }
  }

  List<Negociacao> get items => [..._items];

  void addProduct(Negociacao product) {
    _items.add(product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
