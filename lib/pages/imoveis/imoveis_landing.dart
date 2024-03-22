import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_grid_favorites.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:projeto_imobiliaria/pages/imoveis/imoveis_Favoritos.dart';
import 'package:projeto_imobiliaria/pages/map/map_flutter.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:provider/provider.dart';

import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_grid_landing.dart';
import '../../components/imovel/imovel_list_view.dart';
import '../../theme/appthemestate.dart';
import 'cad_imovel_page.dart';

class ImovelLanding extends StatefulWidget {
  final String nome;
  ImovelLanding({required this.nome, Key? key}) : super(key: key);

  @override
  State<ImovelLanding> createState() => _ImovelLandingState();
}

class _ImovelLandingState extends State<ImovelLanding> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              isDarkMode: false,
              subtitle: '',
              title: 'Imóveis',
            )
          : null,
         body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ 
                  Expanded(
                    child: GridLanding(false)
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
