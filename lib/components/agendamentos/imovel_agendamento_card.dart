import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../theme/appthemestate.dart';

class ImovelAgendamentoCard extends StatefulWidget {
  
  final Map<String, dynamic> imovel;

  final void Function(Map<String, dynamic>) onSubmitEtapa;

  const ImovelAgendamentoCard({
    Key? key,
    
    required this.imovel,
    required this.onSubmitEtapa,
  }) : super(key: key);

  @override
  _ImovelAgendamentoCardState createState() => _ImovelAgendamentoCardState();
}

class _ImovelAgendamentoCardState extends State<ImovelAgendamentoCard> {
  late TextEditingController feedbackController;
  late TextEditingController satisfacaoController;
  late TextEditingController comentariosController;
  final List<String> statusOptions = [
    "Não iniciado",
    "Em andamento",
    "Concluído"
  ];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    feedbackController = TextEditingController(text: widget.imovel['feedback']);
    satisfacaoController =
        TextEditingController(text: widget.imovel['satisfacao']);
    comentariosController =
        TextEditingController(text: widget.imovel['comentarios']);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    double initialRating = 0.0;
    try {
      initialRating = double.parse(widget.imovel['satisfacao']);
    } catch (e) {
      print(
          'O valor de satisfacao não é válido: ${widget.imovel['satisfacao']}');
      print('Usando o valor padrão 0.0 para initialRating.');
    }

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
                  '${widget.imovel['id_imovel']}',
                  style: TextStyle(
                    
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
                          backgroundColor: themeNotifier.isDarkModeEnabled
                              ? Colors.black
                              : Color.fromARGB(255, 209, 209, 209),
                          title: Text('Editar ${widget.imovel['id_imovel']}'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    5), // Reduzindo o padding para o campo "Código Imóvel"
                                child: Text(
                                  "Feedback do cliente",
                                  style: TextStyle(
                                    color: Color(0xFF6e58e9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextField(
                                controller: feedbackController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black12,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                    5), // Reduzindo o padding para o campo "Código Imóvel"
                                child: Text(
                                  "Satisfação do cliente",
                                  style: TextStyle(
                                    color: Color(0xFF6e58e9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              RatingBar.builder(
                                initialRating:
                                    initialRating, // Classificação inicial
                                minRating: 1, // Valor mínimo que pode ser dado
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 30,
                                itemBuilder: (context, index) {
                                  switch (index) {
                                    case 0:
                                      return Icon(
                                        Icons.sentiment_very_dissatisfied,
                                        color: Colors.red,
                                      );
                                    case 1:
                                      return Icon(
                                        Icons.sentiment_dissatisfied,
                                        color: Colors.redAccent,
                                      );
                                    case 2:
                                      return Icon(
                                        Icons.sentiment_neutral,
                                        color: Colors.amber,
                                      );
                                    case 3:
                                      return Icon(
                                        Icons.sentiment_satisfied,
                                        color: Colors.lightGreen,
                                      );
                                    case 4:
                                      return Icon(
                                        Icons.sentiment_very_satisfied,
                                        color: Colors.green,
                                      );
                                    default:
                                      return SizedBox(); // Retorne algo padrão, caso index seja inválido
                                  }
                                },
                                onRatingUpdate: (rating) {
                                  satisfacaoController.text = rating.toString();
                                  print(rating);
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                    5), // Reduzindo o padding para o campo "Código Imóvel"
                                child: Text(
                                  "Comentários sobre a Visita",
                                  style: TextStyle(
                                    color: Color(0xFF6e58e9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextField(
                                controller: comentariosController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black12,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
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
                                widget.imovel['feedback'] =
                                    feedbackController.text;
                                widget.imovel['satisfacao'] =
                                    satisfacaoController.text;
                                widget.imovel['comentarios'] =
                                    comentariosController.text;

                                widget.onSubmitEtapa(widget.imovel);

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
            Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Status da visita: ',
                        style: TextStyle(
                          
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.imovel['status']}',
                        style: TextStyle(
                          
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Feedback do Cliente: ',
                        style: TextStyle(
                          
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.imovel['feedback']}',
                        style: TextStyle(
                          
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Satisfação do Cliente: ',
                        style: TextStyle(
                          
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: initialRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30,
                        ignoreGestures: true,
                        onRatingUpdate: (rating) {
                          // Função vazia, não faz nada
                        },
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                            default:
                              return SizedBox(); // Retorne algo padrão, caso index seja inválido
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Comentários do Cliente: ',
                        style: TextStyle(
                          
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.imovel['comentarios']}',
                        style: TextStyle(
                          
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
