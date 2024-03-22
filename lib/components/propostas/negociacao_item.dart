import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/clientes/clientesList.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacao.dart';
import 'package:provider/provider.dart';
import '../../models/clientes/Clientes.dart';
import 'negociacao_info.dart';

class NegociacaoItem extends StatefulWidget {
  final bool isDarkMode;
  final int index;
  final int count;

  const NegociacaoItem(this.isDarkMode, this.index, this.count, {Key? key})
      : super(key: key);

  @override
  _NegociacaoItemState createState() => _NegociacaoItemState();
}

class _NegociacaoItemState extends State<NegociacaoItem> {
  @override
  Widget build(BuildContext context) {
    final negociacao = Provider.of<Negociacao>(context, listen: false);
    Color containerColor =
        widget.isDarkMode ? Colors.black : Color.fromARGB(255, 238, 238, 238);

    return FutureBuilder<Clientes?>(
      future: buscaCliente(negociacao.cliente),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Retorna um widget de carregamento enquanto o Future está em execução
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: containerColor,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: containerColor,
            child: Text('Erro ao carregar o cliente'),
          );
        } else {
          Clientes? cliente = snapshot.data;

          return Card(
            
             margin: EdgeInsets.only(bottom: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Negociação n° ${negociacao.id}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Cliente: ${cliente!.name}',
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 3,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NegociacaoInfoComponent(
                                isDarkMode: widget.isDarkMode,
                                negociacao: negociacao,
                                cliente: cliente,
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        icon: Icon(Icons.info),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Clientes?> buscaCliente(String idcliente) async {
    Clientes? cliente = await ClientesList().buscarClientePorId(idcliente);
    return cliente;
  }
}
