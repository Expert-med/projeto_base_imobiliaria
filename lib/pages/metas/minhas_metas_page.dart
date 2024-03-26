import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../theme/appthemestate.dart';
import '../../components/custom_menu.dart';
import '../../util/app_bar_model.dart';

class MinhasEstatisticas extends StatefulWidget {
  const MinhasEstatisticas({Key? key}) : super(key: key);

  @override
  _MinhasEstatisticasState createState() => _MinhasEstatisticasState();
}

class _MinhasEstatisticasState extends State<MinhasEstatisticas> {
  int viewsPage = 0;

  @override
  void initState() {
    super.initState();
    buscaLanding();
  }

  void buscaLanding() async {
    try {
      final store = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;
      final querySnapshot = await store
          .collection('corretores')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs[0];

        final desempenhoAtual = docSnapshot['desempenho_atual'];
        if (desempenhoAtual != null && desempenhoAtual['views_page'] != null) {
          setState(() {
            viewsPage = desempenhoAtual['views_page'];
          });
        } else {
          print(
              'O campo "desempenho_atual" ou "views_page" não está presente nos dados.');
        }
      }
    } catch (error) {
      print('Erro ao buscar as variáveis da landing page: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              subtitle: '',
              title: 'Minhas Estatisticas',
              isDarkMode: false,
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (!isSmallScreen)
                SizedBox(
                  width: 250, // Largura mínima do CustomMenu
                  child: CustomMenu(),
                ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Minhas Estatísticas',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                  '$viewsPage',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Visualizações de página',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                themeNotifier.enableDarkMode(!themeNotifier.isDarkModeEnabled);
              });
            },
            child: Icon(Icons.lightbulb),
          ),
        ],
      ),
      drawer: isSmallScreen ? CustomMenu() : null,
    );
  }
}
