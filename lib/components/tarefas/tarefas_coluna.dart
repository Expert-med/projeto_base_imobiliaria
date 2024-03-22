import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/tarefas/tarefa_item.dart';
import 'package:projeto_imobiliaria/models/tarefas/tarefasList.dart';
import 'package:provider/provider.dart';

import '../../models/tarefas/tarefas.dart';

class TarefasColumn extends StatelessWidget {


  const TarefasColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tarefas:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TarefasCorretor>>(
              future: Provider.of<TarefasLista>(context, listen: false)
                  .buscarMinhasTarefas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar suas tarefas'),
                  );
                } else {
                  List<TarefasCorretor> tarefas = snapshot.data ?? [];
                  if (tarefas.isEmpty) {
                    return Center(
                      child: Text('Nenhuma tarefa encontrada'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: tarefas.length,
                      itemBuilder: (ctx, i) {
                        final tarefa = tarefas[i];
                        return TarefaItem(
                          
                          tarefa: tarefa,
                          isChecked: tarefa.feita,
                          onTarefaStateChanged: (newValue) {
                            tarefa.feita = newValue;
                            Provider.of<TarefasLista>(context, listen: false)
                                .atualizarTarefaFirestore(tarefa);
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
    );
  }
}
