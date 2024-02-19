import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/clientes/Clientes.dart';
import '../imovel/imovel_grid_favorites.dart';
import 'cliente_preferences.dart';

class ClienteInfoCorretor extends StatefulWidget {
  final Clientes cliente;
  final bool isDarkMode;

  const ClienteInfoCorretor(
      {required this.cliente, required this.isDarkMode, Key? key})
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
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Cliente: ${widget.cliente.name}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: !widget.isDarkMode ? Colors.black : Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Email: ${widget.cliente.email}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: !widget.isDarkMode ? Colors.black : Colors.white),
            ),
          ),
          UserPreferences(
            preferences: userPreferences,
            onAddPreference: _addUserPreference,
            cliente: widget.cliente,
            isDarkMode: widget.isDarkMode,
          ),
          SizedBox(
              height:
                  8), 
               Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Imoveis favoritos do cliente',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: !widget.isDarkMode ? Colors.black : Colors.white),
            ),
          ),   
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FavoriteImoveisGrid(
                  false, widget.isDarkMode, imoveisFavoritos),
            ),
          ),
        ],
      ),
    );
  }
}
