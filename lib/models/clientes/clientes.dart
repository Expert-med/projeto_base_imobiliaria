import 'package:flutter/material.dart';

class Clientes with ChangeNotifier {
  final String id;
  final String name;
  final String email;
  String imageUrl; // Remova o modificador final

  final int tipoUsuario;

  Clientes({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.tipoUsuario,
  });
}
