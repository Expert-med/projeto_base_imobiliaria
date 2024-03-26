import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projeto_imobiliaria/main.dart';
import 'package:provider/provider.dart';
import '../checkPage.dart';
import '../core/models/UserProvider.dart';
import '../core/models/User_firebase_service.dart';
import '../core/services/firebase/auth/auth_service.dart';
import '../pages/agendamentos/geral_agendamento.dart';
import '../pages/auth/auth_page.dart';
import '../pages/corretor_clientes/corretor_clientes.dart';
import '../pages/corretores/editarLanding.dart';
import '../pages/corretores/landingCorretor.dart';
import '../pages/imobiliaria/cad_imob_page.dart';
import '../pages/imobiliaria/imobiliarias_page.dart';
import '../pages/imoveis/cad_imovel_page.dart';
import '../pages/imoveis/imoveis_Favoritos.dart';
import '../pages/imoveis/imovel_grid_completa_page.dart';
import '../pages/imoveis/imovel_page.dart';
import '../pages/imoveis/teste_imove_with_bottom.dart';
import '../pages/imoveis/virtual_imovel_tour/virtual_iframe.dart';
import '../pages/map/map_flutter.dart';
import '../pages/map/map_page.dart';
import '../pages/metas/minhas_metas_page.dart';
import '../pages/propostas/proposta_add_page.dart';
import '../pages/propostas/proposta_list_page.dart';
import '../pages/tarefas/minhas_tarefas_page.dart';
import '../pages/teste.dart';
import '../theme/appthemestate.dart';
import '../util/dark_color_util.dart';
import 'cad_imovel_form.dart';

class CustomMenu extends StatefulWidget {
  CustomMenu();

  @override
  _CustomMenuState createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  bool isExpandedImoveis = false;
  bool isExpandedSite = false;
  bool isExpandedImobiliarias = false;
  bool isExpandedCorretor = false;
  bool isExpandedPropostas = false;
  CurrentUser? _user;
  String corretorNome = '';

