import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/core/data/user_repository.dart';
import 'package:projeto_imobiliaria/models/tarefas/tarefas.dart';
import 'package:projeto_imobiliaria/models/tarefas/tarefasList.dart';

import '../../models/clientes/Clientes.dart';
import '../../models/clientes/clientesList.dart';

typedef OnTarefaAdicionada = void Function(TarefasCorretor tarefa);

class AddTarefaModal extends StatefulWidget {
  final OnTarefaAdicionada? onTarefaAdicionado;

  const AddTarefaModal({
    this.onTarefaAdicionado,
  });

  @override
  _AddTarefaModalState createState() => _AddTarefaModalState();
}

class _AddTarefaModalState extends State<AddTarefaModal> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            controller: _tituloController,
            decoration: InputDecoration(labelText: 'Título'),
          ),
          TextFormField(
            controller: _descricaoController,
            decoration: InputDecoration(labelText: 'Descrição'),
          ),
          SizedBox(height: 16), // Adiciona um espaço entre os campos e o botão
          ElevatedButton(
            onPressed: () {
              String uid = UserRepository().generateUID();

              final titulo = _tituloController.text;
              final descricao = _descricaoController.text;

              TarefasCorretor tarefaAdd = TarefasCorretor(
                  id: uid,
                  titulo: titulo,
                  descricao: descricao,
                  feita: false);
              print(tarefaAdd.descricao);
              print(tarefaAdd.titulo);
              print(tarefaAdd.descricao);
              TarefasLista().adicionarTarefa(tarefaAdd);
              widget.onTarefaAdicionado!(tarefaAdd);
              Navigator.pop(context);
              _tituloController.clear();
              _descricaoController.clear();
            },
            child: Text('Adicionar Tarefa'),
          ),
        ],
      ),
    );
  }
}
