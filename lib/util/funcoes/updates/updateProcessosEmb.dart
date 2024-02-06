import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class updateProcessosEmb {
  Future<void> atualizarFinalizadoNv1(
      DocumentReference hospitalDoc, bool? value, int idEmb) async {
    try {
      String idEmbalagem = idEmb.toString(); // Obtém o ID da embalagem
      String horaAtual = getCurrentDate();
      await hospitalDoc.collection("embalagem").doc(idEmbalagem).update(
        {
          'estoque': 0,
          'esterilizado': 10,
          'armazenamento': 20,
          'cirurgia': 30,
          'finalizado': 40,
          "data_finalizacao": horaAtual
        },
      );
      print('Valor atualizado no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    return formattedDate;
  }


   Future<void> atualizarArmazenamento( DocumentReference hospitalDoc, bool? value, int idEmb) async {
    try {
      String idEmbalagem = idEmb.toString();

      await hospitalDoc
          .collection("embalagem")
          .doc(idEmbalagem)
          .update({'armazenamento': value == true ? 20 : 0});
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

  Future<void> adicionarObsArma(DocumentReference hospitalDoc,   
  TextEditingController _obsArmController, 
  TextEditingController _obsArmSubLocalController, 
  int idEmb) async {
    try {
      String idEmbalagem =
          idEmb.toString(); // Obtém o ID da embalagem

      await hospitalDoc.collection("embalagem").doc(idEmbalagem).update({
        'obsArmazenamento': '${_obsArmController.text} - ${_obsArmSubLocalController.text}',
      });

      print("Campo 'obsArmazenamento' adicionado/atualizado com sucesso.");
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }


  Future<void> atualizarEsterelizado(DocumentReference hospitalDoc,   bool? value, int idEmb) async {
    try {
      String idEmbalagem =
         idEmb.toString(); // Obtém o ID da embalagem

      await hospitalDoc
          .collection("embalagem")
          .doc(idEmbalagem)
          .update({'esterilizado': value == true ? 10 : 0});
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

  
  Future<void> adicionarEsteri(DocumentReference hospitalDoc,   TextEditingController _obsEstereController, int idEmb) async {
    try {
      String idEmbalagem =
          idEmb.toString(); // Obtém o ID da embalagem

      await hospitalDoc.collection("embalagem").doc(idEmbalagem).update({
        'obsEsterilizado': _obsEstereController.text,
      });

      print("Campo 'obsEsterilizado' adicionado/atualizado com sucesso.");
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

  Future<void> atualizarCirurgia(DocumentReference hospitalDoc,   bool? value, int idEmb) async {
    try {
      String idEmbalagem =
          idEmb.toString(); // Obtém o ID da embalagem

      await hospitalDoc.collection("embalagem").doc(idEmbalagem).update(
        {'cirurgia': value == true ? 30 : 0},
      );
      print('Valor atualizado no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

    Future<void> atualizarEstoque(DocumentReference hospitalDoc,   bool? value, int idEmb) async {
    try {
      String idEmbalagem = idEmb.toString();

      await hospitalDoc
          .collection("embalagem")
          .doc(idEmbalagem)
          .update({'estoque': value == true ? 0 : 0});
      print('Valor atualizado no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

    double obterMaiorValor(Map<String, dynamic> embalagemData) {
  List<String> campos = [
    'estoque',
    'finalizado',
    'armazenamento',
    'esterilizado',
    'cirurgia'
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

  return maiorValor;
}
  

   void atualizarDisponibilidadeCaixa(DocumentReference hospitalDoc,int idCaixa) async {
    try {
      String idCaixaAtual = idCaixa.toString(); // Obtém o ID da embalagem

      await hospitalDoc.collection("caixas").doc(idCaixaAtual).update(
        {
          'disponibilidade': 1,
        },
      );
      print('Valor atualizado no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

}
