import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';

import '../../components/custom_menu.dart';
import '../../components/imovel/imovel_info_component.dart';


class ImoveisInfoPage extends StatefulWidget {
  final String nome_imovel;
  final String terreno;
  final String location;
  final String originalPrice;
  final List<String> urlsImage;
  final String codigo;
  final String area_total;
  final String link;
  final int Vagasgaragem;
  final String Totaldormitorios;
  final String Totalsuites;
  final String longitude;
  final String latitude;
final int tipo_pagina;
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
  }) : super(key: key);

  @override
  State<ImoveisInfoPage> createState() => _ImoveisInfoPageState();
}


class _ImoveisInfoPageState extends State<ImoveisInfoPage> {
  bool isDarkMode=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nome_imovel}'),
      ),
      body: Container(
        child: ImovelInfoComponent(
          widget.nome_imovel,
          widget.terreno,
          widget.location,
          widget.originalPrice,
          widget.urlsImage,
          isDarkMode,
          widget.codigo,
          widget.area_total,
          widget.link,
          widget.Vagasgaragem,
          widget.Totaldormitorios,
          widget.Totalsuites,
widget.latitude,
widget.longitude,
widget.tipo_pagina
        ),
    
    
      ),
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