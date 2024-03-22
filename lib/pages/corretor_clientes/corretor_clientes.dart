import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/models/clientes/clientesList.dart';
import 'package:provider/provider.dart';

import '../../components/clientes/cliente_item.dart';
import '../../components/clientes/clientes_modal.dart';
import '../../models/clientes/Clientes.dart';
import '../../theme/appthemestate.dart';

class CorretorClientesPage extends StatefulWidget {
  
  CorretorClientesPage();
  @override
  _CorretorClientesPageState createState() => _CorretorClientesPageState();
}

class _CorretorClientesPageState extends State<CorretorClientesPage> {
  List<Clientes> _clientes = [];
  TextEditingController _searchController = TextEditingController();
 
  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clientesList = Provider.of<ClientesList>(context);
 final themeNotifier = Provider.of<AppThemeStateNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Clientes'),
      ),
     
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Procurar',
                labelStyle: TextStyle(
                    color: !themeNotifier.isDarkModeEnabled
 ? Colors.black : Colors.white),
                prefixIcon: Icon(
                  Icons.search,
                ),
                filled: true,
                fillColor: !themeNotifier.isDarkModeEnabled

                    ? Colors.grey[200]
                    : Colors.black, // Defina a cor de fundo como cinza
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: !themeNotifier.isDarkModeEnabled
 ? Colors.grey : Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Para reconstruir a lista com base na busca
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Clientes>>(
              future: clientesList.buscarClientesDoCorretor(),
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
                  _clientes = snapshot.data ?? [];
                  if (_clientes.isEmpty) {
                    return Center(
                      child: Text('Nenhum cliente adicionado'),
                    );
                  } else {
                    // Filtrar os clientes com base na busca
                    List<Clientes> clientesFiltrados =
                        _clientes.where((cliente) {
                      String searchTerm = _searchController.text.toLowerCase();
                      return cliente.name.toLowerCase().contains(searchTerm);
                    }).toList();

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: clientesFiltrados.length,
                      itemBuilder: (ctx, i) {
                        final cliente = clientesFiltrados[i];
                        return ClienteItem(cliente);
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
      drawer: CustomMenu(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
        onPressed: () {
          setState(() {
            themeNotifier.enableDarkMode(!themeNotifier.isDarkModeEnabled);
          });
        },
        child: Icon(Icons.lightbulb),
      ),
          SizedBox(height: 16), // Espaçamento entre os botões
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ClientesModal(
                    parametro_clientes_do_corretor: 0,
                    clientesList: clientesList,
                    onClienteAdicionado: (cliente) {
                      setState(() {
                        _clientes.add(cliente);
                      });
                    },
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
