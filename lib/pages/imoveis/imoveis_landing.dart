import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_grid_favorites.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:projeto_imobiliaria/pages/imoveis/imoveis_Favoritos.dart';
import 'package:projeto_imobiliaria/pages/map/map_flutter.dart';

import 'package:provider/provider.dart';

import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_grid_landing.dart';
import '../../components/imovel/imovel_list_view.dart';
import '../../components/landingPage/footer.dart';
import '../../components/landingPage/landingAppBar.dart';
import '../../components/landingPage/navegacao.dart';
import '../../theme/appthemestate.dart';
import 'cad_imovel_page.dart';

class ImovelLanding extends StatefulWidget {
  final String nome;
  final int fav;

  ImovelLanding({required this.nome, required this.fav, Key? key}) : super(key: key);

  @override
  State<ImovelLanding> createState() => _ImovelLandingState();
}

class _ImovelLandingState extends State<ImovelLanding> {
  late String nomeComEspacos = "";
  Map<String, dynamic> variaveis = {};

  @override
  void initState() {
    super.initState();
    // Extract the nome and replace dashes with spaces
    final currentRoute = Get.currentRoute;
    final nome = currentRoute.split('/corretor/')[1];
    final sem = nome.split("/imoveis")[0];
    nomeComEspacos = sem.replaceAll('-', ' ');
    buscaLanding(nomeComEspacos);
  }

  void buscaLanding(String nome) async {
    try {
      final store = FirebaseFirestore.instance;

      final querySnapshot = await store
          .collection('corretores')
          .where('name', isEqualTo: nome)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;
        final landingDoc = await store
            .collection('corretores')
            .doc(docId)
            .collection('landing')
            .doc(docId)
            .get();

        if (landingDoc.exists) {
          final data = landingDoc.data();
          if (data != null) {
            setState(() {
              variaveis = data;
            });
          } else {
            print('Documento da landing page está vazio.');
          }
        }
      } else {
        print('Nenhum corretor encontrado com o ID atual.');
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
      appBar: widget.fav == 1 ? CustomAppBar(variaveis: variaveis, nome: nomeComEspacos) : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: widget.fav == 0 ? ImoveisFavoritos(isDarkMode: false) : GridLanding(nome: nomeComEspacos, showFavoriteOnly: false),
                  ),   
                  if (widget.fav == 1)
                    Column(
                      children: [
                        Footer(variaveis: variaveis),
                      ],
                    ),
                ],
              ),
            ),
          ],
          
        );
      }),
    );
  }
}
