import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/clientes/Clientes.dart';

import 'package:provider/provider.dart';

import 'cliente_item.dart';

class ListaClientes extends StatelessWidget {
  final bool isDarkMode;
  final List<Clientes> clientes;

  const ListaClientes(this.clientes, this.isDarkMode, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: clientes.length,
      itemBuilder: (ctx, i) {
        final cliente = clientes[i];
        return ClienteItem(cliente);
      },
    );
  }
}
