import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacao.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacaoList.dart';
import 'package:provider/provider.dart';

import '../../components/tarefas/tarefa_item.dart';
import '../../models/tarefas/tarefas.dart';
import '../../models/tarefas/tarefasList.dart';

class TarefasListView extends StatefulWidget {
  const TarefasListView({Key? key}) : super(key: key);

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

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width:
                            double.infinity, // Define a largura como infinita
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                             padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                'Minhas tarefas',
                                style: TextStyle(
                                 
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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

                                  return ListView.separated(
                                    padding: const EdgeInsets.all(10),
                                    itemCount: clientesFiltrados.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider(); // Adiciona um Divider entre cada item
                                    },
                                    itemBuilder: (ctx, i) {
                                      final cliente = clientesFiltrados[i];
                                      return TarefaItem(
                                        tarefa: cliente,
                                        isChecked: cliente.feita,
                                        onTarefaStateChanged: (newValue) {
                                          setState(() {
                                            cliente.feita = newValue;
                                          });
                                          TarefasLista()
                                              .atualizarTarefaFirestore(
                                                  cliente);
                                        },
                                      );
                                    },
                                  );
                                }
                              }
                            },
                          ),
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
