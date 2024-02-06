import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateConfiguracoesAdm {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> atualizarInfoHospital(
    String idHospital,
    String novoNomeHospital,
    int novoTipoEmbalagem,
    int novoTipoConta,
        String emailHospital,
    String cnpjHospital,

  ) async {
    // Crie um mapa com os valores atualizados
    Map<String, dynamic> updatedData = {
      'nome': novoNomeHospital,
      'nivelEmbalagem': novoTipoEmbalagem,
      'tipoConta': novoTipoConta,
      'email':emailHospital,
      'cnpj':cnpjHospital,
    };

    try {
      // Atualize o documento no Firebase Firestore
      await db
          .collection('hospitais')
          .doc(idHospital)
          .update(updatedData);
      print('Valores atualizados com sucesso no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar os valores no Firebase Firestore: $error');
    }
  }

  Future<void> atualizarInfoCliente(
    String idCliente,
    String novoNomeHospital,
    int novoTipoEmbalagem,
    int novoTipoConta,
  ) async {
    // Crie um mapa com os valores atualizados
    Map<String, dynamic> updatedData = {
      'nome': novoNomeHospital,
      'nivelEmbalagem': novoTipoEmbalagem,
      'tipoConta': novoTipoConta,
    };

    try {
      // Atualize o documento no Firebase Firestore
      await db
          .collection('clientes')
          .doc(idCliente)
          .update(updatedData);
      print('Valores atualizados com sucesso no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar os valores no Firebase Firestore: $error');
    }
  }

    void salvarAlteracoesNome(DocumentReference hospitalDoc, TextEditingController _nomeController) async {
    if (hospitalDoc != null) {
      try {
        DocumentSnapshot snapshot = await hospitalDoc.get();
        if (snapshot.exists) {
          await hospitalDoc.update({"nome": _nomeController.text});
        } else {
          print('Hospital document not found.');
        }
      } catch (e) {
        print('Error fetching hospital data: $e');
      }
    } else {
      print('Hospital document reference is null.');
    }
  }
}
