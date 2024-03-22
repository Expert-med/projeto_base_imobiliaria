import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Corretor with ChangeNotifier {
  final String id;
  final String name;
  final int tipoUsuario;
  final String email;
  final String logoUrl;
  final String dataCadastro;
  final String permissoes;
  final String uid;
  final List<String> imoveisCadastrados;
  final List<String> imoveisFavoritos;
  final List<String> visitas;
  final List<String> negociacoes;
  final Map<String, dynamic> contato;
  final Map<String, dynamic> dadosProfissionais;
  final Map<String, dynamic> metas;
  final Map<String, dynamic> desempenhoAtualMetas;
  final Map<String, dynamic> infoBanner;

  Corretor(
      {required this.id,
      required this.name,
      required this.email,
      required this.logoUrl,
      required this.dataCadastro,
      required this.permissoes,
      required this.uid,
      required this.tipoUsuario,
      required this.imoveisFavoritos,
      required this.imoveisCadastrados,
      required this.visitas,
      required this.negociacoes,
      required this.contato,
      required this.dadosProfissionais,
      required this.metas,
      required this.desempenhoAtualMetas,
      required this.infoBanner});

      
}
