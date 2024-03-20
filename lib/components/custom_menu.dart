import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_imobiliaria/main.dart';
import 'package:provider/provider.dart';
import '../checkPage.dart';
import '../core/models/UserProvider.dart';
import '../core/models/User_firebase_service.dart';
import '../core/services/firebase/auth/auth_service.dart';
import '../pages/agendamentos/geral_agendamento.dart';
import '../pages/auth/auth_page.dart';
import '../pages/corretor_clientes/corretor_clientes.dart';
import '../pages/corretores/lista_corretores_page.dart';
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
import '../pages/propostas/proposta_add_page.dart';
import '../pages/propostas/proposta_list_page.dart';
import '../pages/tarefas/minhas_tarefas_page.dart';
import '../pages/teste.dart';
import '../util/dark_color_util.dart';
import 'cad_imovel_form.dart';

class CustomMenu extends StatefulWidget {
  final bool isDarkMode;

  CustomMenu({required this.isDarkMode});

  @override
  _CustomMenuState createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  bool isExpandedImoveis = false;
  bool isExpandedImobiliarias = false;
  bool isExpandedCorretor = false;
  bool isExpandedPropostas = false;
  CurrentUser? _user;

  @override
  void initState() {
    super.initState();
    // Carrega as informações do usuário ao iniciar a tela
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.initializeUser();
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

  void handleExpandedPropostasChanged(bool expanded) {
    setState(() {
      isExpandedPropostas = expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Drawer(
      backgroundColor: widget.isDarkMode ? Colors.white70 : Color(0xFF602234),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25, bottom: 50),
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: widget.isDarkMode
                    ? darkenColor(Colors.white, 0.5)
                    : Colors.white,
                size: 40,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : Colors.white70,
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
          //       color: widget.isDarkMode ? Colors.white : Colors.white70,
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
                    color: widget.isDarkMode ? Colors.white : Colors.white70,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TesteImovelPage(widget.isDarkMode),
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
          //           color: widget.isDarkMode ? Colors.white : Colors.white70,
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
          //           color: widget.isDarkMode ? Colors.white : Colors.white70,
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
          //           color: widget.isDarkMode ? Colors.white : Colors.white70,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                color: isExpandedCorretor ? Colors.white : null,
                child: ListTile(
                  leading: Icon(
                    Icons.add,
                    color: isExpandedImoveis ? Colors.white : Colors.white,
                  ),
                  title: Text(
                    'Clientes',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.white70,
                    ),
                  ),
                  onTap: () {
                    handleExpandedCorretorChanged(!isExpandedCorretor);
                  },
                ),
              ),
            ),
          if (isExpandedCorretor)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.users,
                  color: Colors.white,
                ),
                title: Text(
                  'Listar Meus Clientes',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.white70,
                  ),
                ),
                onTap: () {
                  print(widget.isDarkMode);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CorretorClientesPage(isDarkMode: widget.isDarkMode),
                    ),
                  );
                },
              ),
            ),
          if (_user?.tipoUsuario == 1)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                color: isExpandedPropostas ? Colors.white : null,
                child: ListTile(
                  leading: Icon(
                    Icons.add,
                    color:
                        isExpandedPropostas ? Colors.white : Colors.white,
                  ),
                  title: Text(
                    'Propostas',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.white70,
                    ),
                  ),
                  onTap: () {
                    handleExpandedPropostasChanged(!isExpandedPropostas);
                  },
                ),
              ),
            ),
          if (isExpandedPropostas)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.scroll,
                  color: Colors.white,
                ),
                title: Text(
                  'Listar Todas',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.white70,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropostaListPage(widget.isDarkMode),
                      fullscreenDialog:
                          true, // Isso impede que o usuário retorne com gestos de deslize
                    ),
                  );
                },
              ),
            ),
          if (isExpandedPropostas)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.fileSignature,
                  color: Colors.white,
                ),
                title: Text(
                  'Criar nova proposta',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.white70,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroProposta(),
                      fullscreenDialog:
                          true, // Isso impede que o usuário retorne com gestos de deslize
                    ),
                  );
                },
              ),
            ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.users,
              color: Colors.white,
            ),
            title: Text(
              'Lista de corretores',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.white70,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CorretoresListPage(isDarkMode: widget.isDarkMode),
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
                  color: widget.isDarkMode ? Colors.white : Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GeralAgendamento(isDarkMode: widget.isDarkMode),
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
                'Minhas Tarefas',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.white70,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MinhasTarefas(),
                  ),
                );
              },
            ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top:180),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: widget.isDarkMode
                    ? darkenColor(Colors.white, 0.5)
                    : Colors.white,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.white70,
                ),
              ),
              onTap: () {
                AuthService().logout;
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
