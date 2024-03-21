import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/negociacao/negociacao.dart';
import '../../models/negociacao/negociacaoList.dart';
import 'negociacao_info.dart';
import 'negociacao_item.dart';

class MeuWidgetPai extends StatelessWidget {
  final bool isDarkMode;

  const MeuWidgetPai({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NegociacaoList>(
      create: (context) => NegociacaoList(), // Supondo que NegociacaoList seja o provider para Negociacao
      child: NegociacaoColuna(isDarkMode: isDarkMode),
    );
  }
}

class NegociacaoColuna extends StatelessWidget {
  final bool isDarkMode;

  const NegociacaoColuna({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Propostas:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black54,
            ),
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
                  return ChangeNotifierProvider<Negociacao>.value(
                    value: negociacao,
                    child: NegociacaoItem(
                      false, // Aqui você pode passar seus parâmetros necessários para o NegociacaoItem
                      index,
                      negociacoes.length,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
