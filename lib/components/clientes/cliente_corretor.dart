import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/clientes/Clientes.dart';
import '../../theme/appthemestate.dart';
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
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);

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
              elevation: 7,
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
                      child: Row(
                        children: [
                          Text(
                            'Cliente: ${widget.cliente.name}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                                'Contato:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2, left: 8, right: 8, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                'Celular: ${widget.cliente.contato['celular']} ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(flex: 1),
                              Text(
                                'Email de contato: ${widget.cliente.contato['email']} ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(flex: 1),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Icon(
                                FontAwesomeIcons.facebook,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              widget
                                      .cliente!
                                      .contato['redes_sociais']['facebook']
                                      .isNotEmpty
                                  ? widget.cliente!.contato['redes_sociais']
                                      ['facebook']
                                  : 'Não informado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    FontAwesomeIcons.linkedin,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  widget
                                          .cliente!
                                          .contato['redes_sociais']['linkedin']
                                          .isNotEmpty
                                      ? widget.cliente!.contato['redes_sociais']
                                          ['linkedin']
                                      : 'Não informado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const InkWell(
                                  child: Icon(
                                    FontAwesomeIcons.instagram,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  widget
                                          .cliente!
                                          .contato['redes_sociais']['instagram']
                                          .isNotEmpty
                                      ? widget.cliente!.contato['redes_sociais']
                                          ['instagram']
                                      : 'Não informado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ],
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
                          padding: const EdgeInsets.only(
                              top: 2, left: 8, right: 8, bottom: 8),
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
                          padding: const EdgeInsets.only(
                              top: 2, left: 8, right: 8, bottom: 8),
                          child: Text(
                            'Endereço: ${widget.cliente.contato['endereco']['logradouro']} ',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2, left: 8, right: 8, bottom: 8),
                          child: Text(
                            'Bairro: ${widget.cliente.contato['endereco']['bairro']} ',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2, left: 8, right: 8, bottom: 8),
                          child: Text(
                            'Cidade: ${widget.cliente.contato['endereco']['cidade']} ',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2, left: 8, right: 8, bottom: 8),
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
          Container(
            width: double.infinity,
            child: Card(
              elevation: 7,
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
                        'Imoveis favoritos do cliente',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                   
                    
                    
                  ],
                ),
              ),
            ),
          ),
         
          Expanded(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: imoveisFavoritos.isEmpty
        ? Center(
            child: Card(
               elevation: 7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Nenhum imóvel favorito adicionado',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : FavoriteImoveisGrid(false, imoveisFavoritos),
  ),
),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            themeNotifier.enableDarkMode(!themeNotifier.isDarkModeEnabled);
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
