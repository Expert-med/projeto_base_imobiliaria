import 'package:fluro/fluro.dart';
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

  final router = FluroRouter(); // Crie o roteador Fluro
  defineRoutes(router); // Defina as rotas Fluro

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
   final FluroRouter router;
  final GlobalKey<NavigatorState> navigatorKey;

  MyApp({required this.router}) : navigatorKey = GlobalKey<NavigatorState>();


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
          final appThemeState = context.watch<AppThemeStateNotifier>();

          return GetMaterialApp(
             key: navigatorKey,
            title: 'LarHub',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appThemeState.isDarkModeEnabled
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: '/home',
            onGenerateRoute: router.generator,
            home: checkPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
void defineRoutes(FluroRouter router) {
  router.define(
    '/home',
    handler: Handler(handlerFunc: (context, params) => checkPage()),
  );

  router.define(
    '/corretor/:nome',
    handler: Handler(
      handlerFunc: (context, params) {
        final nome = params['nome']?.first;
        final String corretorNome = nome!.toLowerCase().replaceAll('-', ' ');
        print(corretorNome);
        return LandingPage(nome: corretorNome ?? '');
      },
    ),
  );

  router.define(
    '/corretor/:nome/imoveis',
    handler: Handler(
      handlerFunc: (context, params) {
        final nome = params['nome']?.first;
        final String corretorNome = nome!.toLowerCase().replaceAll('-', ' ');
        print(corretorNome);
        return ImovelLanding(
          nome: corretorNome,
          fav: 1,
        );
      },
    ),
  );

  router.define(
    '/corretor/:nome/imoveis/:id',
    handler: Handler(
      handlerFunc: (context, params) {
        final nome = params['nome']?.first ?? '';
        final id = params['id']?.first ?? '';
        final corretorNome = nome.toLowerCase().replaceAll('-', ' ');

        return FutureBuilder<NewImovel?>(
          future: Provider.of<NewImovelList>(context!, listen: false)
              .buscarImoveisLandingPorId(corretorNome, id),
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
                  0,
                  newImovel.caracteristicas,
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
  );
}

