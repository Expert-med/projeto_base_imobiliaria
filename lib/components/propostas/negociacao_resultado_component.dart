import 'package:flutter/material.dart';

import '../../models/clientes/Clientes.dart';

class NegociacaoResultadoComponent extends StatelessWidget {
  final bool isDarkMode;
  final Map<String, dynamic> resultado;

  NegociacaoResultadoComponent(
      {required this.isDarkMode, required this.resultado});

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
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 2),
                      child: Text(
                        'Resultado da Negociação: ${resultado['resultado'] != '' ? resultado['resultado'] : 'Não informado'}  ',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 2),
                      child: Text(
                        'Observações da venda: ${resultado['motivo'] != '' ? resultado['motivo'] : 'Não informado'} ',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 2),
                      child: Text(
                        'Preço final: ${resultado['preco_final'] != '' ? resultado['preco_final'] : 'Não informado'} ',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
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
