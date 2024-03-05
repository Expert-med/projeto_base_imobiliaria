import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UserProvider.dart';

class UserProvider extends ChangeNotifier {
  CurrentUser? _user;

  CurrentUser? get user => _user;

  Future<void> initializeUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        QuerySnapshot<Map<String, dynamic>> clientesSnapshot =
            await FirebaseFirestore.instance
                .collection('clientes')
                .where('uid', isEqualTo: user.uid)
                .get();

        QuerySnapshot<Map<String, dynamic>> corretoresSnapshot =
            await FirebaseFirestore.instance
                .collection('corretores')
                .where('uid', isEqualTo: user.uid)
                .get();

        Map<String, dynamic> data = {};

        if (clientesSnapshot.docs.isNotEmpty) {
          data = clientesSnapshot.docs.first.data();
        } else if (corretoresSnapshot.docs.isNotEmpty) {
          data = corretoresSnapshot.docs.first.data();
        } else {
          print('Usuário não encontrado nas coleções clientes e corretores');
          return;
        }

        dynamic preferenciasData = data['preferencias'] ?? [];
        List<Map<String, dynamic>> preferencias = [];

        if (preferenciasData != null) {
          if (preferenciasData is Map) {
            Map<String, dynamic> preferenciasMap = {};
            preferenciasData.forEach((key, value) {
              preferenciasMap[key.toString()] = value;
            });

            preferencias.add(preferenciasMap);
          } else {
            print('Erro: formato inesperado para preferencias');
          }
        }

        List<String> historico = [];
        if (data.containsKey('historico') && data['historico'] != null) {
          if (data['historico'] is List) {
            historico = List<String>.from(data['historico']);
          } else {
            print('Erro: historico não é uma lista');
          }
        }

        List<String> imoveisFavoritos = [];
        if (data['imoveis_favoritos'] != null) {
          if (data['imoveis_favoritos'] is List) {
            imoveisFavoritos = List<String>.from(data['imoveis_favoritos']);
          } else {
            print('Erro: imoveis_favoritos não é uma lista');
          }
        }

        List<String> historicoBusca = [];
        if (data['historico_busca'] != null) {
          if (data['historico_busca'] is List) {
            historicoBusca = List<String>.from(data['historico_busca']);
          } else {
            print('Erro: historico_busca não é uma lista');
          }
        }

        _user = CurrentUser(
          id: user.uid ?? '',
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          logoUrl: data['logoUrl'] ?? '',
          tipoUsuario: data['tipo_usuario'] ?? 0,
          contato: data['contato'] ?? {},
          preferencias: preferencias ?? [],
          historico: historico ?? [],
          historicoBusca: historicoBusca ?? [],
          imoveisFavoritos: imoveisFavoritos ?? [],
          UID: data['UID'] ?? '',
          num_identificacao: '',
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error initializing user: $e');
    }
  }
}
