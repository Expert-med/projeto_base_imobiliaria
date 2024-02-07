import 'package:flutter/material.dart';

class Imovel with ChangeNotifier {
  final String codigo;
  final String data;
   final List<Map<String, dynamic>> infoList; 
  final String link;
  bool isFavorite;

  Imovel({
    required this.codigo,
    required this.data,
    required this.infoList,
    required this.link,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}