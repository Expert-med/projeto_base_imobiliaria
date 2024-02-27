import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_imobiliaria/models/corretores/corretorList.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacao.dart';

class NegociacaoList with ChangeNotifier {
  late final List<Negociacao> _items;

  NegociacaoList() {
    _items = [];
    _carregarNegociacoes();
  }

  Future<void> _carregarNegociacoes() async {
    final List<Negociacao> negociacoes = await buscarNegociacoes();
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

      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final resultado = doc.data();
        final infoList = resultado['info'] ?? <String, dynamic>{};
        final List<dynamic>? resultadosData =
            resultado['resultados'] as List<dynamic>?;
        final List<Map<String, dynamic>> resultados = resultadosData != null
            ? resultadosData
                .map<Map<String, dynamic>>(
                    (etapa) => etapa as Map<String, dynamic>)
                .toList()
            : [];

            

        final negociacao = Negociacao(
          id: resultado['id'] ?? '',
          imovel: resultado['imovel'] ?? '',
          cliente: resultado['cliente'] ?? '',
          corretor: resultado['corretor'] ?? '',
          etapas: resultado['etapas'],
          documentos: List<String>.from(resultado['documentos'] ?? []),
          resultados: resultados,
          data_cadastro: resultado['data_cadastro'] ?? '',
          data_ultima_atualizacao: resultado['data_ultima_atualizacao'] ?? '',
        );

        negociacoes.add(negociacao);
      });
  print('negociacoes: $negociacoes');
      return negociacoes;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
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
            "status": "",
            "data": "",
            "observacao": "",
            "proposta_preco": "",
          },
          "proposta": {
            "status": "",
            "data": "",
            "observacao": "",
            "proposta_preco": "",
          },
          "fechamento": {
            "status": "",
            "data": "",
            "observacao": "",
            "proposta_preco": "",
          },
        },
        documentos: [],
        resultados: [],
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
      return negociacoes;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return [];
    }
  }

  List<Negociacao> get items => [..._items];

  void addProduct(Negociacao product) {
    _items.add(product);
    notifyListeners();
  }
}
