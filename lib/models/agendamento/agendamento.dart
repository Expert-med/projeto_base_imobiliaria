import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Agendamento with ChangeNotifier {
  final String id;
  final String data;
  final String hora_inicio;
  final String hora_fim;
  final String cliente;
  final String corretor;
  final String observacoes_gerais;
  final Map<String, dynamic> imoveis_visitados;
  final String status;

  Agendamento({
    required this.id,
    required this.data,
    required this.hora_inicio,
    required this.hora_fim,
    required this.cliente,
    required this.corretor,
    required this.imoveis_visitados,
    required this.status,
    required this.observacoes_gerais,
  });
}
