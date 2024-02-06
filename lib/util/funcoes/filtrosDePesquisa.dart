import 'package:intl/intl.dart';

class FiltrosDePesquisas {
   List<Map<String, dynamic>> filterEmbalagens(
      List<Map<String, dynamic>> embalagens, int imprimiuValue) {
    return embalagens.where((embalagem) {
      print(embalagem['imprimiu'] == imprimiuValue);
      return embalagem['imprimiu'] == imprimiuValue;
    }).toList();
  }
}
