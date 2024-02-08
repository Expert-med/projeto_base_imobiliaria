import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/pages/auth/auth_page.dart';
import 'package:projeto_imobiliaria/pages/imoveis/cad_imovel_page.dart';
import '../checkPage.dart';
import '../pages/imoveis/imovel_page.dart';
import '../pages/map/map_flutter.dart';
import '../pages/map/map_page.dart';
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
        MaterialPageRoute(builder: (context) => AuthPage()),
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
              title: Text(
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
            title: Text(
              'Mapa',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black54,
              ),
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
          // ListTile(
          //   leading: Icon(
          //     Icons.text_snippet_rounded,
          //     color: widget.isDarkMode
          //         ? darkenColor(Color(0xFF6e58e9), 0.5)
          //         : Color(0xFF6e58e9),
          //   ),
          //   title: Text(
          //     'Mapa Flutter',
          //     style: TextStyle(
          //       color: widget.isDarkMode ? Colors.white : Colors.black54,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => MapPageFlutter(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.text_snippet_rounded,
              color: widget.isDarkMode
                  ? darkenColor(Color(0xFF6e58e9), 0.5)
                  : Color(0xFF6e58e9),
            ),
            title: Text(
              'Imoveis',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ImovelPage(),
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
              'Cadastrar Imóvel',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastroImovel(),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthPage(),
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
            title: Text(
              'Log Out',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
            onTap: () {
              logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
