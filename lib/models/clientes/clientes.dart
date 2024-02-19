import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Clientes with ChangeNotifier {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final int tipoUsuario;

  Clientes({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.tipoUsuario,
  });

}
