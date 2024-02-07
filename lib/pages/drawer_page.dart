import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../util/dark_color_util.dart';
import 'authentication/cadastro_page.dart';
import '../core/services/firebase/auth/checkPage.dart';
import 'authentication/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

import 'map/map_page.dart';

class DrawerPage extends StatefulWidget {
  final bool isDarkMode;

  DrawerPage({required this.isDarkMode});

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

Future<String> buscaLogo(String idConta) async {
  final ref =
      firebase_storage.FirebaseStorage.instance.ref('logos/logo-$idConta.jpeg');
  final url = await ref.getDownloadURL();
  return url;
}

String currentUserUid = '';

Future<String?> fetchCurrentUserEmail() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    currentUserUid = currentUser.uid;
    return currentUser.email;
  }
  return null;
}

class _DrawerPageState extends State<DrawerPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late DocumentReference hospitalDoc;

  bool isExpanded = false;
  bool isExpandedManutencao = false;
  bool isExpandedMateriais = false;
  bool isExpandedExportacao = false;
  bool isExpandedCriarCaixa = false;
  bool isExpandedCadastros = false;
  bool isExpandedInstituicoes = false;
  String logoURL = '';
  late int? valida = 0;
  late String idTemp = '';
  late DocumentReference clienteDoc;

  String? currentUserEmail;
  String? userName;
  int hospitalValue = 2;
  int tipoConta = 1;
  int nivelEmbalagem = 1;
  String idConta = "";
  int importacao = 1;

  // Lista para armazenar os resultados
  List<Map<String, dynamic>> hospitaisEncontrados = [];

  @override
  void initState() {
    super.initState();

    loadCurrentUserEmail();
  }

  Future<void> loadCurrentUserEmail() async {
    final email = await fetchCurrentUserEmail();
    setState(() {
      currentUserEmail = email;
    });
  }

  void handleExpansionChanged(bool expanded) {
    setState(() {
      isExpanded = expanded;
    });
  }

  void handleExpansionManutencaoChanged(bool expanded) {
    setState(() {
      isExpandedManutencao = expanded;
    });
  }

  void handleExpansionMeusMateriaisChanged(bool expanded) {
    setState(() {
      isExpandedMateriais = expanded;
    });
  }

  void handleExpansionExportacaoChanged(bool expanded) {
    setState(() {
      isExpandedExportacao = expanded;
    });
  }

  void handleExpansionCriarCaixa(bool expanded) {
    setState(() {
      isExpandedCriarCaixa = expanded;
    });
  }

  void handleExpansionCadastros(bool expanded) {
    setState(() {
      isExpandedCadastros = expanded;
    });
  }

  Future<void> loadLogo(String idConta) async {
    final url = await buscaLogo(idConta);
    setState(() {
      logoURL = url;
    });
  }

  void handleExpansionInstituicoes(bool expanded) {
    setState(() {
      isExpandedInstituicoes = expanded;
    });
  }

  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (e) {
      print('Erro ao sair da conta.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        child: Drawer(
          backgroundColor: widget.isDarkMode
                    ? Colors.white
                    : darkenColor(Colors.white, 0.05),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 60),
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: widget.isDarkMode
                    ? Color(0xFF6e58e9)
                    : darkenColor(Color(0xFF6e58e9), 0.5),
                size: 40,
              ),
              title: const Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
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
              Icons.text_snippet_rounded,
              color: widget.isDarkMode
                  ? Color(0xFF6e58e9)
                  : darkenColor(Color(0xFF6e58e9), 0.5),
            ),
            title: const Text('Mapa'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.text_snippet_rounded,
                color: widget.isDarkMode
                    ? Color(0xFF6e58e9)
                    : darkenColor(Color(0xFF6e58e9), 0.5)),
            title: const Text('Cadastrar Conta'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrationPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout,
                color: widget.isDarkMode
                    ? Color(0xFF6e58e9)
                    : darkenColor(Color(0xFF6e58e9), 0.5)),
            title: const Text('Log Out'),
            onTap: logOut,
          ),
        ],
      ),
    ));
  }
}
