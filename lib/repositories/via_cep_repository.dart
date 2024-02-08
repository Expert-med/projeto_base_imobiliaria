import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cep/via_cep_model.dart';

class ViaCepRepository {
  Future<ViaCepModel> consultarCep(String cep) async {
    final response = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return ViaCepModel.fromJson(json);
    } else {
      // Se a resposta não for 200, você pode lidar com erros aqui, por exemplo:
      throw Exception('Falha ao consultar CEP: ${response.statusCode}');
    }
  }
}
