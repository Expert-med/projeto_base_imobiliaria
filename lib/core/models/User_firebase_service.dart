import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UserProvider.dart';

class UserProvider extends ChangeNotifier {
  ChatUser? _user;

  ChatUser? get user => _user;

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

        QuerySnapshot<Map<String, dynamic>> querySnapshot;
        if (clientesSnapshot.docs.isNotEmpty) {
          querySnapshot = clientesSnapshot;
        } else if (corretoresSnapshot.docs.isNotEmpty) {
          querySnapshot = corretoresSnapshot;
        } else {
          print('Usuário não encontrado nas coleções clientes e corretores');
          return;
        }

        Map<String, dynamic> data = querySnapshot.docs.first.data();
        print(data);

        _user = ChatUser(
          id: user.uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          tipoUsuario: data['tipo_usuario'] ?? 0,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error initializing user: $e');
    }
  }
}
