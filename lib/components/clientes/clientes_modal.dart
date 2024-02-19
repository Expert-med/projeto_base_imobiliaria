import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/clientes/Clientes.dart';
import '../../models/clientes/clientesList.dart';

typedef OnClienteAdicionado = void Function(Clientes cliente);

class ClientesModal extends StatefulWidget {
  final ClientesList clientesList;
  final Clientes? clienteSelecionado;
  final OnClienteAdicionado? onClienteAdicionado;

  const ClientesModal({
    required this.clientesList,
    this.clienteSelecionado,
    this.onClienteAdicionado,
  });

  @override
  _ClientesModalState createState() => _ClientesModalState();
}

class _ClientesModalState extends State<ClientesModal> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Procurar',
              prefixIcon: Icon(
                Icons.search,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Colors.grey), // Cor padrão do contorno
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Clientes>>(
              future:
                  widget.clientesList.buscarClientesNaoPertencemAoCorretor(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar os clientes'),
                  );
                } else {
                  final clientes = snapshot.data ?? [];
                  final filteredClientes = _searchText.isEmpty
                      ? clientes
                      : clientes
                          .where((cliente) => cliente.name
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()))
                          .toList();
                  return ListView.builder(
                    itemCount: filteredClientes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final cliente = filteredClientes[index];
                      return ListTile(
                        title: Text(cliente.name),
                        subtitle: Text('ID do cliente: ${cliente.id}'),
                        onTap: () async {
                          _adicionarCliente(cliente.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _adicionarCliente(String clienteId) async {
    final user = FirebaseAuth.instance.currentUser;
    final corretorId = user?.uid ?? '';

    try {
      final firestore = FirebaseFirestore.instance;

      final corretoresRef = firestore.collection('corretores');

      final querySnapshot =
          await corretoresRef.where('uid', isEqualTo: corretorId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;

        final collection = corretoresRef.doc(docId).collection('meus_clientes');

        await collection.doc(clienteId).set({'clienteId': clienteId});

        final clienteAdicionado =
            await widget.clientesList.buscarClientePorId(clienteId);

        widget.onClienteAdicionado?.call(clienteAdicionado!);
        await widget.clientesList.buscarClientesDoCorretor();
      } else {
        throw Exception('Corretor não encontrado com o ID fornecido');
      }
    } catch (error) {
      print('Erro ao adicionar cliente: $error');
      throw error;
    }
  }
}
