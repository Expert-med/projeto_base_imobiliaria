import 'package:flutter/material.dart';

class Negociacao with ChangeNotifier {
  final String id;
  final String imovel;
  final String cliente;
  final String corretor;
  final Map<String, dynamic> etapas;
  final List<String> documentos;
  final Map<String, dynamic> resultados;
  final String data_cadastro;
  final String data_ultima_atualizacao;
  
  Negociacao({
    required this.id,
    required this.imovel,
    required this.cliente,
    required this.corretor,
    required this.etapas,
    required this.documentos,
    required this.resultados,
    required this.data_cadastro,
    required this.data_ultima_atualizacao,
  });
}
