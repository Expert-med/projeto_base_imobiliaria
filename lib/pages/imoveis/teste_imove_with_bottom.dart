import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:projeto_imobiliaria/pages/imoveis/imoveis_Favoritos.dart';
import 'package:projeto_imobiliaria/pages/map/map_flutter.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_list_view.dart';
import 'cad_imovel_page.dart';
import 'imovel_with_bottom_nav.dart';

class TesteImovelPage extends StatefulWidget {
  bool isDarkMode;

  TesteImovelPage(this.isDarkMode, {Key? key}) : super(key: key);

  @override
  State<TesteImovelPage> createState() => _TesteImovelPageState();
}

class _TesteImovelPageState extends State<TesteImovelPage> {

  @override
  void initState() {
    super.initState();
    NewImovelList().buscarImoveis();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              isDarkMode: widget.isDarkMode,
              subtitle: '',
              title: 'Imóveis',
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (!isSmallScreen) CustomMenu(),
            Expanded(
              child: ImovelWithBottomNav(),
            ),
          ],
        );
      }),
      drawer: isSmallScreen ? CustomMenu() : null,

    );
  }
}
