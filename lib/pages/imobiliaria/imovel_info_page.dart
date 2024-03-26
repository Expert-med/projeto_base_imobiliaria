import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:provider/provider.dart';

import '../../components/custom_menu.dart';
import '../../components/imovel/imovel_info_component.dart';
import '../../theme/appthemestate.dart';

class ImoveisInfoPage extends StatefulWidget {
  final String nome_imovel;
  final String terreno;
  final String location;
  final String originalPrice;
  final List<String> urlsImage;
  final String codigo;
  final String area_total;
  final String area_privativa;
  final String link;
  final int Vagasgaragem;
  final String Totaldormitorios;
  final String Totalsuites;
  final String longitude;
  final String latitude;
  Map<String, dynamic> caracteristicas;
  final int tipo_pagina;
  NewImovel imovel;

  ImoveisInfoPage({
    Key? key,
    required this.nome_imovel,
    required this.terreno,
    required this.location,
    required this.originalPrice,
    required this.urlsImage,
    required this.codigo,
    required this.area_total,
    required this.link,
    required this.Vagasgaragem,
    required this.Totaldormitorios,
    required this.Totalsuites,
    required this.longitude,
    required this.latitude,
    required this.tipo_pagina,
    required this.caracteristicas,
    required this.imovel,
    required this.area_privativa,
  }) : super(key: key);

  @override
  State<ImoveisInfoPage> createState() => _ImoveisInfoPageState();
}

class _ImoveisInfoPageState extends State<ImoveisInfoPage> {
  
  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nome_imovel}'),
      ),
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
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: ImovelInfoComponent( widget.tipo_pagina,
                      widget.caracteristicas, widget.imovel),
                ),
              ),
            ],
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
    );
  }
}
