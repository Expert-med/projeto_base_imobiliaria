import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EtapaNegociacaoCard extends StatefulWidget {
  final bool isDarkMode;
  final Map<String, dynamic> etapa;
  final String title;
  final void Function(Map<String, dynamic>) onSubmitEtapa;

  const EtapaNegociacaoCard({
    Key? key,
    required this.isDarkMode,
    required this.etapa,
    required this.title,
    required this.onSubmitEtapa,
  }) : super(key: key);

  @override
  _EtapaNegociacaoCardState createState() => _EtapaNegociacaoCardState();
}

class _EtapaNegociacaoCardState extends State<EtapaNegociacaoCard> {
  late TextEditingController dataController;
  late TextEditingController observacaoController;
  late TextEditingController propostaPrecoController;
  final List<String> statusOptions = [
    "Não iniciado",
    "Em andamento",
    "Concluído"
  ];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    dataController = TextEditingController(text: widget.etapa['data']);
    observacaoController =
        TextEditingController(text: widget.etapa['observacao']);
    propostaPrecoController =
        TextEditingController(text: widget.etapa['proposta_preco']);
    selectedStatus = widget.etapa['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 209, 209, 209),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${widget.title}',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                InkWell(
                  child: Icon(Icons.edit),
                  onTap: () {
                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Editar ${widget.title}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                decoration:
                                    InputDecoration(labelText: 'Status'),
                                value: selectedStatus,
                                items: statusOptions.map((String status) {
                                  return DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(status),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  selectedStatus = value;
                                },
                              ),
                              TextField(
                                controller: dataController,
                                decoration: InputDecoration(labelText: 'Data'),
                              ),
                              TextField(
                                controller: observacaoController,
                                decoration:
                                    InputDecoration(labelText: 'Observação'),
                              ),
                              TextField(
                                controller: propostaPrecoController,
                                decoration: InputDecoration(
                                    labelText: 'Valor da Proposta'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Atualiza os valores no mapa 'etapa'
                                widget.etapa['status'] = selectedStatus;
                                widget.etapa['data'] = dataController.text;
                                widget.etapa['observacao'] =
                                    observacaoController.text;
                                widget.etapa['proposta_preco'] =
                                    propostaPrecoController.text;

                                widget.onSubmitEtapa(widget.etapa);

                                setState(() {});
                              },
                              child: Text('Salvar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.etapa['status']}',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Data de início da etapa: ',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.etapa['data']}',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Observação: ',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.etapa['observacao']}',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Valor da proposta: ',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.etapa['proposta_preco']}',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            if (widget.title == 'Visita') SizedBox(height: 10),
            if (widget.title == 'Visita')
              Row(
                children: [
                  Text(
                    'Acesse a visita',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    child: Icon(Icons.arrow_forward),
                    onTap: () {},
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
