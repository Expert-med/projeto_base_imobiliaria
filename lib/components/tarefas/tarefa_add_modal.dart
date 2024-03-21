import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/core/data/user_repository.dart';
import 'package:projeto_imobiliaria/models/tarefas/tarefas.dart';
import 'package:projeto_imobiliaria/models/tarefas/tarefasList.dart';
import 'package:provider/provider.dart';

import '../../models/clientes/Clientes.dart';
import '../../models/clientes/clientesList.dart';

typedef OnTarefaAdicionada = void Function(TarefasCorretor tarefa);

class AddTarefaModal extends StatefulWidget {
  const AddTarefaModal();

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
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            'Adicionar Tarefa',
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),
           SizedBox(height: 10),
          TextFormField(
            controller: _tituloController,
            decoration: InputDecoration(
              labelText: 'Título',
              labelStyle: TextStyle(
                color: Color(0xFF6e58e9),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              filled: true,
              fillColor: Colors.black12,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _descricaoController,
            decoration: InputDecoration(
              labelText: 'Descrição',
              labelStyle: TextStyle(
                color: Color(0xFF6e58e9),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              filled: true,
              fillColor: Colors.black12,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              String uid = UserRepository().generateUID();

              final titulo = _tituloController.text;
              final descricao = _descricaoController.text;

              TarefasCorretor tarefaAdd = TarefasCorretor(
                  id: uid, titulo: titulo, descricao: descricao, feita: false);
              print(tarefaAdd.descricao);
              print(tarefaAdd.titulo);
              print(tarefaAdd.descricao);
              Provider.of<TarefasLista>(context, listen: false)
                  .adicionarTarefa(tarefaAdd);

              Navigator.pop(context);
              _tituloController.clear();
              _descricaoController.clear();
            },
            child: Text(
              'Adicionar Tarefa',
            ),
            style: ElevatedButton.styleFrom(
              elevation: 10.0,
              backgroundColor: Color(0xFF6e58e9),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
