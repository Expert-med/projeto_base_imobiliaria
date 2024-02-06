import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cnpj_model.dart';

class CNPJRepository {
  Future<CNPJModel> ConsultarCNPJ(String cnpj) async {
    final response = await http.get(Uri.parse("https://publica.cnpj.ws/cnpj/$cnpj"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return CNPJModel.fromJson(json);
    } else {
      // Se a resposta não for 200, você pode lidar com erros aqui, por exemplo:
      throw Exception('Falha ao consultar CNPJ: ${response.statusCode}');
    }
  }
}
