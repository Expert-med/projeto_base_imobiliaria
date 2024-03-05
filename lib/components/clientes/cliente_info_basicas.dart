import 'package:flutter/material.dart';

import '../../models/clientes/Clientes.dart';

class PessoaInfoBasica extends StatelessWidget {
  final bool isDarkMode;
  final Clientes cliente;


  PessoaInfoBasica({required this.isDarkMode, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
       
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nome: ${cliente.name} ',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Informações de contato',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 2),
                      child: Text(
                        'Telefone: ${cliente.contato['celular'] != '' ? cliente.contato['celular'] : 'Não informado'} ',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 2),
                      child: Text(
                        'Email: ${cliente.contato['email'] != '' ? cliente.contato['email'] : 'Não informado'} ',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width:
                      20), // Adicione um espaço entre as duas colunas
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Endereço do cliente',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (cliente.contato['endereco']['cep'] != '') ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Text(
                              'CEP: ${cliente.contato['endereco']['cep']} ',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            Spacer(flex: 1),
                            Text(
                              'Estado: ${cliente.contato['endereco']['estado']} ',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Endereço: ${cliente.contato['endereco']['logradouro']} ',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Bairro: ${cliente.contato['endereco']['bairro']} ',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Cidade: ${cliente.contato['endereco']['cidade']} ',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Não informado ',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
