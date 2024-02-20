import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_grid_favorites.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';

import '../../components/custom_menu.dart';

class ImoveisFavoritos extends StatefulWidget {
  final bool isDarkMode;

  ImoveisFavoritos({required this.isDarkMode});

  @override
  State<ImoveisFavoritos> createState() => _ImoveisFavoritosState();
}

class _ImoveisFavoritosState extends State<ImoveisFavoritos> {
  List<String> imoveisFavoritos = [];

  List<String> userPreferences = [];

  @override
  void initState() {
    super.initState();
    _fetchImoveisFavoritos();
  }

  Future<void> _fetchImoveisFavoritos() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clientes')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          imoveisFavoritos =
              List<String>.from(snapshot.docs.first['imoveis_favoritos']);
          userPreferences =
              List<String>.from(snapshot.docs.first['preferencias']) ?? [];
        });
      }
    } catch (error) {
      final snapshot = await FirebaseFirestore.instance
          .collection('corretores')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          imoveisFavoritos =
              List<String>.from(snapshot.docs.first['imoveis_favoritos']);
          userPreferences =
              List<String>.from(snapshot.docs.first['preferencias']) ?? [];
        });
      }
      print('Erro ao buscar informações do cliente: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen ? CustomAppBar(subtitle: '', title: 'Meus imoveis favoritos', isDarkMode: widget.isDarkMode) : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: widget.isDarkMode ? Colors.black : Colors.white,
            child: Row(
              children: [
                if (!isSmallScreen) CustomMenu(isDarkMode: widget.isDarkMode),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FavoriteImoveisGrid(
                        false, widget.isDarkMode, imoveisFavoritos),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      drawer: isSmallScreen ? CustomMenu(isDarkMode: widget.isDarkMode) : null,
    );
  }
}
