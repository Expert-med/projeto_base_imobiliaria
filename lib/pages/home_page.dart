import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/pages/user_config_page.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../components/clientes/clientes_home_lista.dart';
import '../components/custom_menu.dart';
import '../components/custom_popup_menu.dart';
import '../components/imovel/imovel_carrousel.dart';
import '../components/negociacao/negociacao_coluna.dart';
import '../components/search_row.dart';
import '../components/tarefas/tarefas_coluna.dart';
import '../core/models/UserProvider.dart';
import '../core/services/firebase/auth/auth_service.dart';
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
            imageUrl: user.photoURL ?? '',
            tipoUsuario: 0,
            contato: {},
            preferencias: [],
            historico: [],
            historicoBusca: [],
            imoveisFavoritos: [],
            UID: '',

          );
          loadLogo(_user.id);
          print(user);
          print('_user : ${_user.imageUrl}');
        });
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> loadLogo(String idConta) async {
    final url = await buscaLogo(idConta);
    setState(() {
      _user.imageUrl = url;
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
              if (!isSmallScreen) CustomMenu(isDarkMode: isDarkMode),
              Expanded(
                child: Container(
                  color: isDarkMode ? Colors.black : Colors.white,
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
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          Icon(Icons.home_outlined,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              size: 40)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            getGreeting(),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black54,
                            ),
                          ),
                          Spacer(),
                          CircleAvatar(
                            backgroundImage: NetworkImage(_user.imageUrl),
                          ),
                          CustomPopupMenu(isDarkMode: isDarkMode),
                        ],
                      ),
                      Text(
                        'Descubra sua residência ideal e a acompanhe!',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode ? Colors.white : Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Encontre sua melhor residência!',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode ? Colors.white : Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //SearchRow(isDarkMode: isDarkMode),
                      SizedBox(
                        height: 10,
                      ),
                      ImovelCarousel(false, isDarkMode),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.grey,
                                child: TarefasColumn(),
                              ),
                            ),
                            SizedBox(
                                width: 10), // Adiciona um espaço de 10 pixels
                            Expanded(
                              child: Container(
                                color: Colors.grey,
                                child: ClientesHomeLista(),
                              ),
                            ),
                            SizedBox(
                                width: 10), // Adiciona um espaço de 10 pixels
                            Expanded(
                              child: Container(
                                color: Colors.grey,
                                child: NegociacaoColuna(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: isSmallScreen ? CustomMenu(isDarkMode: isDarkMode) : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
