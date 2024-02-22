import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/corretores/lista_corretores_page.dart';
import '../pages/imoveis/imoveis_Favoritos.dart';
import '../pages/map/map_page.dart';
import 'NotificationButton.dart';
import 'dark_color_util.dart';
//import 'package:projeto_cme_novo/autenticacao/checkPage.dart';

class NewCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isDarkMode;

  NewCustomAppBar({
    required this.title,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Row(
            children: [
              Icon(Icons.favorite),
              SizedBox(
                width: 5,
              ),
              Text('Imóveis favoritos'),
            ],
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ImoveisFavoritos(isDarkMode: isDarkMode),
              ),
            );
          },
        ),
       Column(
        children: [
          IconButton(
          icon: Row(
            children: [
              Icon(Icons.map_outlined),
              SizedBox(
                width: 5,
              ),
              Text('Mapa dos imoveis'),
            ],
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MapPage(),
              ),
            );
          },
        ),
        IconButton(
          icon: Row(
            children: [
              Icon(Icons.people),
              SizedBox(
                width: 5,
              ),
              Text('Lista de corretores'),
            ],
          ),
          onPressed: () {
            Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CorretoresListPage(isDarkMode:isDarkMode),
                    ),
                  );
          },
        ),
        ],
       ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Imóveis favoritos',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(100.0); // Ajuste conforme necessário
}
