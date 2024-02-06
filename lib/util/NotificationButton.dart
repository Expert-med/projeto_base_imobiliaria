import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
//import '../hamburguer/historico/historicoInfoPage.dart';


class NotificationButton extends StatefulWidget {
  final List<dynamic> notifications;
  late int displayedNotifications;

  NotificationButton({
    required this.displayedNotifications,
  }) : notifications = [];

  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late DocumentReference hospitalDoc;
  late DocumentReference clienteDoc;
  
  int atualNotificacao = 0;
  List<dynamic> naoLidas = [];
  String hospid = '';
  late int? valida = 0;
  late String idTemp = '';
  String idCliente = '';

  @override
  void initState() {
    super.initState();

    
  }

  

   Future<void> buscaValida() async {
    try {
      DocumentSnapshot clienteSnapshot = await clienteDoc.get();

      if (clienteSnapshot.exists) {
        setState(() {
          valida = clienteSnapshot.get('valida');
          idTemp = clienteSnapshot.get('id_temp');
        });
      } else {
        print('Cliente document not encontrado.');
      }
    } catch (e) {
      print('Error fetching valida field: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () async {
            await buscarNotificacoes();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Notificações'),
                  content: Container(
                    child: widget.notifications.isEmpty
                        ? Center(
                            child: Text('Sem notificações'),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children:
                                  widget.notifications.map((notification) {
                                return ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification['data_hora'].toString(),
                                        style: TextStyle(
                                          fontWeight: notification['leu'] == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        notification['titulo'].toString(),
                                        style: TextStyle(
                                          fontWeight: notification['leu'] == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _marcarComoLido(notification);
                                        },
                                        icon: Icon(Icons.check),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _showNotificationDetails(
                                              context, notification);
                                        },
                                        icon: Icon(Icons.info),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        'Fechar',
                        style: TextStyle(
                          color: Color(0xFF466B66),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        if (atualNotificacao > 0)
          Positioned(
            top: 5.0,
            right: 5.0,
            child: badge.Badge(
              badgeContent: Text(
                atualNotificacao.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: Container(),
            ),
          ),
      ],
    );
  }

  Future<void> _marcarComoLido(Map<String, dynamic> notification) async {
    // Assuming 'notification' has an 'id' field
    int notificationId = notification['id'];

    try {
      await hospitalDoc
          .collection('notificacoes')
          .doc(notificationId.toString())
          .update({
        'leu': 1,
      });

      print('Notificação marcada como lida: $notificationId');
    } catch (error) {
      print('Erro ao marcar notificação como lida: $error');
    }
  }

  Future<void> buscarNotificacoes() async {

    try {
      QuerySnapshot? querySnapshot = await hospitalDoc
          .collection('notificacoes')
          .where('id', isNotEqualTo: 0)
          .get();

      if (querySnapshot != null) {
        setState(() {
          widget.notifications.clear();
          widget.notifications.addAll(
            querySnapshot.docs
                .map<Map<String, dynamic>>(
                  (doc) => doc.data() as Map<String, dynamic>,
                )
                .toList(),
          );
          naoLidas
              .clear(); // Limpa a lista 'naoLidas' antes de adicionar os novos itens

          for (var notification in widget.notifications) {
            if (notification['leu'] == 0) {
              naoLidas.add(notification);
            }
          }

          atualNotificacao = naoLidas.length;
        });
      } else {
        print('QuerySnapshot is null.');
      }
    } catch (error) {
      print('Erro ao buscar os tipos de instrumentos: $error');
    }
  }

  Future<void> buscarNotificacoesNaonaoLidas() async {
    try {
      QuerySnapshot? querySnapshot = await hospitalDoc
          .collection('notificacoes')
          .where('id', isNotEqualTo: 0)
          .where('leu', isEqualTo: 0)
          .get();

      if (querySnapshot != null) {
        setState(() {
          widget.notifications.clear();
          widget.notifications.addAll(
            querySnapshot.docs
                .map<Map<String, dynamic>>(
                  (doc) => doc.data() as Map<String, dynamic>,
                )
                .toList(),
          );
          atualNotificacao = widget.notifications.length;
        });
      } else {
        print('QuerySnapshot is null.');
      }
    } catch (error) {
      print('Erro ao buscar os tipos de instrumentos: $error');
    }
  }

  void _showNotificationDetails(
      BuildContext context, Map<String, dynamic> notification) {
    // Extract the ID from the 'titulo' field
    String titulo = notification['titulo'].toString();
    int idEmbalagem =
        int.tryParse(titulo.substring(titulo.lastIndexOf(' ') + 1)) ?? 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes da Notificação'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${notification['id']}'),
              Text('Mensagem: ${notification['titulo']}'),
              Text('Descrição: ${notification['descricao']}'),
              Text('Data e Hora: ${notification['data_hora']}'),
              if (notification['parametro'] == 1) ...[
                Row(
                  children: [
                    Text('Ir para a embalagem'),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        /*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => historicoInfo(
                              idEmbalagem: idEmbalagem,
                            ),
                          ),
                        );*/
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black26,
                        ),
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Fechar',
                style: TextStyle(
                  color: Color(0xFF466B66),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
