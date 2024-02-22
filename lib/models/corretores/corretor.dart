import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Corretor with ChangeNotifier {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final String imageBanner;
   final String permissoes;
  final int tipoUsuario;
  final String creci;
  final String textoCorretor;
  final List<String> imoveisCadastrados;
  final String contato;

  Corretor({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.imageBanner,
    required this.permissoes,
    required this.tipoUsuario,
    required this.creci,
    required this.textoCorretor,
    required this.imoveisCadastrados,
    required this.contato,
  });

}
