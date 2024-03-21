import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/clientes/Clientes.dart';
import '../imovel/imovel_grid_favorites.dart';
import 'cliente_preferences.dart';

class ClienteInfoCorretor extends StatefulWidget {
  final Clientes cliente;

  const ClienteInfoCorretor({required this.cliente, Key? key})
      : super(key: key);

  @override
  _ClienteInfoCorretorState createState() => _ClienteInfoCorretorState();
}

class _ClienteInfoCorretorState extends State<ClienteInfoCorretor> {
  List<String> imoveisFavoritos = [];
  List<String> userPreferences = [];

  @override
  void initState() {
    super.initState();
    _fetchImoveisFavoritos();
  }

  Future<void> _fetchImoveisFavoritos() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clientes')
          .where('id', isEqualTo: widget.cliente.id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          imoveisFavoritos =
              List<String>.from(snapshot.docs.first['imoveis_favoritos']);
          userPreferences =
              List<String>.from(snapshot.docs.first['preferencias']) ?? [];
        });
      }
    } catch (error) {
      print('Erro ao buscar informações do cliente: $error');
    }
  }

  void _addUserPreference(String preference) async {
    setState(() {
      userPreferences.add(preference);
    });

    try {
      await FirebaseFirestore.instance
          .collection('clientes')
          .doc(widget.cliente.id)
          .update({
        'preferencias': FieldValue.arrayUnion([preference]),
      });
    } catch (error) {
      print('Erro ao adicionar preferência: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cliente ${widget.cliente.name} (${widget.cliente.id})',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Informações do Cliente',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Cliente: ${widget.cliente.name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Email: ${widget.cliente.email}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Endereço:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left:8, right: 8, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                'CEP: ${widget.cliente.contato['endereco']['cep']} ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(flex: 1),
                              Text(
                                'Estado: ${widget.cliente.contato['endereco']['estado']} ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(flex: 1),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left:8, right: 8, bottom: 8),
                          child: Text(
                            'Endereço: ${widget.cliente.contato['endereco']['logradouro']} ',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left:8, right: 8, bottom: 8),
                          child: Text(
                            'Bairro: ${widget.cliente.contato['endereco']['bairro']} ',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left:8, right: 8, bottom: 8),
                          child: Text(
                            'Cidade: ${widget.cliente.contato['endereco']['cidade']} ',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left:8, right: 8, bottom: 8),
                          child: Text(
                            'Número: ${widget.cliente.contato['endereco']['numero']} ',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          UserPreferences(
            preferences: userPreferences,
            onAddPreference: _addUserPreference,
            cliente: widget.cliente,
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Imoveis favoritos do cliente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FavoriteImoveisGrid(false, imoveisFavoritos),
            ),
          ),
        ],
      ),
    );
  }
}
