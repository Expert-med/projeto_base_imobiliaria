import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';

import 'package:projeto_imobiliaria/models/corretores/corretorList.dart';
import 'package:provider/provider.dart';

import '../../components/corretor/corretor_item.dart';
import '../../models/corretores/corretor.dart';

class CorretoresListPage extends StatefulWidget {
  final bool isDarkMode;
  CorretoresListPage({required this.isDarkMode});
  @override
  _CorretoresListPageState createState() => _CorretoresListPageState();
}

class _CorretoresListPageState extends State<CorretoresListPage> {
  List<Corretor> _corretores = [];
  TextEditingController _searchController = TextEditingController();
  bool _isDarkMode = false;
  @override
  void initState() {
    _isDarkMode = widget.isDarkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final corretorList = Provider.of<CorretorList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de corretores'),
      ),
      backgroundColor: _isDarkMode
          ? Colors.black87
          : Colors.white, // Alteração de cor com base no modo escuro
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Procurar',
                labelStyle: TextStyle(
                    color: !_isDarkMode ? Colors.black : Colors.white),
                prefixIcon: Icon(
                  Icons.search,
                ),
                filled: true,
                fillColor: !_isDarkMode
                    ? Colors.grey[200]
                    : Colors.black, // Defina a cor de fundo como cinza
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: !_isDarkMode ? Colors.grey : Colors.black),
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
            child: FutureBuilder<List<Corretor>>(
              future: corretorList.buscarCorretores(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar os corretores'),
                  );
                } else {
                  _corretores = snapshot.data ?? [];
                  if (_corretores.isEmpty) {
                    return Center(
                      child: Text('Nenhum corretor adicionado'),
                    );
                  } else {
                    List<Corretor> corretoresFiltrados =
                        _corretores.where((corretor) {
                      String searchTerm = _searchController.text.toLowerCase();
                      return corretor.name.toLowerCase().contains(searchTerm);
                    }).toList();

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: corretoresFiltrados.length,
                      itemBuilder: (ctx, i) {
                        final corretor = corretoresFiltrados[i];
                        return CorretorItem(_isDarkMode, corretor);
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
      drawer: CustomMenu(isDarkMode: _isDarkMode),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            child: Icon(Icons.lightbulb),
          ),
          SizedBox(height: 16), // Espaçamento entre os botões
        
        ],
      ),
    );
  }
}
