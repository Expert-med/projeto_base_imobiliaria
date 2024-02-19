import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/models/clientes/clientesList.dart';

import 'package:provider/provider.dart';

import '../../components/clientes/clientes_list.dart';
import '../../components/clientes/clientes_modal.dart';

class CorretorClientesPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final clientesList = Provider.of<ClientesList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Clientes'),
      ),
      backgroundColor: Colors.black54, // Define o fundo da página como branco
      body: FutureBuilder(
        future: clientesList.buscarClientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os seus clientes'),
            );
          } else {
            final clientes = clientesList.items;

            if (clientes.isEmpty) {
              return Center(
                child: Text('Nenhum cliente adicionado',),
              );
            } else {
              return ListaClientes(clientes, false); // Passe a lista de clientes para ListaClientes
            }
          }
        },
      ),
      drawer: CustomMenu(isDarkMode: false),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ClientesModal(clientes: clientesList.items,);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
