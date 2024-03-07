import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/tarefas/tarefasList.dart';
import 'package:provider/provider.dart';

class TarefasColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Clientes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<TarefasLista>(
              builder: (context, clientesList, _) {
                return _buildTarefasList(clientesList);
              },
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildTarefasList(TarefasLista tarefas) {
    if (tarefas.items.isEmpty) {
      return Center(
        child: Text('Nenhuma tarefa adicionada.'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: tarefas.items.map((cliente) {
            return ListTile(
              title: Text(cliente.titulo),
              subtitle: Text(cliente.descricao),
              onTap: () {
                // Ação ao tocar no cliente, se necessário
              },
            );
          }).toList(),
        ),
      );
    }
  }
}
