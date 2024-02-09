import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_imobiliaria/core/services/cadastros/cadastros_service.dart';
import 'package:uuid/uuid.dart';

class CadastroFirebaseService implements CadastroService {
  Uuid uuid = Uuid();

  String generateId() {
    String uniqueId = uuid.v4();
    String id = uniqueId
        .substring(0, 4)
        .toUpperCase(); // Extrair os primeiros 4 caracteres
    return id;
  }

  Future<void> cadastroImobiliaria(
    String name,
    String url_base,
    String url_logo,
  ) async {
    final store = FirebaseFirestore.instance;
    final uid = generateId();

    final docRef = store.collection('imobiliarias').doc(uid);

    return docRef.set({
      'id': uid,
      'nome': name,
      'url_base': url_base,
      'url_logo': url_logo,
      'seletores': []
    });
  }
}
