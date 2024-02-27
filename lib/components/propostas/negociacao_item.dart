import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/models/clientes/clientesList.dart';
import 'package:projeto_imobiliaria/models/imoveis/imovel.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacao.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    final product = Provider.of<Negociacao>(context, listen: false);

    return AspectRatio(
      aspectRatio: 25 / 13,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.count,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: product.cliente,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            },
          ),
          footer: _buildFooter(product),
        ),
      ),
    );
  }

  Widget _buildFooter(Negociacao product) {
    Color containerColor =
        widget.isDarkMode ? Colors.black : Color.fromARGB(255, 238, 238, 238);

    return FutureBuilder<Clientes?>(
      future: buscaCliente(product.cliente),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Retorna um widget de carregamento enquanto o Future está em execução
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: containerColor,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Retorna um widget de erro se o Future falhar
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: containerColor,
            child: Text('Erro ao carregar o cliente'),
          );
        } else {
          // Retorna o widget com base no resultado do Future
          Clientes? cliente = snapshot.data;
          print('cliente buscado ${cliente!.name}');
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: containerColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.id ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black54,
                        ),
                      ),
                      Text(
                        cliente.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4),
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
                              negociacao: product,
                              cliente: cliente,
                            ),
                            fullscreenDialog:
                                true, 
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
