import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CadastroLocais {
  final _firebaseAuth = FirebaseAuth.instance;
  Uuid uuid = Uuid();
  String id = '';
  FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> inserirSubLocal(
    BuildContext context,
    DocumentReference hospitalDoc,
    int idLocal,
    String _nomeController,
    String _observacoesController,
) async {
  print('entrou');

  final DocumentReference instrumentalRef =
      hospitalDoc.collection('locais_armazenamento').doc(idLocal.toString());

  // Increment the last ID by 1 to get the new ID
  int novoId = await _getNewSubLocalId(instrumentalRef);

  final DocumentReference colecaoRef =
      instrumentalRef.collection('sublocais').doc('$novoId');

  print('id do sublocal $novoId');

  try {
    await colecaoRef.set({
      "id": '$novoId',
      "nome": _nomeController,
      "observacao": _observacoesController,
    });

    print('Elemento inserido com sucesso na subcoleção "especifico"');
  } catch (e) {
    print('Erro ao inserir elemento na subcoleção "especifico": $e');
  }
}


Future<void> inserirSubLocalEditPage(
    BuildContext context,
    DocumentReference hospitalDoc,
    int idLocal,
    String id,
    String _nomeController,
    String _observacoesController,
) async {
  print('entrou');

  final DocumentReference instrumentalRef =
      hospitalDoc.collection('locais_armazenamento').doc(idLocal.toString());


  final DocumentReference colecaoRef =
      instrumentalRef.collection('sublocais').doc('$id');



  try {
    await colecaoRef.set({
      "id": '$id',
      "nome": _nomeController,
      "observacao": _observacoesController,
    });

    print('Elemento inserido com sucesso na subcoleção "especifico"');
  } catch (e) {
    print('Erro ao inserir elemento na subcoleção "especifico": $e');
  }
}

Future<int> _getNewSubLocalId(DocumentReference instrumentalRef) async {
  // Retrieve the last sub-local document
  QuerySnapshot subLocaisSnapshot =
      await instrumentalRef.collection('sublocais').orderBy('id', descending: true).limit(1).get();

  int ultimoId = 0;

  if (subLocaisSnapshot.docs.isNotEmpty) {
    // If there is an existing sub-local, get its ID
    ultimoId = int.parse(subLocaisSnapshot.docs.first['id']);
  }

  // Increment the last ID by 1 to get the new ID
  return ultimoId + 1;
}
}