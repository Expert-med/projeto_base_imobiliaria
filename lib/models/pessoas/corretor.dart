import 'Pessoa.dart';

class Corretor extends Pessoa {
  String corretora;

  Corretor(String nome, String email, String cpf, String dataNascimento, this.corretora)
      : super(nome, email, cpf, dataNascimento);
}