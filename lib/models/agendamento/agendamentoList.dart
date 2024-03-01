import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_imobiliaria/models/agendamento/agendamento.dart';

import '../clientes/clientesList.dart';
import '../corretores/corretorList.dart';

class AgendamentoList with ChangeNotifier {
  late final List<Agendamento> _items;

  AgendamentoList() {
    _items = [];
    _carregarAgendamento();
  }

  Future<void> _carregarAgendamento() async {
    final List<Agendamento> agendamento = await buscarAgendamentos();
    _items.addAll(agendamento);
    notifyListeners();
  }

  Future<List<Agendamento>> buscarAgendamentos() async {
    CollectionReference<Map<String, dynamic>> agendamentoRef =
        FirebaseFirestore.instance.collection('agendamentos');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await agendamentoRef.get();

      List<Agendamento> agendamentos = [];

      querySnapshot.docs.forEach((doc) {
        final resultado = doc.data();

        final negociacao = Agendamento(
          id: resultado['id'] ?? '',
          data: resultado['data'] ?? '',
          cliente: resultado['cliente'] ?? '',
          corretor: resultado['corretor'] ?? '',
          imoveis_visitados: resultado['imoveis_visitados'] ??
              {}, // Usando um mapa vazio como valor padrão
          hora_fim: resultado['hora_fim'],
          hora_inicio: resultado['hora_inicio'], // Usando o mapa de resultados
          status: resultado['status'] ?? '',
          observacoes_gerais: resultado['observacoes_gerais'] ?? '',
        );

        agendamentos.add(negociacao);
      });

      return agendamentos;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  
  Future<List<Agendamento>> buscarAgendamentosDoCorretorAtual(String idCorretor) async {
  CollectionReference<Map<String, dynamic>> agendamentoRef =
      FirebaseFirestore.instance.collection('agendamentos');

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await agendamentoRef.where('corretor', isEqualTo: idCorretor).get();

    List<Agendamento> agendamentos = [];

    querySnapshot.docs.forEach((doc) {
      final resultado = doc.data();

      final negociacao = Agendamento(
        id: resultado['id'] ?? '',
        data: resultado['data'] ?? '',
        cliente: resultado['cliente'] ?? '',
        corretor: resultado['corretor'] ?? '',
        imoveis_visitados: resultado['imoveis_visitados'] ??
            {}, // Usando um mapa vazio como valor padrão
        hora_fim: resultado['hora_fim'],
        hora_inicio: resultado['hora_inicio'], // Usando o mapa de resultados
        status: resultado['status'] ?? '',
        observacoes_gerais: resultado['observacoes_gerais'] ?? '',
      );

      agendamentos.add(negociacao);
    });

    return agendamentos;
  } catch (e) {
    print('Erro ao buscar os imóveis: $e');
    return []; // Retorna uma lista vazia em caso de erro
  }
}


  Future<List<Agendamento>> adicionarAgendamento(
      String cliente, String corretor, String observacoes,  Map<String, dynamic> imoveis, String status,) async {
    CollectionReference<Map<String, dynamic>> agendamentoRef =
        FirebaseFirestore.instance.collection('agendamentos');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await agendamentoRef.get();

      List<int> ids = querySnapshot.docs.map((doc) {
        return int.parse(doc.id);
      }).toList();

      int ultimoId = ids.isEmpty ? 0 : ids.reduce((a, b) => a > b ? a : b);
      int novoId = ultimoId + 1;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      final agendamento = Agendamento(
        id: novoId.toString(),
        data: '',
        hora_fim: '',
        hora_inicio: '',
        imoveis_visitados: imoveis,
        observacoes_gerais: '',
        status: '',
        cliente: cliente,
        corretor: corretor,
      );

      await agendamentoRef.doc(novoId.toString()).set({
        'id': agendamento.id,
        'data': agendamento.data,
        'cliente': agendamento.cliente,
        'corretor': agendamento.corretor,
        'hora_fim': agendamento.hora_fim,
        'hora_inicio': agendamento.hora_inicio,
        'imoveis_visitados': agendamento.imoveis_visitados,
        'observacoes_gerais': agendamento.observacoes_gerais,
        'status': agendamento.status
      });

      List<Agendamento> agendamentos = [agendamento];
      CorretorList().adicionarVisitaAoCorretor(corretor, agendamento.id);
      ClientesList().adicionarVisitaAoCliente(cliente, agendamento.id);
      _items.add(agendamento);
      notifyListeners();
      return agendamentos;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return [];
    }
  }

  Future<void> atualizarAgendamento(Agendamento agendamento) async {
    CollectionReference<Map<String, dynamic>> agendamentoRef =
        FirebaseFirestore.instance.collection('agendamentos');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      await agendamentoRef.doc(agendamento.id).update({
        'id': agendamento.id,
        'data': agendamento.data,
        'cliente': agendamento.cliente,
        'corretor': agendamento.corretor,
        'hora_fim': agendamento.hora_fim,
        'hora_inicio': agendamento.hora_inicio,
        'imoveis_visitados': agendamento.imoveis_visitados,
        'observacoes_gerais': agendamento.observacoes_gerais,
        'status': agendamento.status
      });
      print('Negociação atualizada com sucesso!');
    } catch (e) {
      print('Erro ao atualizar a negociação: $e');
      throw e;
    }
  }

  List<Agendamento> get items => [..._items];

  void addProduct(Agendamento product) {
    _items.add(product);
    notifyListeners();
  }
}
