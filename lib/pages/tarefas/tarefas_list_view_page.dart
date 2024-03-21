import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacao.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacaoList.dart';
import 'package:provider/provider.dart';

import '../../components/tarefas/tarefa_item.dart';
import '../../models/tarefas/tarefas.dart';
import '../../models/tarefas/tarefasList.dart';

class TarefasListView extends StatefulWidget {
  final bool isDarkMode;

  const TarefasListView(this.isDarkMode, {Key? key}) : super(key: key);

  @override
  _TarefasListViewState createState() => _TarefasListViewState();
}

class _TarefasListViewState extends State<TarefasListView> {
  TextEditingController _searchController = TextEditingController();

  List<TarefasCorretor> _tarefas = [];

  @override
  Widget build(BuildContext context) {
    List<TarefasCorretor> _loadedProducts =
        Provider.of<TarefasLista>(context).items;
    final clientesList = Provider.of<TarefasLista>(context);

    return Container(
      color: widget.isDarkMode ? Colors.black : Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Minhas tarefas',
                            style: TextStyle(
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                      Expanded(
                        child: FutureBuilder<List<TarefasCorretor>>(
                          future: clientesList.buscarMinhasTarefas(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child:
                                    Text('Erro ao carregar os seus clientes'),
                              );
                            } else {
                              _tarefas = snapshot.data ?? [];
                              if (_tarefas.isEmpty) {
                                return Center(
                                  child: Text('Nenhum cliente adicionado'),
                                );
                              } else {
                                // Filtrar os clientes com base na busca
                                List<TarefasCorretor> clientesFiltrados =
                                    _tarefas.where((cliente) {
                                  String searchTerm =
                                      _searchController.text.toLowerCase();
                                  return cliente.titulo
                                      .toLowerCase()
                                      .contains(searchTerm);
                                }).toList();

                                return ListView.builder(
                                  padding: const EdgeInsets.all(10),
                                  itemCount: clientesFiltrados.length,
                                  itemBuilder: (ctx, i) {
                                    final cliente = clientesFiltrados[i];
                                    return TarefaItem(
                                     
                                      tarefa: cliente,
                                      isChecked: cliente
                                          .feita, // Passa o estado da tarefa para o isChecked
                                      onTarefaStateChanged: (newValue) {
                                        setState(() {
                                          cliente.feita =
                                              newValue; // Atualiza o estado da tarefa
                                        });
                                        TarefasLista().atualizarTarefaFirestore(
                                            cliente); // Atualiza a tarefa no Firestore
                                      },
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
