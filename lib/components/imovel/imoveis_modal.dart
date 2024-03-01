import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';

typedef OnImovelAdicionado = void Function(NewImovel cliente);

class ImoveisModal extends StatefulWidget {
  final NewImovelList imoveisList;
  final NewImovel? clienteSelecionado;
  final OnImovelAdicionado? onImovelAdicionado;

  const ImoveisModal({
    required this.imoveisList,
    this.clienteSelecionado,
    this.onImovelAdicionado,
  });

  @override
  _ImoveisModalState createState() => _ImoveisModalState();
}

class _ImoveisModalState extends State<ImoveisModal> {
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
            child: FutureBuilder<List<NewImovel>>(
              future: widget.imoveisList.buscarImoveis(),
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
                          .where((cliente) => cliente.id
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()))
                          .toList();
                  return ListView.builder(
                    itemCount: filteredClientes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final imovel = filteredClientes[index];
                      return ListTile(
                        title: Text(imovel.localizacao['endereco']
                                ['logradouro'] +
                            ', ' +
                            imovel.localizacao['endereco']['bairro'] +
                            ' - ' +
                            imovel.localizacao['endereco']['cidade'] +
                            ' / ' +
                            imovel.localizacao['endereco']['estado']),
                        subtitle: Text('ID do imóvel: ${imovel.id}'),
                        onTap: () async {
                          widget.onImovelAdicionado?.call(imovel!);
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
}
