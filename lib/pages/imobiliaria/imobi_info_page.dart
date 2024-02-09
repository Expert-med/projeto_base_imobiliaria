import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';

import '../../components/imovel/imovel_info_component.dart';

class ImoveisInfoPage extends StatefulWidget {
  final String nome_imovel;
  final String terreno;
  final String location;
  final String originalPrice;
  final List<String> urlsImage;
  bool isDarkMode;
  final String codigo;
  final String area_total;
  final String link;

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
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<ImoveisInfoPage> createState() => _ImoveisInfoPageState();
}

class _ImoveisInfoPageState extends State<ImoveisInfoPage> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: AppBar(
      title: Text('Detalhes'),
    ),
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: ImovelInfoComponent(
        widget.nome_imovel,
        widget.terreno,
        widget.location,
        widget.originalPrice,
        widget.urlsImage,
        widget.isDarkMode,
        widget.codigo,
        widget.area_total,
        widget.link,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget.isDarkMode = !widget.isDarkMode;
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
