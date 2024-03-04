import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/clientes/clientesList.dart';
import 'clientes_list.dart';

class ClientesHomeLista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Clientes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<ClientesList>(
              builder: (context, clientesList, _) {
                return _buildClientesList(clientesList);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientesList(ClientesList clientesList) {
    if (clientesList.items.isEmpty) {
      return Center(
        child: Text('Nenhum cliente disponível.'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: clientesList.items.map((cliente) {
            return ListTile(
              title: Text(cliente.name),
              subtitle: Text(cliente.email),
              onTap: () {
                // Ação ao tocar no cliente, se necessário
              },
            );
          }).toList(),
        ),
      );
    }
  }
}
