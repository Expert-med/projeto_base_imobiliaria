import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacao.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacaoList.dart';
import 'package:provider/provider.dart';

import '../../theme/appthemestate.dart';
import 'negociacao_item.dart';

class PropostaListView extends StatefulWidget {


  const PropostaListView( {Key? key}) : super(key: key);

  @override
  _PropostaListViewState createState() => _PropostaListViewState();
}

class _PropostaListViewState extends State<PropostaListView> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    List<Negociacao> _loadedProducts =
        Provider.of<NegociacaoList>(context).items;

List<Negociacao> negociacoesNaoIniciado = findNegociacoesNaoIniciado(_loadedProducts);
List<Negociacao> negociacoesEmAndamento = findNegociacoesEmAndamento(_loadedProducts);
List<Negociacao> negociacoesConcluidas = findNegociacoesConcluidas(_loadedProducts);

print('negociacoesEmAndamento: ${negociacoesEmAndamento}');
    // Filtrar os produtos com base na pesquisa
    List<Negociacao> _filteredProducts = _searchText.isEmpty
        ? _loadedProducts
        : _loadedProducts.where((negociacao) {
            return negociacao.id
                .toLowerCase()
                .contains(_searchText.toLowerCase());
          }).toList();
final themeNotifier = Provider.of<AppThemeStateNotifier>(context);




    return Container(
     
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Procurar',
                labelStyle: TextStyle(
                  color: Color(0xFF6e58e9),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF6e58e9),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xFF6e58e9),
                  ),
                ),
                fillColor:
                    themeNotifier.isDarkModeEnabled ? Colors.grey[800] : Colors.grey[200],
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Não iniciada',
                          style: TextStyle(
                              color: themeNotifier.isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black)),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: negociacoesNaoIniciado.length,
                          itemBuilder: (ctx, i) {
                            return ChangeNotifierProvider.value(
                              value: negociacoesNaoIniciado[i],
                              child: NegociacaoItem(
                                  themeNotifier.isDarkModeEnabled, i, negociacoesNaoIniciado.length),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey, // Cor do divisor
                  thickness: 1, // Espessura do divisor
                  width: 20, // Largura do divisor
                  indent: 10, // Espaçamento superior do divisor
                  endIndent: 10, // Espaçamento inferior do divisor
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Em andamento',
                          style: TextStyle(
                              color: themeNotifier.isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black)),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: negociacoesEmAndamento.length,
                          itemBuilder: (ctx, i) {
                            return ChangeNotifierProvider.value(
                              value: negociacoesEmAndamento[i],
                              child: NegociacaoItem(themeNotifier.isDarkModeEnabled, i,
                                  negociacoesEmAndamento.length),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey, // Cor do divisor
                  thickness: 1, // Espessura do divisor
                  width: 20, // Largura do divisor
                  indent: 10, // Espaçamento superior do divisor
                  endIndent: 10, // Espaçamento inferior do divisor
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Finalizada',
                          style: TextStyle(
                              color: themeNotifier.isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black)),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: negociacoesConcluidas.length,
                          itemBuilder: (ctx, i) {
                            return ChangeNotifierProvider.value(
                              value: negociacoesConcluidas[i],
                              child: NegociacaoItem(themeNotifier.isDarkModeEnabled, i,
                                  negociacoesConcluidas.length),
                            );
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


List<Negociacao> findNegociacoesEmAndamento(List<Negociacao> loadedProducts) {
  List<Negociacao> negociacoesEmAndamento = [];

  for (var negociacao in loadedProducts) {
    var visitaStatus = negociacao.etapas['visita']?['status'];
    var propostaStatus = negociacao.etapas['proposta']?['status'];
    var fechamentoStatus = negociacao.etapas['fechamento']?['status'];

    // Verifica se a visita está 'Em andamento'
    var visitaEmAndamento = visitaStatus == 'Em andamento';

    // Verifica se a proposta não foi iniciada
    var propostaNaoIniciado = propostaStatus == 'Não iniciado';

    // Verifica se o fechamento não foi iniciado
    var fechamentoNaoIniciado = fechamentoStatus == 'Não iniciado';

    // Verifica se pelo menos uma das condições para estar em andamento é verdadeira
    if ((visitaEmAndamento && propostaNaoIniciado && fechamentoNaoIniciado) ||
        (visitaStatus == 'Concluído' && propostaNaoIniciado && fechamentoNaoIniciado) ||
        (visitaStatus == 'Concluído' && propostaStatus == 'Em andamento' && fechamentoNaoIniciado) ||
        (visitaStatus == 'Concluído' && propostaStatus == 'Concluído' && fechamentoNaoIniciado) ||
        (visitaStatus == 'Concluído' && propostaStatus == 'Concluído' && fechamentoStatus == 'Em andamento')) {
      negociacoesEmAndamento.add(negociacao);
    }
  }

  return negociacoesEmAndamento;
}




List<Negociacao> findNegociacoesNaoIniciado(List<Negociacao> loadedProducts) {
  List<Negociacao> negociacoesNaoIniciado = [];

  for (var negociacao in loadedProducts) {
    var emAndamento = false;
    var concluido = false;

    for (var etapaKey in negociacao.etapas.keys) {
      var etapa = negociacao.etapas[etapaKey];
      if (etapa.containsKey('status')) {
        if (etapa['status'] == 'Em andamento') {
          emAndamento = true;
        } else if (etapa['status'] == 'Concluído') {
          concluido = true;
        }
      }
    }

    if (!emAndamento && !concluido) {
      negociacoesNaoIniciado.add(negociacao);
    }
  }

  return negociacoesNaoIniciado;
}

List<Negociacao> findNegociacoesConcluidas(List<Negociacao> loadedProducts) {
  List<Negociacao> negociacoesConcluidas = [];

  for (var negociacao in loadedProducts) {
    var concluido = false;

    // Verifica se a etapa "fechamento" está presente e seu status é "Concluído"
    if (negociacao.etapas.containsKey('fechamento') &&
        negociacao.etapas['fechamento']['status'] == 'Concluído') {
      concluido = true;
    }

    // Se a negociação estiver "Concluída", adiciona à lista de negociações concluídas
    if (concluido) {
      negociacoesConcluidas.add(negociacao);
    }
  }

  return negociacoesConcluidas;
}



}
