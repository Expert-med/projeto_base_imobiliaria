import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/clientes/Clientes.dart';
import '../../models/imoveis/imovel.dart';
import '../../models/imoveis/imovelList.dart';
import '../../models/negociacao/negociacao.dart';
import 'package:flutter/material.dart';

import 'package:projeto_imobiliaria/util/app_bar_model.dart';

import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_list_view.dart';
import '../../models/imoveis/imovelList.dart';
import '../clientes/cliente_info_basicas.dart';

class NegociacaoInfoComponent extends StatefulWidget {
  final Negociacao negociacao;
  bool isDarkMode;
  Clientes cliente;
  NegociacaoInfoComponent(
      {required this.negociacao,
      required this.isDarkMode,
      required this.cliente});

  @override
  _NegociacaoInfoComponentState createState() =>
      _NegociacaoInfoComponentState();
}

class _NegociacaoInfoComponentState extends State<NegociacaoInfoComponent> {
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
              title: 'Informações da página',
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (!isSmallScreen) CustomMenu(isDarkMode: widget.isDarkMode),
            Expanded(
                child: Container(
              color: widget.isDarkMode ? Colors.black : Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClientBasicInfoComponent(
                    cliente: widget.cliente,
                    isDarkMode: widget.isDarkMode,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: Text(
                      'Imóvel:',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: Text(
                      'Etapas da negociação:',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        );
      }),
      drawer: isSmallScreen ? CustomMenu(isDarkMode: false) : null,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 10),
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
