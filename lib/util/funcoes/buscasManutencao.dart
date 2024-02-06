import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuscasManutencao {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> buscarInfoCliente(String idCliente, int isHospital) async {
    String nomeCliente = '';

    if (isHospital == 1) {
      CollectionReference hospitalCollection = db.collection("hospitais");
      QuerySnapshot querySnapshot =
          await hospitalCollection.where("id", isEqualTo: idCliente).get();
      try {
        List<DocumentSnapshot> clienteDocs = querySnapshot.docs;
        for (var clienteDoc in clienteDocs) {
          nomeCliente = clienteDoc['nome'];
          print(clienteDoc['nome']);
        }
      } catch (error) {
        print('Erro ao buscar os dados dos clientes: $error');
      }
    } else {
      CollectionReference clienteCollection = db.collection("clientes");
      QuerySnapshot querySnapshot =
          await clienteCollection.where("id", isEqualTo: idCliente).get();
      try {
        List<DocumentSnapshot> clienteDocs = querySnapshot.docs;
        for (var clienteDoc in clienteDocs) {
          nomeCliente = clienteDoc['nome'];
        }
      } catch (error) {
        print('Erro ao buscar os dados dos clientes: $error');
      }
    }

    return nomeCliente; // Retorna o nome do cliente
  }

  Future<List<Map<String, dynamic>>> buscarServicosPrestados(
      List<Map<String, dynamic>> servicosDisponiveis,
      TextEditingController idClienteController) async {
    List<Map<String, dynamic>> servicosPrestados = [];
    print('Entrou em buscarServiPrestados');
    CollectionReference manutencaoDoc = db.collection("manutencao");
    QuerySnapshot querySnapshot = await manutencaoDoc.get();

    try {
      List<String> servicosRealizadosIds = [];
      for (var doc in querySnapshot.docs) {
        List<dynamic> servicosRealizados = doc['reparo_Realizados'];
        print('servicosRealizados $servicosRealizados');
        if (servicosRealizados != null && servicosRealizados is List) {
          servicosRealizadosIds.addAll(servicosRealizados.cast<String>());
        }
      }

      if (servicosRealizadosIds.isNotEmpty) {
        CollectionReference servicoRealizadoCollection =
            db.collection("servico_realizado");
        QuerySnapshot servicoSnapshot = await servicoRealizadoCollection
            .where('id', whereIn: servicosRealizadosIds)
            .get();

        List<Map<String, dynamic>> servicoData = servicoSnapshot.docs
            .map<Map<String, dynamic>>(
                (doc) => doc.data() as Map<String, dynamic>)
            .toList();

        for (var servicoRealizado in servicoData) {
          if (!_isServicoExist(servicoRealizado['id'], servicosDisponiveis) &&
              servicoRealizado['cliente'] == idClienteController.text) {
            servicosPrestados.add(servicoRealizado);
            print(servicosPrestados);
          }
        }
      }
    } catch (error) {
      print('Erro ao buscar os instrumentais dos clientes instancia: $error');
    }

    return servicosPrestados;
  }

  bool _isServicoExist(
      String id, List<Map<String, dynamic>> servicosDisponiveis) {
    return servicosDisponiveis.any((servico) => servico['id'] == id);
  }

  double obterMaiorValor(Map<String, dynamic> embalagemData) {
    List<String> campos = [
      'em_andamento',
      'finalizado',
      'concluido',
    ];

    double maiorValor = 0;

    for (var campo in campos) {
      if (embalagemData.containsKey(campo)) {
        // Use '?? 0.0' para garantir que mesmo valores inteiros sejam tratados como double.
        double valorCampo = (embalagemData[campo] ?? 0.0).toDouble();
        if (valorCampo > maiorValor) {
          maiorValor = valorCampo;
        }
      }
    }
    print('maior valor: $maiorValor');

    return maiorValor;
  }
}
