import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/models/corretores/corretorList.dart';
import 'package:projeto_imobiliaria/models/imobiliarias/imobiliariasList.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:projeto_imobiliaria/pages/corretores/landingCorretor.dart';
import 'package:projeto_imobiliaria/pages/home_page.dart';
import 'package:projeto_imobiliaria/pages/imoveis/imoveis_landing.dart';
import 'package:projeto_imobiliaria/pages/imoveis/imovel_page.dart';
import 'package:projeto_imobiliaria/theme/appthemestate.dart';
import 'package:provider/provider.dart';
import 'checkPage.dart';
import 'components/imovel/imovel_info_component.dart';
import 'core/models/User_firebase_service.dart';
import 'core/services/firebase/firebase_options.dart';
import 'models/agendamento/agendamentoList.dart';
import 'models/clientes/clientesList.dart';
import 'models/corretores/corretor.dart';
import 'models/imoveis/newImovel.dart';
import 'models/negociacao/negociacaoList.dart';
import 'models/tarefas/tarefasList.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp(); // Atualize o construtor

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> embalagens = [];
  final String nome = Get.parameters['nome'] ?? '';

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
        ChangeNotifierProvider(
          create: (_) => TarefasLista(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppThemeStateNotifier(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final appThemeState = context.watch<
              AppThemeStateNotifier>(); // Obtenha o estado do tema do provedor
          return GetMaterialApp(
            title: 'LarHub',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appThemeState.isDarkModeEnabled
                ? ThemeMode.dark
                : ThemeMode
                    .light, // Defina o tema com base no estado de isDarkModeEnabled
            initialRoute: '/',
            getPages: [
              GetPage(
                name: '/',
                page: () => checkPage(),
              ),
              GetPage(
                name: '/:nome',
                page: () {
                  return FutureBuilder(
                    builder: (context, snapshot) {
                      final nome = Get.parameters['nome'] ?? '';
                      final String corretorNome =
                          nome.toLowerCase().replaceAll('-', ' ');
                      return LandingPage(nome: corretorNome);
                    },
                  );
                },
              ),
              GetPage(
                name: '/:nome/imoveis',
                page: () {
                  return FutureBuilder(
                    builder: (context, snapshot) {
                      final nome = Get.parameters['nome'] ?? '';
                      final String corretorNome =
                          nome.toLowerCase().replaceAll('-', ' ');
                      return ImovelLanding(nome: corretorNome);
                    },
                  );
                },
              ),
              GetPage(
                name: '/:nome/imoveis/:id',
                page: () {
                  final nome = Get.parameters['nome'] ?? '';
                      final String corretorNome =
                          nome.toLowerCase().replaceAll('-', ' ');
                  return FutureBuilder<NewImovel?>(
                    
                    future: Provider.of<NewImovelList>(context, listen: false)
                        .buscarImoveisLandingPorId(corretorNome,
                            Get.parameters['id'] ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erro ao carregar o imóvel'),
                        );
                      } else {
                        final newImovel = snapshot.data;
                        if (newImovel != null) {
                          return ImovelInfoComponent(
                            1,
                            newImovel
                                .caracteristicas, // Passando as características do imóvel
                            newImovel,
                          );
                        } else {
                          return Center(
                            child: Text('Imóvel não encontrado'),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ],
            home: checkPage(),
            debugShowCheckedModeBanner: false,
          );
        },
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
             imoveisFavoritos: List<String>.from(data['imoveis_favoritos'] ?? []),
            id: corretorId,
            name: data['name'] ?? '',
            tipoUsuario: data['tipoUsuario'] ?? 0,
            email: data['email'] ?? '',
            logoUrl: data['logo_url'] ?? '',
            dataCadastro: data['data_cadastro'] ?? '',
            uid: data['uid'] ?? '',
            permissoes: data['permissoes'] ?? '',
            imoveisCadastrados:
                List<String>.from(data['imoveis_cadastrados'] ?? []),
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
