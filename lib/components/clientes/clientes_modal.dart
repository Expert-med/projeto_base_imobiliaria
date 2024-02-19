import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_imobiliaria/models/clientes/Clientes.dart';

class ClientesModal extends StatelessWidget {
  final List<Clientes> clientes;

  const ClientesModal({required this.clientes});

  // Função para adicionar o ID do cliente na coleção 'meus_clientes' do corretor
Future<void> adicionarCliente(BuildContext context, String clienteId) async {
  final user = FirebaseAuth.instance.currentUser;
  final corretorId =
      user?.uid ?? ''; // Obtém o UID do usuário logado como ID do corretor

  try {
    // Referência para o Firestore
    final firestore = FirebaseFirestore.instance;

    // Realiza a consulta para encontrar o documento do corretor com base no UID
    final querySnapshot = await firestore
        .collection('corretores')
        .where('uid', isEqualTo: corretorId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId =
          querySnapshot.docs[0].id; // Obtém o ID do documento do corretor

      // Obtém a coleção 'meus_clientes' dentro do documento do corretor
      final collection = firestore
          .collection('corretores')
          .doc(docId)
          .collection('meus_clientes');

      // Adiciona o ID do cliente na coleção 'meus_clientes' do corretor
      await collection.add({'clienteId': clienteId});

      // Feedback de sucesso (opcional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente adicionado com sucesso!')),
      );
    } else {
      throw Exception('Corretor não encontrado com o ID fornecido');
    }
  } catch (error) {
    // Trate qualquer erro que possa ocorrer ao adicionar o cliente
    print('Erro ao adicionar cliente: $error');

    // Feedback de erro (opcional)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao adicionar cliente')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: clientes.length,
      itemBuilder: (BuildContext context, int index) {
        final cliente = clientes[index];
        return ListTile(
          title: Text(cliente.name),
          onTap: () {
            // Ao clicar no cliente, adicione o ID do cliente na coleção 'meus_clientes' do corretor
            adicionarCliente(context, cliente.id);
            Navigator.pop(context); // Fecha a modal bottom sheet
          },
        );
      },
    );
  }
}
