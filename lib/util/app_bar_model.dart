import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'NotificationButton.dart';
//import 'package:projeto_cme_novo/autenticacao/checkPage.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String subtitle;
  final String title;
  final Widget? leading;
  final showNotificacao;
  final bool isDarkMode;

  CustomAppBar({
    required this.subtitle,
    required this.title,
    this.leading,
    this.showNotificacao,
    required this.isDarkMode
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(150.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late int? valida = 0;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late DocumentReference hospitalDoc;
  late DocumentReference clienteDoc;

  @override
  void initState() {
    super.initState();
    _initializeData();
    print(valida);
  }

  Future<void> _initializeData() async {
    buscaValida();
  }

  Future<void> buscaValida() async {
    try {
      DocumentSnapshot clienteSnapshot = await clienteDoc.get();

      if (clienteSnapshot.exists) {
        setState(() {
          valida = clienteSnapshot.get('valida');
          print(valida);
        });
      } else {
        print('Cliente document not found.');
      }
    } catch (e) {
      print('Error fetching valida field: $e');
    }
  }

  Future<void> sairDoHospital() async {
    try {
      await clienteDoc.update({'valida': 0, 'id_temp': ""});

      setState(() {
        valida = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você saiu do hospital com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Erro ao sair do hospital: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao sair do hospital.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return AppBar(
      toolbarHeight: 50,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Color(0xFF3e88f3),
              // Color(0xFF6e58e9),
              Color.fromARGB(255, 233, 233, 233),
              Color.fromARGB(255, 233, 233, 233),
            ],
            stops: [0, 1],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 50, bottom: 30, right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'CoreMellow',
                      fontSize: isSmallScreen ? 15 : 23,
                      color: Color(0xFF6e58e9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.subtitle != '')
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 16,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              Spacer(),
              // if (!isSmallScreen)
              //   Image.asset(
              //     'logoExpertMed1.png',
              //     height: 100,
              //     width: 100,
              //   ),
              // if (isSmallScreen)
              //   Image.asset(
              //     'logoExpertMed1.png',
              //     height: 50,
              //     width: 50,
              //   ),
              if (widget.showNotificacao == 1)
                NotificationButton(
                  displayedNotifications: 5,
                ),
              if (valida == 1)
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Sair da instituição"),
                          content: Text(
                              "Tem certeza de que deseja sair da instituição que está logado?"),
                          actions: [
                            TextButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Sair da instituição"),
                              onPressed: () {
                                sairDoHospital();
                                /*Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => checkPage(),
                                    ),
                                  );*/
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Sair do hospital"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 212, 20, 7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
            ],
          ),
        ),
      ),
      leading: widget.leading,
    );
  }
}
