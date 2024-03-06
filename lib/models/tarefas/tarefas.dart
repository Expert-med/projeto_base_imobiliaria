import 'package:flutter/material.dart';

class TarefasCorretor with ChangeNotifier {
  final String id;
  final String titulo;
  final String descricao;
   bool feita;
  
  TarefasCorretor({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.feita
  });
}
