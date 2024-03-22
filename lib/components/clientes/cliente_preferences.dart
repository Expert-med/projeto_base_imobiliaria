import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/clientes/Clientes.dart';

class UserPreferences extends StatefulWidget {
  final List<String> preferences;
  final Function(String) onAddPreference;
  final Clientes cliente;

  const UserPreferences(
      {required this.preferences,
      required this.cliente,
      required this.onAddPreference,
      Key? key})
      : super(key: key);

  @override
  _UserPreferencesState createState() => _UserPreferencesState();
}

class _UserPreferencesState extends State<UserPreferences> {
  final TextEditingController _controller = TextEditingController();
  List<String> _availablePreferences = [];
  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  void _removePreference(String preference) async {
    setState(() {
      widget.preferences.remove(preference);
    });

    try {
      await FirebaseFirestore.instance
          .collection('clientes')
          .doc(widget.cliente.id)
          .update({
        'preferencias': FieldValue.arrayRemove([preference]),
      });
    } catch (error) {
      print('Erro ao remover preferência: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Borda arredondada da coluna
      ),
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
                  'Preferências de Imóvel do Usuário',
                  style: TextStyle(
                    fontSize: 25,
                          fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: widget.preferences.length * 40,
                child: ListView.builder(
                  itemCount: widget.preferences.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('• ${widget.preferences[index]}',
                          style: TextStyle()),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                        ),
                        onPressed: () =>
                            _removePreference(widget.preferences[index]),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showAddPreferenceModal(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Adicionar preferência'),
                        ),
                         style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                elevation: 10.0,
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPreferenceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Adicionar preferência',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Preferências disponíveis:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _availablePreferences.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_availablePreferences[index]),
                          onTap: () {
                            widget.onAddPreference(_availablePreferences[index]);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nova preferência',
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _addNewPreference();
                      Navigator.pop(context);
                    },
                    child: Text('Cadastrar e adicionar'),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _addNewPreference() async {
    String newPreference = _controller.text.trim();
    if (newPreference.isNotEmpty) {
      widget.onAddPreference(newPreference);
      _controller.clear();

      try {
        // Obter o número total de documentos na coleção
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('preferencias_imoveis')
            .get();
        int totalDocs = querySnapshot.docs.length;

        // Adicionar a nova preferência com o número sequencial
        // Adicionar a nova preferência com o número sequencial
        await FirebaseFirestore.instance
            .collection('preferencias_imoveis')
            .doc((totalDocs + 1)
                .toString()) // Definir o ID como uma string com o próximo número sequencial
            .set({'id': totalDocs + 1, 'preferencia': newPreference});
      } catch (error) {
        print('Erro ao adicionar preferência: $error');
      }
    }
  }

  Future<void> _fetchPreferences() async {
    List<String> preferences = await _fetchAvailablePreferences();
    setState(() {
      _availablePreferences = preferences;
    });
  }

  Future<List<String>> _fetchAvailablePreferences() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('preferencias_imoveis')
          .get();
      return querySnapshot.docs
          .map((doc) => doc['preferencia'].toString())
          .toList();
    } catch (error) {
      print('Erro ao buscar preferências: $error');
      return [];
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
