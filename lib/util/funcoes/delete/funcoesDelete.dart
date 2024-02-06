import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FuncoesDelete{
Future<void> removeInstrumental(DocumentReference clienteDoc, String instrumentalRemover) async {
  try {
    DocumentReference instrumentalRef = clienteDoc.collection("instrumentais").doc(instrumentalRemover);

    await instrumentalRef.delete();
  } catch (error) {
    print("Erro ao remover instrumental: $error");
  }
}

Future<void> removeManutencao(DocumentReference manutencaoDoc, String idServico) async {
  print('$manutencaoDoc - $idServico');
  try {
    DocumentReference manutecaoRef = manutencaoDoc.collection("servico").doc(idServico);

    await manutecaoRef.delete();
  } catch (error) {
    print("Erro ao remover instrumental: $error");
  }
}

Future<void> removeRelatorio(DocumentReference manutencaoDoc, String idRelatorio) async {
  print('$manutencaoDoc - $idRelatorio');
  try {
    DocumentReference manutecaoRef = manutencaoDoc.collection("relatorio").doc(idRelatorio);

    await manutecaoRef.delete();
  } catch (error) {
    print("Erro ao remover instrumental: $error");
  }
}

}