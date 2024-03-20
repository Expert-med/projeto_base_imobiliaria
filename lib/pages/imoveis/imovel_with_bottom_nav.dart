import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../components/custom_popup_menu.dart';
import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_list_view.dart';
import '../../core/models/UserProvider.dart';
import '../map/map_flutter.dart';
import 'cad_imovel_page.dart';
import 'imoveis_Favoritos.dart';


class ImovelWithBottomNav extends StatefulWidget {
  bool isDarkMode;
  
  ImovelWithBottomNav(this.isDarkMode, {Key? key}) : super(key: key);

  @override
  _ImovelWithBottomNavState createState() => _ImovelWithBottomNavState();
}

class _ImovelWithBottomNavState extends State<ImovelWithBottomNav> {
  int _selectedIndex = 0;
  late CurrentUser _user;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _initializeData();
    // Atualize o valor de isDarkMode aqui
    widget.isDarkMode = widget.isDarkMode; // Isso dispara uma notificação de mudança
    _widgetOptions = [
      ImovelGrid(widget.isDarkMode, widget.isDarkMode), // Página 1
      ImovelListView(widget.isDarkMode, widget.isDarkMode), // Página 2
      MapPageFlutter(),
      ImoveisFavoritos(isDarkMode: widget.isDarkMode),
      CadastroImovel(),
    ];
  }

  Future<void> _initializeData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Set the user information to the state
        setState(() {
          _user = CurrentUser(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            logoUrl: user.photoURL ?? '',
            tipoUsuario: 0,
            contato: {},
            preferencias: [],
            historico: [],
            historicoBusca: [],
            imoveisFavoritos: [],
            UID: '',
            num_identificacao: '',
          );
          loadLogo(_user.id);
        });
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> loadLogo(String idConta) async {
    final url = await buscaLogo(idConta);
    setState(() {
      _user.logoUrl = url;
    });
  }

  Future<String> buscaLogo(String idConta) async {
    final ref = firebase_storage.FirebaseStorage.instance
        .ref('logos/logo-$idConta.jpeg');
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: !widget.isDarkMode ? Color(0xFF602234) : Colors.black,
        elevation: 0,
        toolbarHeight: 50,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomPopupMenu(isDarkMode: widget.isDarkMode),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.isDarkMode = !widget.isDarkMode;
                    });
                  },
                  icon: Icon(
                    widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: NetworkImage(_user.logoUrl),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: !widget.isDarkMode ? Color(0xFF602234) : Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Color(0xFF6e58e9),
            tabs: [
              GButton(
                icon: Icons.grid_on_sharp,
                text: 'Grid',
              ),
              GButton(
                icon: Icons.list,
                text: 'Lista',
              ),
              GButton(
                icon: Icons.place,
                text: 'Mapa',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Favoritos',
              ),
              GButton(
                icon: Icons.add,
                text: 'Adicionar',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
