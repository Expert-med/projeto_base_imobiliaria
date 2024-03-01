import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/models/agendamento/agendamento.dart';

import '../../models/clientes/Clientes.dart';
import '../../models/clientes/clientesList.dart';
import '../../pages/agendamentos/info_agendamento.dart';

class AgendamentoItem extends StatelessWidget {
  final bool isDarkMode;
  final Agendamento agendamento;

  const AgendamentoItem(this.isDarkMode, this.agendamento, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: FutureBuilder<Clientes?>(
        future: buscaCliente(agendamento.cliente),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro ao carregar o cliente');
          } else {
            Clientes? cliente = snapshot.data;

            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: IntrinsicHeight(
                        child: Text(
                          'Visita n° ${agendamento.id}',
                          style: TextStyle(
                            color: !isDarkMode ? Colors.black : Colors.white,
                            fontSize: isSmallScreen ? 15 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: IntrinsicHeight(
                        child: Text(
                          'Cliente: ${cliente!.name}',
                          style: TextStyle(
                            fontSize: 14,
                            color: !isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    print(agendamento);
                    print(cliente);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgendamentoInfoComponent(
                          isDarkMode: isDarkMode,
                          agendamento: agendamento,
                          cliente: cliente,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: !isDarkMode ? Colors.black : Colors.white,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.info,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<Clientes?> buscaCliente(String idcliente) async {
    Clientes? cliente = await ClientesList().buscarClientePorId(idcliente);
    return cliente;
  }
}
