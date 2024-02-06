import 'package:flutter/material.dart';

Color darkenColor(Color color, double factor) {
  assert(factor >= 0 && factor <= 1, 'O fator de escurecimento deve estar entre 0 e 1.');

  int red = (color.red * (1 - factor)).round();
  int green = (color.green * (1 - factor)).round();
  int blue = (color.blue * (1 - factor)).round();

  return Color.fromRGBO(red, green, blue, 1);
}
