import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_carrousel.dart';
import 'package:projeto_imobiliaria/pages/propostas/proposta_add_page.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:provider/provider.dart';
import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_list_view.dart';
import '../../components/propostas/propostas_list_view.dart';
import '../../theme/appthemestate.dart';

class PropostaListPage extends StatefulWidget {
  PropostaListPage({Key? key}) : super(key: key);

  @override
  State<PropostaListPage> createState() => _PropostaListPageState();
}

class _PropostaListPageState extends State<PropostaListPage> {
  bool _showFavoriteOnly = false;
  bool _showGrid = true;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              isDarkMode: false,
              subtitle: '',
              title: 'Propostas',
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (!isSmallScreen) CustomMenu(),
            Expanded(
              child: PropostaListView(),
            ),
          ],
        );
      }),
      drawer: isSmallScreen ? CustomMenu() : null,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return CadastroProposta();
                },
              );
            },
            child: Icon(Icons.add),
          ),
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
    );
  }
}
