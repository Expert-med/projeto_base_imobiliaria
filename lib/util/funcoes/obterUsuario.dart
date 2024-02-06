import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class obterUsuario {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String?> getUsuarioDocumentId() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return null;
      }

      String currentUserUid = currentUser.uid;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('uid', isEqualTo: currentUserUid)
          .get();

      if (querySnapshot.size == 0) {
        return null;
      }
      return querySnapshot.docs[0].id;
    } catch (e) {
      print('Error while getting hospital document ID: $e');
      return null;
    }
  }
}