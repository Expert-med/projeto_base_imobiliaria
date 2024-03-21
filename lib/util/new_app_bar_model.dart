import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/imoveis/imoveis_Favoritos.dart';
import '../pages/map/map_page.dart';
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
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return AppBar(
      backgroundColor:
          isDarkMode ? Colors.black : Color.fromARGB(255, 238, 238, 238),
      elevation: 0,
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon( color: isDarkMode
                      ? darkenColor(Color(0xFF6e58e9), 0.5)
                      : Color(0xFF6e58e9),Icons.home),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black54,
                          ),
                  ),
                ],
              ),
              GestureDetector(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon( color: isDarkMode
                      ? darkenColor(Color(0xFF6e58e9), 0.5)
                      : Color(0xFF6e58e9),Icons.home),
                      onPressed: () {},
                    ),
                    Text(
                      'Imóveis favoritos',
                      style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black54,
                          ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImoveisFavoritos(isDarkMode: isDarkMode),
                    ),
                  );
                },
              ),
              Column(
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon( color: isDarkMode
                      ? darkenColor(Color(0xFF6e58e9), 0.5)
                      : Color(0xFF6e58e9),Icons.map),
                          onPressed: () {},
                        ),
                        Text(
                          'Mapa dos imóveis',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(),
                        ),
                      );
                    },
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(100.0); // Ajuste conforme necessário
}
