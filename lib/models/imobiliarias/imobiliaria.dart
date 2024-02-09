import 'package:flutter/material.dart';

class Imobiliaria with ChangeNotifier {
  final String id ;
  final String nome ;
  final String url_base ;
  final String url_logo ;
   final List<Map<String, dynamic>> seletoresList; 

  Imobiliaria({
    required this.id,
    required this.nome,
    required this.url_base,
    required this.url_logo,
    required this.seletoresList,

  });


}