import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/clientes/clientesList.dart';
import 'cliente_item.dart';
import 'clientes_list.dart';

class ClientesHomeLista extends StatelessWidget {
  final bool isDarkMode;

  const ClientesHomeLista({Key? key, required this.isDarkMode}) : super(key: key);

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:
                              isDarkMode ? Colors.white : Colors.black54,),
            ),
          ),
          Expanded(
            child: Consumer<ClientesList>(
              builder: (context, clientesList, _) {
                return ListView.builder(
                  itemCount: clientesList.items.length,
                  itemBuilder: (context, index) {
                    final cliente = clientesList.items[index];
                    return ClienteItem(  cliente);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
