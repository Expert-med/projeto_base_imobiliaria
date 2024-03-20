import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/negociacao/negociacao.dart';
import '../../models/negociacao/negociacaoList.dart';

class NegociacaoColuna extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Negociações:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<NegociacaoList>(
              builder: (context, negociacaoList, _) {
                final List<Negociacao> negociacoes = negociacaoList.items;
                return ListView.builder(
                  itemCount: negociacoes.length,
                  itemBuilder: (context, index) {
                    final negociacao = negociacoes[index];
                    return ListTile(
                      title: Text('Negociação ${negociacao.id}'),
                      subtitle: Text(negociacao.cliente),
                      // Adicione mais detalhes da negociação conforme necessário
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