  @override
  void initState() {
    super.initState();
    // Carrega as informações do usuário ao iniciar a tela
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.initializeUser();
    final store = FirebaseFirestore.instance;
    final User = FirebaseAuth.instance.currentUser;
    final corretorId = User?.uid ?? '';

    final querySnapshot = await store
        .collection('corretores')
        .where('uid', isEqualTo: corretorId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        final corretorData = querySnapshot.docs.first.data();
        String nome = corretorData['name'];
        corretorNome = nome.toLowerCase().replaceAll(' ', '-');
      });
    }
    setState(() {
      _user = userProvider.user;
    });
  }

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

  void handleExpandedCorretorChanged(bool expanded) {
    setState(() {
      isExpandedCorretor = expanded;
    });
  }

  void handleExpandedSiteChanged(bool expanded) {
    setState(() {
      isExpandedSite = expanded;
    });
  }

  void handleExpandedPropostasChanged(bool expanded) {
    setState(() {
      isExpandedPropostas = expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    return Drawer(
      backgroundColor: themeNotifier.isDarkModeEnabled
          ? Color.fromARGB(179, 24, 24, 24)
          : Color(0xFF0230547),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25, bottom: 50),
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: themeNotifier.isDarkModeEnabled
                    ? darkenColor(Colors.white, 0.5)
                    : Colors.white,
                size: 40,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeNotifier.isDarkModeEnabled
                      ? Colors.white
                      : Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => checkPage(),
                  ),
                );
              },
            ),
          ),

          // ListTile(
          //   leading: Icon(
          //     Icons.house,
          //     color: Colors.white,
          //   ),
          //   title: Text(
          //     'Virtual Tour test',
          //     style: TextStyle(
          //       color: themeNotifier.isDarkModeEnabled ? Colors.white : Colors.white70,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => VirtualTourIFrame(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.house,
              color: Colors.white,
            ),
            title: Text(
              'Imoveis',
              style: TextStyle(
                color: themeNotifier.isDarkModeEnabled
                    ? Colors.white
                    : Colors.white70,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TesteImovelPage(false),
                  fullscreenDialog:
                      true, // Isso impede que o usuário retorne com gestos de deslize
                ),
              );
            },
          ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10),
          //   child: AnimatedContainer(
          //     duration: Duration(milliseconds: 300),
          //     curve: Curves.easeInOut,
          //     color: isExpandedImobiliarias ? Colors.white : null,
          //     child: ListTile(
          //       leading: Icon(
          //         Icons.add,
          //         color:
          //             isExpandedImobiliarias ? Colors.white : Colors.white,
          //       ),
          //       title: Text(
          //         'Imobiliarias',
          //         style: TextStyle(
          //           color: themeNotifier.isDarkModeEnabled ? Colors.white : Colors.white70,
          //         ),
          //       ),
          //       onTap: () {
          //         handleExpansionImobiliariasChanged(!isExpandedImobiliarias);
          //       },
          //     ),
          //   ),
          // ),
          // if (isExpandedImobiliarias)
          //   Padding(
          //     padding: const EdgeInsets.only(left: 8, right: 8),
          //     child: ListTile(
          //       leading: Icon(
          //         Icons.home_work,
          //         color: Colors.white,
          //       ),
          //       title: Text(
          //         'Cadastrar Imobiliaria',
          //         style: TextStyle(
          //           color: themeNotifier.isDarkModeEnabled ? Colors.white : Colors.white70,
          //         ),
          //       ),
          //       onTap: () {
          //         Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => CadastroImobiliaria(),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // if (isExpandedImobiliarias)
          //   Padding(
          //     padding: const EdgeInsets.only(left: 8, right: 8),
          //     child: ListTile(
          //       leading: Icon(
          //         Icons.home_work,
          //         color: Colors.white,
          //       ),
          //       title: Text(
          //         'Imobiliarias',
          //         style: TextStyle(
          //           color: themeNotifier.isDarkModeEnabled ? Colors.white : Colors.white70,
          //         ),
          //       ),
          //       onTap: () {
          //         Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 ImobiliariasPage(isDarkMode: widget.isDarkMode),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          if (_user?.tipoUsuario == 1)
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.users,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                'Meus Clientes',
                style: TextStyle(
                  color: themeNotifier.isDarkModeEnabled
                      ? Colors.white
                      : Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CorretorClientesPage(),
                  ),
                );
              },
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              color: isExpandedSite ? Colors.white : null,
              child: ListTile(
                leading: Icon(
                  Icons.add,
                  color: isExpandedSite ? Color(0xFF6e58e9) : Colors.white,
                ),
                title: Text(
                  'Meu Site',
                  style: TextStyle(
                    color: isExpandedSite ? Color(0xFF6e58e9) : Colors.white70,
                  ),
                ),
                onTap: () {
                  handleExpandedSiteChanged(!isExpandedSite);
                },
              ),
            ),
          ),
          if (isExpandedSite)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: Icon(
                  Icons.pageview,
                  color: Colors.white,
                ),
                title: Text(
                  'Ver minha página',
                  style: TextStyle(
                    color: themeNotifier.isDarkModeEnabled
                        ? Colors.white
                        : Colors.white70,
                  ),
                ),
                onTap: () {
                  print("object");
                  print(corretorNome);
                  Get.toNamed('/corretor/$corretorNome');
                },
              ),
            ),
          if (isExpandedSite)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.edit,
                  color: Colors.white,
                ),
                title: Text(
                  'Editar pagina',
                  style: TextStyle(
                    color: themeNotifier.isDarkModeEnabled
                        ? Colors.white
                        : Colors.white70,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditarLandingPage()));
                },
              ),
            ),
          if (_user?.tipoUsuario == 1)
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.scroll,
                color: Colors.white,
              ),
              title: Text(
                'Propostas',
                style: TextStyle(
                  color: themeNotifier.isDarkModeEnabled
                      ? Colors.white
                      : Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropostaListPage(),
                    fullscreenDialog:
                        true, // Isso impede que o usuário retorne com gestos de deslize
                  ),
                );
              },
            ),

          if (_user?.tipoUsuario == 1)
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.calendar,
                color: Colors.white,
              ),
              title: Text(
                'Agendamentos',
                style: TextStyle(
                  color: themeNotifier.isDarkModeEnabled
                      ? Colors.white
                      : Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeralAgendamento(),
                  ),
                );
              },
            ),
          if (_user?.tipoUsuario == 1)
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.tasks,
                color: Colors.white,
              ),
              title: Text(
                'Minhas Tarefas',
                style: TextStyle(
                  color: themeNotifier.isDarkModeEnabled
                      ? Colors.white
                      : Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MinhasTarefas(),
                  ),
                );
              },
            ),
          if (_user?.tipoUsuario == 1)
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.chartBar,
                color: Colors.white,
              ),
              title: Text(
                'Minhas Estatisticas',
                style: TextStyle(
                  color: themeNotifier.isDarkModeEnabled
                      ? Colors.white
                      : Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MinhasEstatisticas(),
                  ),
                );
              },
            ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: themeNotifier.isDarkModeEnabled
                    ? darkenColor(Colors.white, 0.5)
                    : Colors.white,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: themeNotifier.isDarkModeEnabled
                      ? Colors.white
                      : Colors.white70,
                ),
              ),
              onTap: () async {
                await AuthService()
                    .logout(); // Chame o método logout() com parênteses
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
