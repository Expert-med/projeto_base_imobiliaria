import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacaoList.dart';
import '../../models/clientes/Clientes.dart';
import '../../models/negociacao/negociacao.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import '../clientes/cliente_info_basicas.dart';
import 'negociacao_etapa_card.dart';
import 'negociacao_resultado_component.dart';

class NegociacaoInfoComponent extends StatefulWidget {
  final Negociacao negociacao;
  bool isDarkMode;
  Clientes cliente;
  NegociacaoInfoComponent(
      {required this.negociacao,
      required this.isDarkMode,
      required this.cliente});

  @override
  _NegociacaoInfoComponentState createState() =>
      _NegociacaoInfoComponentState();
}

class _NegociacaoInfoComponentState extends State<NegociacaoInfoComponent> {
  bool _showFavoriteOnly = false;
  bool _showGrid = true;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              isDarkMode: widget.isDarkMode,
              subtitle: '',
              title: 'Informações da página',
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (!isSmallScreen) CustomMenu(),
            Expanded(
                child: Container(
              color: widget.isDarkMode ? Colors.black : Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Negociação n° ${widget.negociacao.id}',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cliente:',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  PessoaInfoBasica(
                    cliente: widget.cliente,
                   
                  ),
                  Text(
                    'Imóvel:',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Informações do imóvel',
                      style: TextStyle(
                        color:
                            widget.isDarkMode ? Colors.white : Colors.black26,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Etapas da negociação:',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 215, // Defina a altura desejada para os cards
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .max, // Garante que os cards ocupem toda a altura disponível
                      children: [
                        Expanded(
                          child: EtapaNegociacaoCard(
                            isDarkMode: false,
                            etapa: widget.negociacao.etapas['visita'],
                            title: 'Visita',
                            onSubmitEtapa: (etapa_visita) => {
                              if (etapa_visita['status'] == 'Em andamento')
                                {
                                  widget.negociacao.etapas['proposta']
                                      ['status'] = 'Não iniciado',
                                  widget.negociacao.etapas['fechamento']
                                      ['status'] = 'Não iniciado',
                                },
                              widget.negociacao.etapas['visita'] = etapa_visita,
                              setState(() {}),
                              NegociacaoList()
                                  .atualizarNegociacao(widget.negociacao),
                            },
                          ),
                        ),
                        Expanded(
                          child: EtapaNegociacaoCard(
                            isDarkMode: false,
                            etapa: widget.negociacao.etapas['proposta'],
                            title: 'Proposta',
                            onSubmitEtapa: (etapa_proposta) => {
                              if (etapa_proposta['status'] == 'Concluído' ||
                                  etapa_proposta['status'] == 'Em andamento')
                                {
                                  widget.negociacao.etapas['visita']['status'] =
                                      'Concluído',
                                },
                              if (etapa_proposta['status'] == 'Em andamento')
                                {
                                  widget.negociacao.etapas['fechamento']
                                      ['status'] = 'Não iniciado',
                                },
                              widget.negociacao.etapas['proposta'] =
                                  etapa_proposta,
                              setState(() {}),
                              NegociacaoList()
                                  .atualizarNegociacao(widget.negociacao),
                            },
                          ),
                        ),
                        Expanded(
                          child: EtapaNegociacaoCard(
                            isDarkMode: false,
                            etapa: widget.negociacao.etapas['fechamento'],
                            title: 'Fechamento',
                            onSubmitEtapa: (etapa_fechamento) => {
                              if (etapa_fechamento['status'] == 'Concluído' ||
                                  etapa_fechamento['status'] == 'Em andamento')
                                {
                                  widget.negociacao.etapas['visita']['status'] =
                                      'Concluído',
                                  widget.negociacao.etapas['proposta']
                                      ['status'] = 'Concluído',
                                },
                              widget.negociacao.etapas['fechamento'] =
                                  etapa_fechamento,
                              setState(() {}),
                              Navigator.pop(context),
                              if (etapa_fechamento['status'] == 'Concluído')
                                {
                                  showFechamentoConcluidoPopup(context),
                                },
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Resultados da negociação:',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  NegociacaoResultadoComponent(
                      isDarkMode: widget.isDarkMode,
                      resultado: widget.negociacao.resultados),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Negociação iniciada em ${widget.negociacao.data_cadastro}. Última atualização em ${widget.negociacao.data_ultima_atualizacao}',
                    style: TextStyle(
                      color:
                          widget.isDarkMode ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )),
          ],
        );
      }),
      drawer: isSmallScreen ? CustomMenu() : null,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                widget.isDarkMode = !widget.isDarkMode;
              });
            },
            child: Icon(Icons.lightbulb),
          ),
        ],
      ),
    );
  }

  void showFechamentoConcluidoPopup(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    TextEditingController motivoController = TextEditingController();
    TextEditingController preco_final = TextEditingController(
        text: widget.negociacao.etapas['fechamento']['proposta_preco']);
    final List<String> resultadoOptions = [
      "Vendido",
      "Não vendido",
    ];
    String? selectedResult;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fechamento Concluído'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Por favor, preencha os seguintes dados:'),
              Text('Data de conclusão: $formattedDate'),
              TextField(
                decoration: InputDecoration(labelText: 'Observação'),
                controller: motivoController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Preço Final'),
                controller: preco_final,
              ),
              DropdownButtonFormField<String>(
                decoration:
                    InputDecoration(labelText: 'Resultado da negociação'),
                value: selectedResult,
                items: resultadoOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? value) {
                  selectedResult = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.negociacao.resultados['data_conclusao'] =
                      formattedDate;
                  widget.negociacao.resultados['motivo'] =
                      motivoController.text;
                  widget.negociacao.resultados['preco_final'] =
                      preco_final.text;
                  widget.negociacao.resultados['resultado'] = selectedResult;
                });

                NegociacaoList().atualizarNegociacao(widget.negociacao);
                Navigator.of(context).pop();
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}
