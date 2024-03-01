import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/models/agendamento/agendamento.dart';
import 'package:projeto_imobiliaria/models/agendamento/agendamentoList.dart';
import 'package:provider/provider.dart';
import '../../components/agendamentos/imovel_agendamento_card.dart';
import '../../components/clientes/cliente_info_basicas.dart';
import '../../components/imovel/imoveis_modal.dart';
import '../../models/clientes/Clientes.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:projeto_imobiliaria/util/app_bar_model.dart';

import '../../models/imoveis/newImovelList.dart';

class AgendamentoInfoComponent extends StatefulWidget {
  final Agendamento agendamento;
  bool isDarkMode;
  Clientes cliente;
  AgendamentoInfoComponent(
      {required this.agendamento,
      required this.isDarkMode,
      required this.cliente});

  @override
  _AgendamentoInfoComponentState createState() =>
      _AgendamentoInfoComponentState();
}

class _AgendamentoInfoComponentState extends State<AgendamentoInfoComponent> {
  bool _showFavoriteOnly = false;
  bool _showGrid = true;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final imoveisList = Provider.of<NewImovelList>(context);

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              isDarkMode: widget.isDarkMode,
              subtitle: '',
              title: 'Informações da visita',
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (!isSmallScreen) CustomMenu(isDarkMode: widget.isDarkMode),
            Expanded(
                child: Container(
              color: widget.isDarkMode ? Colors.black : Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Visita n° ${widget.agendamento.id}',
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
                    color: Color.fromARGB(255, 209, 209, 209),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Status da visita: ',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${widget.agendamento.status}',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                child: Icon(
                                  Icons.edit_square,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                onTap: () {
                                  TextEditingController statusController =
                                      TextEditingController(
                                          text: widget.agendamento.status);
                                  TextEditingController
                                      observacoesGeraisController =
                                      TextEditingController(
                                          text: widget
                                              .agendamento.observacoes_gerais);
                                  TextEditingController dataVisitaController =
                                      TextEditingController(
                                          text: widget.agendamento.data);
                                  TextEditingController horaInicioController =
                                      TextEditingController(
                                          text: widget.agendamento.hora_inicio);
                                  TextEditingController horaFimController =
                                      TextEditingController(
                                          text: widget.agendamento.hora_fim);
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          color: widget.isDarkMode
                              ? Colors.black
                              : Color.fromARGB(255, 209, 209, 209),
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Editar Informações',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    5), // Reduzindo o padding para o campo "Código Imóvel"
                                                child: Text(
                                                  "Status da visita",
                                                  style: TextStyle(
                                                    color: Color(0xFF6e58e9),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                controller: statusController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.black12,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    5), // Reduzindo o padding para o campo "Código Imóvel"
                                                child: Text(
                                                  "Observações gerais",
                                                  style: TextStyle(
                                                    color: Color(0xFF6e58e9),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    observacoesGeraisController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.black12,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    5), // Reduzindo o padding para o campo "Código Imóvel"
                                                child: Text(
                                                  "Data da visita",
                                                  style: TextStyle(
                                                    color: Color(0xFF6e58e9),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    dataVisitaController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.black12,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    5), // Reduzindo o padding para o campo "Código Imóvel"
                                                child: Text(
                                                  "Hora de início da visita",
                                                  style: TextStyle(
                                                    color: Color(0xFF6e58e9),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    horaInicioController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.black12,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    5), // Reduzindo o padding para o campo "Código Imóvel"
                                                child: Text(
                                                  "Status de fim da visita",
                                                  style: TextStyle(
                                                    color: Color(0xFF6e58e9),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                controller: horaFimController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.black12,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Criar uma cópia do objeto Agendamento
                                                  Agendamento
                                                      updatedAgendamento =
                                                      Agendamento(
                                                    id: widget.agendamento.id,
                                                    data: dataVisitaController
                                                        .text,
                                                    hora_inicio:
                                                        horaInicioController
                                                            .text,
                                                    hora_fim:
                                                        horaFimController.text,
                                                    cliente: widget
                                                        .agendamento.cliente,
                                                    corretor: widget
                                                        .agendamento.corretor,
                                                    imoveis_visitados: widget
                                                        .agendamento
                                                        .imoveis_visitados,
                                                    status:
                                                        statusController.text,
                                                    observacoes_gerais:
                                                        observacoesGeraisController
                                                            .text,
                                                  );

                                                  // Atualizar o Agendamento na lista de Agendamentos
                                                  AgendamentoList()
                                                      .atualizarAgendamento(
                                                          updatedAgendamento);

                                                  Navigator.pop(context);
                                                },
                                                child: Text('Salvar'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Observações gerais: ',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${widget.agendamento.observacoes_gerais}',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Data da visita: ',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${widget.agendamento.data}',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Hora de início da visita: ',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${widget.agendamento.hora_inicio}',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Hora de fim da visita: ',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${widget.agendamento.hora_fim}',
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ClientBasicInfoComponent(
                    cliente: widget.cliente,
                    isDarkMode: widget.isDarkMode,
                  ),

                  Text(
                    'Imóveis a serem visitados:',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 210,
                      aspectRatio: 16 / 9,
                      viewportFraction: !isSmallScreen ? 1 / 3 : 1,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: widget.agendamento.imoveis_visitados.entries
                        .map((entry) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Center(
                            child: ImovelAgendamentoCard(
                              isDarkMode: widget.isDarkMode,
                              imovel: entry.value,
                              onSubmitEtapa: (etapa_visita) {
                                setState(() {});
                                AgendamentoList()
                                    .atualizarAgendamento(widget.agendamento);
                              },
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Adicionar Imóvel',
                        style: TextStyle(
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.add_box_outlined,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ImoveisModal(
                                imoveisList: imoveisList,
                                onImovelAdicionado: (imovel) {
                                  setState(() {
                                    final imovel_item = {
                                      "id_imovel": imovel.id,
                                      "feedback": '',
                                      "satisfacao": '',
                                      "comentarios": '',
                                    };
                                    widget.agendamento
                                            .imoveis_visitados[imovel.id] =
                                        imovel_item;

                                    AgendamentoList().atualizarAgendamento(
                                        widget.agendamento);
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Marcadores dos imóveis a serem visitados:',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Text(
                  //   'Visita iniciada em ${widget.agendamento.data}.',
                  //   style: TextStyle(
                  //     color:
                  //         widget.isDarkMode ? Colors.white70 : Colors.black54,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //   ),
                  // ),
                ],
              ),
            )),
          ],
        );
      }),
      drawer: isSmallScreen ? CustomMenu(isDarkMode: false) : null,
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
}
