import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_grid_favorites.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';

import '../../components/custom_menu.dart';

import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

class ImoveisFavoritos extends StatefulWidget {
  final String? nome;
  final bool isDarkMode;

  ImoveisFavoritos({this.nome, required this.isDarkMode});

  @override
  State<ImoveisFavoritos> createState() => _ImoveisFavoritosState();
}

class _ImoveisFavoritosState extends State<ImoveisFavoritos> {
  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              subtitle: '',
              title: 'Meus Imóveis Favoritos',
              isDarkMode: widget.isDarkMode)
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: widget.isDarkMode ? Colors.black : Colors.white,
            child: FutureBuilder<List<String>>(
              future: widget.nome != ''
                  ? Provider.of<NewImovelList>(context)
                      .fetchImoveisFavoritosComNome(widget.nome!)
                  : Provider.of<NewImovelList>(context)
                      .fetchImoveisFavoritosSemNome(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Erro ao carregar dados: ${snapshot.error}'));
                } else {
                  List<String> imoveis = snapshot.data ?? [];
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FavoriteImoveisGrid(false, imoveis,
                              nome: widget.nome),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          );
        },
      ),
      drawer: isSmallScreen ? CustomMenu() : null,
    );
  }
}
