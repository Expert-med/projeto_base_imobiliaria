import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/models/corretores/corretorList.dart';
import 'package:projeto_imobiliaria/models/imobiliarias/imobiliariasList.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:projeto_imobiliaria/pages/corretor_clientes/corretor_info_page.dart';
import 'package:projeto_imobiliaria/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'checkPage.dart';
import 'core/models/User_firebase_service.dart';
import 'core/services/firebase/firebase_options.dart';
import 'models/agendamento/agendamentoList.dart';
import 'models/clientes/clientesList.dart';
import 'models/corretores/corretor.dart';
import 'models/negociacao/negociacaoList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool isDarkMode = false; // Define o modo claro como padrão
  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode; // Adicione este parâmetro

  MyApp({required this.isDarkMode}); // Atualize o construtor

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> embalagens = [];

  MaterialColor myPrimaryColor = MaterialColor(
    0xFF6a66ff,
    <int, Color>{
      50: Color(0xFF3e88f3),
      100: Color(0xFF6e58e9),
      200: Color(0xFF3e88f3),
      300: Color(0xFF6e58e9),
      400: Color(0xFF3e88f3),
      500: Color(0xFF3e88f3),
      600: Color(0xFF6e58e9),
      700: Color(0xFF3e88f3),
      800: Color(0xFF6e58e9),
      900: Color(0xFF3e88f3),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImobiliariaList(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientesList(),
        ),
        ChangeNotifierProvider(
          create: (_) => CorretorList(),
        ),
        ChangeNotifierProvider(
          create: (_) => NegociacaoList(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewImovelList(),
        ),
        ChangeNotifierProvider(
          create: (_) => AgendamentoList(),
        ),
      ],
      child: GetMaterialApp(
        title: 'LarHub',
        theme: isDarkMode
            ? ThemeData(
                primarySwatch: myPrimaryColor,
                brightness: Brightness.dark,
              )
            : ThemeData(
                colorScheme: ThemeData().colorScheme.copyWith(
                      primary: Color(0xFF6e58e9),
                      secondary: Color(0xFF6e58e9),
                    ),
                textTheme: TextTheme(
                  bodyText2: TextStyle(
                    fontFamily: 'Montserrat',
                  ),
                  bodyText1: TextStyle(
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
        darkTheme: ThemeData(
          primarySwatch: myPrimaryColor,
          brightness: Brightness.dark,
        ),
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => checkPage(),
          ),
          GetPage(
            name: '/corretor/:id',
            page: () {
              // Essa função é chamada sempre que a rota '/corretor/:id' for acessada
              return FutureBuilder(
                // Aqui você pode buscar os dados do corretor no Firestore
                future: _fetchCorretorData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Se os dados estiverem sendo carregados, você pode exibir um indicador de progresso
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Se ocorrer um erro durante o carregamento dos dados, você pode exibir uma mensagem de erro
                    print(
                        'Erro ao carregar os dados do corretor: ${snapshot.error}');
                    return Scaffold(
                      body: Center(
                        child: Text(
                          'Erro ao carregar os dados do corretor: ${snapshot.error}',
                        ),
                      ),
                    );
                  } else {
                    // Se os dados foram carregados com sucesso, você pode criar a página CorretorInfoPage com os dados do corretor populados
                    final corretor = snapshot.data as Corretor;
                    print(corretor);
                    return CorretorInfoPage(
                      corretor: corretor,
                      isDarkMode: false,
                    );
                  }
                },
              );
            },
          ),
        ],
        home: checkPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Future<Corretor> _fetchCorretorData() async {
    String? corretorId = Get.parameters['id'];
    print(corretorId);
    if (corretorId != null) {
      final firestore = FirebaseFirestore.instance;
      try {
        QuerySnapshot querySnapshot = await firestore
            .collection('corretores')
            .where('id', isEqualTo: corretorId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Se houver documentos correspondentes à consulta
          DocumentSnapshot docSnapshot = querySnapshot.docs.first;
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          Corretor corretor = Corretor(
             id: corretorId,
          name: data['name'] ?? '',
          tipoUsuario: data['tipoUsuario'] ?? 0,
          email: data['email'] ?? '',
          logoUrl: data['logo_url']?? '',
          dataCadastro: data['data_cadastro'] ?? '',
          uid: data['uid'] ?? '',
          permissoes: data['permissoes'] ?? '',
          imoveisCadastrados: List<String>.from(data['imoveis_cadastrados'] ?? []),
          visitas: List<String>.from(data['visitas'] ?? []),
          negociacoes: List<String>.from(data['negociacoes'] ?? []),
          contato: data['contato'] ?? {},
          dadosProfissionais: data['dados_profissionais'] ?? {},
          metas: data['metas'] ?? {},
          desempenhoAtualMetas: data['desempenho_atual_metas'] ?? {},
          infoBanner: data['infoBanner'] ?? {},
          );
          return corretor;
        } else {
          throw 'Documento do corretor não encontrado.';
        }
      } catch (error) {
        throw 'Erro ao buscar dados do corretor: $error';
      }
    } else {
      throw 'ID do corretor não fornecido';
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    MyHomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
