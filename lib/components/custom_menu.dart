import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/pages/auth/auth_page.dart';
import 'package:projeto_imobiliaria/pages/imobiliaria/cad_imob_page.dart';
import 'package:projeto_imobiliaria/pages/imoveis/cad_imovel_page.dart';
import '../checkPage.dart';
import '../pages/imobiliaria/imobiliarias_page.dart';
import '../pages/imoveis/imovel_grid_completa_page.dart';
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
  bool isExpandedImoveis = false;
  bool isExpandedImobiliarias = false;

  void handleExpansionImoveisChanged(bool expanded) {
    setState(() {
      isExpandedImoveis = expanded;
    });
  }

  void handleExpansionImobiliariasChanged(bool expanded) {
    setState(() {
      isExpandedImobiliarias = expanded;
    });
  }

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
              Icons.map_outlined,
              color: widget.isDarkMode
                  ? darkenColor(Color(0xFF6e58e9), 0.5)
                  : Color(0xFF6e58e9),
            ),
            title: Text(
              'Mapa dos imóveis',
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

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              color: isExpandedImoveis ? Color(0xFF6e58e9) : null,
              child: ListTile(
                leading: Icon(
                  Icons.add,
                  color: isExpandedImoveis ? Colors.white : Color(0xFF6e58e9),
                ),
                title: Text(
                  'Imóveis',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black54,
                  ),
                ),
                onTap: () {
                  handleExpansionImoveisChanged(!isExpandedImoveis);
                },
              ),
            ),
          ),
          if (isExpandedImoveis)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: Icon(
                  Icons.house,
                  color:  Color(0xFF6e58e9),
                ),
                title: Text(
                  'Lista de imóveis',
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
            ),
          if (isExpandedImoveis)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: Icon(
                  Icons.house,
                  color:  Color(0xFF6e58e9),
                ),
                title: Text(
                  'Busca de imóveis',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black54,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImovelGridCompletaSemComponente(),
                    ),
                  );
                },
              ),
            ),
          if (isExpandedImoveis)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: Icon(
                  Icons.house,
                  color:  Color(0xFF6e58e9),
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
            ),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              color: isExpandedImobiliarias ? Color(0xFF6e58e9) : null,
              child: ListTile(
                leading: Icon(
                  Icons.add,
                  color:
                      isExpandedImobiliarias ? Colors.white : Color(0xFF6e58e9),
                ),
                title: Text(
                  'Imobiliarias',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black54,
                  ),
                ),
                onTap: () {
                  handleExpansionImobiliariasChanged(!isExpandedImobiliarias);
                },
              ),
            ),
          ),
          if (isExpandedImobiliarias)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: Icon(
                  Icons.home_work,
                  color:  Color(0xFF6e58e9),
                ),
                title: Text(
                  'Cadastrar Imobiliaria',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black54,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroImobiliaria(),
                    ),
                  );
                },
              ),
            ),
          if (isExpandedImobiliarias)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: Icon(
                  Icons.home_work,
                  color:  Color(0xFF6e58e9),
                ),
                title: Text(
                  'Imobiliarias',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black54,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImobiliariasPage(),
                    ),
                  );
                },
              ),
            ),

          Divider(),
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
