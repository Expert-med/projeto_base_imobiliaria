import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_carrousel.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:provider/provider.dart';
import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_list_view.dart';
import '../../components/propostas/propostas_list_view.dart';


class PropostaListPage extends StatefulWidget {
  bool isDarkMode;

  PropostaListPage(this.isDarkMode, {Key? key}) : super(key: key);

  @override
  State<PropostaListPage> createState() => _PropostaListPageState();
}

class _PropostaListPageState extends State<PropostaListPage> {
  bool _showFavoriteOnly = false;
  bool _showGrid = true;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              isDarkMode: widget.isDarkMode,
              subtitle: '',
              title: 'Propostas',
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (!isSmallScreen) CustomMenu(isDarkMode: widget.isDarkMode),
            Expanded(
              child: PropostaListView(
                widget.isDarkMode,
              ),
            ),
          ],
        );
      }),
      drawer: isSmallScreen ? CustomMenu(isDarkMode: false) : null,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
