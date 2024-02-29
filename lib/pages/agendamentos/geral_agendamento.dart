import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/pages/user_config_page.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../components/custom_menu.dart';
import '../../core/models/UserProvider.dart';

class GeralAgendamento extends StatefulWidget {
  final bool isDarkMode;

  GeralAgendamento({required this.isDarkMode});

  @override
  State<GeralAgendamento> createState() => _GeralAgendamentoState();
}

class _GeralAgendamentoState extends State<GeralAgendamento> {
  late CurrentUser _user;
  late bool isDarkMode;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    isDarkMode = false;
    ;
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              subtitle: '',
              title: 'Home',
              isDarkMode: isDarkMode,
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (!isSmallScreen)
                Container(child: CustomMenu(isDarkMode: isDarkMode)),
              Expanded(
                child: Container(
                  color: isDarkMode ? Colors.black : Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              children: [
                                Text(
                                  'Nova visita',
                                  style: TextStyle(
                                      color: widget.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 30),
                                ),
                                Spacer(),
                                InkWell(
                                  child: Icon(
                                    Icons.add,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onTap: () {},
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.grey,
                                child: Center(child: Text('Histórico')),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                color: Colors.grey,
                                child: Center(child: Text('Agenda')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: isSmallScreen ? CustomMenu(isDarkMode: isDarkMode) : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
