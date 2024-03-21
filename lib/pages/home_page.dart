import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/pages/user_config_page.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import '../components/clientes/clientes_home_lista.dart';
import '../components/custom_menu.dart';
import '../components/custom_popup_menu.dart';
import '../components/imovel/imovel_carrousel.dart';
import '../components/propostas/negociacao_coluna.dart';
import '../components/search_row.dart';
import '../components/tarefas/tarefas_coluna.dart';
import '../core/models/UserProvider.dart';
import '../core/services/firebase/auth/auth_service.dart';
import '../theme/appthemestate.dart';
import 'auth/auth_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CurrentUser _user;
  late bool isDarkMode;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    isDarkMode = false;
    getCurrentUser();
    _initializeData();
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

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    String getGreeting() {
      var hour = DateTime.now().hour;

      if (hour >= 6 && hour < 12) {
        return 'Bom dia, ${currentUser?.displayName?.toString()}!';
      } else if (hour >= 12 && hour < 19) {
        return 'Boa tarde, ${currentUser?.displayName?.toString()}!';
      } else {
        return 'Boa noite, ${currentUser?.displayName?.toString()}!';
      }
    }

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              subtitle: '',
              title: 'Home',
              isDarkMode: isDarkMode,
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (!isSmallScreen)
                Container(child: CustomMenu(
                  
                )),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'LarHub',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.home_outlined,
                              color: themeNotifier.isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black,
                              size: 40,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              getGreeting(),
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            CircleAvatar(
                              backgroundImage: NetworkImage(_user.logoUrl),
                            ),
                            CustomPopupMenu(),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Descubra sua residência ideal e a acompanhe!',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Encontre sua melhor residência!',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/casa.png'),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        //SearchRow(isDarkMode: isDarkMode),

                        ImovelCarousel(false, isDarkMode),
                        if (_user.tipoUsuario == 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                if (_user.tipoUsuario == 0)
                                  Expanded(
                                    child: Container(
                                      height: 300,
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TarefasColumn(),
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 10),
                                if (_user.tipoUsuario == 0)
                                  Expanded(
                                    child: Container(
                                      height:
                                          300, // Altura fixa para a lista de clientes
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClientesHomeLista(
                                          isDarkMode: isDarkMode,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 10),
                                if (_user.tipoUsuario == 0)
                                  Expanded(
                                    child: Container(
                                      height: 300,
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: NegociacaoColuna(
                                            isDarkMode: isDarkMode),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: isSmallScreen ? CustomMenu() : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            themeNotifier.enableDarkMode(!themeNotifier.isDarkModeEnabled);
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
