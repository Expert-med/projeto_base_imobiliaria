import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  final String endereco;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    required this.endereco
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}