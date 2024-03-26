import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/components/imovel/image_stagred_compontent.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_list_view.dart';
import 'package:projeto_imobiliaria/pages/corretores/editarLanding.dart';
import 'package:projeto_imobiliaria/pages/map/map_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/imovel/imovel_carousel_favorites.dart';
import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_grid_favorites.dart';
import '../../components/landingPage/beneficio.dart';
import '../../components/landingPage/footer.dart';
import '../../components/landingPage/landingAppBar.dart';
import '../../components/landingPage/navegacao.dart';
import '../../components/landingPage/perguntas.dart';
import '../../components/landingPage/porque.dart';
import '../../components/landingPage/solucao.dart';
import '../../components/landingPage/titulo.dart';
import '../../theme/appthemestate.dart';

class LandingPage extends StatefulWidget {
  final String nome;
  LandingPage({required this.nome, Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Map<String, dynamic> variaveis = {};
  static const routeName = '/extractArguments';

  @override
  void initState() {
    super.initState();

    buscaLanding(widget.nome);
  }

  @override
  void dispose() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    super.dispose();
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
        final docSnapshot = querySnapshot.docs[0];

        final desempenho_atual = docSnapshot['desempenho_atual'];
        if (desempenho_atual != null &&
            desempenho_atual['views_page'] != null) {
          final viewsPage = desempenho_atual['views_page'];
          print('Valor de views_page: $viewsPage');
        } else {
          print(
              'O campo "desempenho_atual" ou "views_page" não está presente nos dados.');
        }

        // Verifica se há usuário logado e se o nome é diferente do nome recebido
        // Verifica se há usuário logado e se o nome é diferente do nome recebido
        final user = FirebaseAuth.instance.currentUser;
print('firebase: ${user?.displayName}, parametro: $nome ');
if (user == null || user.displayName != nome) {
  // Incrementa views_page
  await store
    .collection('corretores')
    .doc(docId)
    .update({'desempenho_atual.views_page': FieldValue.increment(1)});
}

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
    int corPrincipal = Colors.white.value; // Cor padrão
    Color corPrincipalColor = Color(corPrincipal);
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);

    if (variaveis.containsKey("cores") &&
        variaveis["cores"] != null &&
        variaveis["cores"]!.containsKey("corPrincipal")) {
      int? corPrincipalValue =
          int.tryParse(variaveis["cores"]!["corPrincipal"]!);
      if (corPrincipalValue != null) {
        corPrincipal = corPrincipalValue;
        corPrincipalColor = Color(corPrincipal);
      }
    }
    return Scaffold(
      appBar: variaveis.isEmpty
          ? null
          : CustomAppBar(
              variaveis: variaveis,
              nome: widget.nome,
              showBackButton: FirebaseAuth.instance.currentUser != null,
            ),
      body: variaveis.isEmpty
          ? null
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: corPrincipalColor,
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Titulo(variaveis: variaveis, nome: widget.nome),
                              Solucao(variaveis: variaveis),
                              Beneficio(tipoPagina: 0, variaveis: variaveis),
                              Beneficio(tipoPagina: 1, variaveis: variaveis),
                              Perguntas(variaveis: variaveis),
                              Porque(variaveis: variaveis),
                              Navegacao(variaveis: variaveis),
                              Footer(variaveis: variaveis),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            themeNotifier.enableDarkMode(!themeNotifier.isDarkModeEnabled);
          });
        },
        child: Icon(Icons.lightbulb),
      ),
      // drawer: FirebaseAuth.instance.currentUser != null ? CustomMenu() : null,
    );
  }
}
