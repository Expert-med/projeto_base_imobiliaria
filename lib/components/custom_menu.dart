import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/services/firebase/auth/checkPage.dart';
import '../pages/authentication/cadastro_page.dart';
import '../pages/authentication/login_page.dart';
import '../pages/map_page.dart';
import '../util/dark_color_util.dart';

class CustomMenu extends StatefulWidget {
  final bool isDarkMode;

  CustomMenu({required this.isDarkMode});

  @override
  _CustomMenuState createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  void logOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false, // Remove todas as rotas até a raiz
      );
    } catch (e) {
      print('Erro ao sair da conta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      color: widget.isDarkMode
          ? Colors.black54
          : Color.fromARGB(255, 233, 233, 233),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 60),
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: widget.isDarkMode
                    ? darkenColor(Color(0xFF6e58e9), 0.5)
                    : Color(0xFF6e58e9),
                size: 40,
              ),
              title:  Text(
                'Home',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
               color: widget.isDarkMode ? Colors.white : Colors.black54,
              ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => checkPage(),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.text_snippet_rounded,
              color: widget.isDarkMode
                  ? darkenColor(Color(0xFF6e58e9), 0.5)
                  : Color(0xFF6e58e9),
            ),
            title:Text('Mapa',style: TextStyle(
               color: widget.isDarkMode ? Colors.white : Colors.black54,
              ),),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MapSearchPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.text_snippet_rounded,
              color: widget.isDarkMode
                  ? darkenColor(Color(0xFF6e58e9), 0.5)
                  : Color(0xFF6e58e9),
            ),
            title: Text(
              'Cadastrar Conta',
              style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrationPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: widget.isDarkMode
                  ? darkenColor(Color(0xFF6e58e9), 0.5)
                  : Color(0xFF6e58e9),
            ),
            title:  Text('Log Out',style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black54,
              ),),
            onTap: () {
              logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
