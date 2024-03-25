import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_imobiliaria/pages/auth/auth_page.dart';
import 'package:projeto_imobiliaria/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'components/imovel/imovel_info_component.dart';
import 'models/imoveis/newImovel.dart';
import 'models/imoveis/newImovelList.dart';
import 'pages/corretores/landingCorretor.dart';
import 'pages/imoveis/imoveis_landing.dart';
import 'util/routes/routes_param.dart';

class checkPage extends StatefulWidget {
  const checkPage({super.key});

  @override
  State<checkPage> createState() => _checkPageState();
}

class _checkPageState extends State<checkPage> {
  late StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        // Usuário autenticado, redirecione para a página inicial
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final allowedRoutes = [
      '/corretor/:nome/imoveis/:id',
      '/corretor/:nome/imoveis',
      '/corretor/:nome'
    ];

    // Verificar se a rota atual corresponde a uma rota permitida
    if (currentRoute != null && allowedRoutes.contains(currentRoute)) {
      // Extrair parâmetros da rota
      final params = RouteParams.fromRoute(currentRoute);
      final nome = params.nome;
      final id = params.id;

      // Renderizar a página correspondente
      if (currentRoute == '/corretor/:nome/imoveis/:id') {
        final String corretorNome = nome!.toLowerCase().replaceAll('-', ' ');
        return LandingPage(
          nome: corretorNome,
        );
      } else if (currentRoute == '/corretor/:nome/imoveis') {
        final String corretorNome = nome!.toLowerCase().replaceAll('-', ' ');
        return ImovelLanding(
          nome: corretorNome,
          fav: 1,
        );
      } else if (currentRoute == '/corretor/:nome') {
        final String corretorNome = nome!.toLowerCase().replaceAll('-', ' ');

        return FutureBuilder<NewImovel?>(
          future: Provider.of<NewImovelList>(context!, listen: false)
              .buscarImoveisLandingPorId(corretorNome, id!),
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
      }
    }

    // Se não corresponder a nenhuma das rotas permitidas, redirecione para a página de login
    return AuthPage(key: GlobalKey(),);
  }
}
