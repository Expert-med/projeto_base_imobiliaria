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
  

  set status(String newStatus) {
    this.status = newStatus; // Correção aqui
    notifyListeners(); // Notifica os listeners sobre a mudança no status
  }

  set observacoes_gerais(String newObservacoes_gerais) {
    this.observacoes_gerais = newObservacoes_gerais; // Correção aqui
    notifyListeners(); // Notifica os listeners sobre a mudança nas observações gerais
  }

  set data(String newData) {
    this.data = newData; // Correção aqui
    notifyListeners(); // Notifica os listeners sobre a mudança na data
  }

  set hora_inicio(String newHoraInicio) {
    this.hora_inicio = newHoraInicio; // Correção aqui
    notifyListeners(); // Notifica os listeners sobre a mudança na hora de início
  }

  set hora_fim(String newHoraFim) {
    this.hora_fim = newHoraFim; // Correção aqui
    notifyListeners(); // Notifica os listeners sobre a mudança na hora de término
  }
  
}
