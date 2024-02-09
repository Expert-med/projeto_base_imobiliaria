import 'dart:io';
import 'package:projeto_imobiliaria/core/services/cadastros/cadastro_firebase_service.dart';

abstract class CadastroService {

  Future<void> cadastroImobiliaria(
    String name,
    String url_base,
    String url_logo,
  );



  factory CadastroService() {
    return CadastroFirebaseService();
  }
}
