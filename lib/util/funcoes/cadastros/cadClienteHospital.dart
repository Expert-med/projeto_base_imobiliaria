//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CadastroUsuario {
  final _firebaseAuth = FirebaseAuth.instance;
  Uuid uuid = Uuid();
  String id = '';
  FirebaseFirestore db = FirebaseFirestore.instance;

  String generateId() {
    String uniqueId = uuid.v4();
    id = uniqueId
        .substring(0, 4)
        .toUpperCase(); // Extrair os primeiros 4 caracteres
    return id;
  }

  cadastrar(
    BuildContext context,
    bool isHospital,
    String nomeController,
    String emailController,
    String passwordController,
    String cnpjController,
    String idPar,
  ) async {
    print('entrou em cadastrar $idPar');
    id=idPar;
     print('Novo id $id');

    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController,
        password: passwordController,
      );
      User? user = userCredential.user;

      if (user != null) {
        if (id == '') {
          generateId();
        } 
        

        if (isHospital) {
          salvarDadosNoFirestore(
              user, nomeController, emailController, cnpjController);
          criarColecao();
          moveInstrumentais();
          moveTipos();
          moveCaixas();
        } else {
          salvarDadosCliente(
              user, nomeController, emailController, cnpjController);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Crie uma senha mais forte"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email já cadastrado"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> salvarDadosNoFirestore(
    User user,
    String nomeController,
    String emailController,
    String cnpjController,
  ) async {
    String nome = nomeController;
    String email = emailController;
    String cnpj = cnpjController;
    String idHospital = id;

    try {
      await db.collection("hospitais").doc(idHospital).set({
        'id': idHospital,
        'nome': nome,
        'email': email,
        'cnpj': cnpj,
        'uid': user.uid,
        'hospital': 1,
        'tipoConta': 1,
        'nivelEmbalagem': 1,
      });

      // Atualize o displayName do usuário com o nome fornecido
      if (user != null) {
        await user.updateDisplayName(nome);
      }
    } catch (e) {
      // Lida com qualquer erro que possa ocorrer ao salvar os dados
      print('Erro ao salvar os dados: $e');
    }
  }

Future<String> salvarDadosNoFirestoreSemConta(
      TextEditingController nomeController,
      TextEditingController emailController,
      TextEditingController cnpjController,
      int isHospital) async {
     generateId();
    String nome = nomeController.text;
    String email = emailController.text;
    String cnpj = cnpjController.text;
    String idHospital = id;
    
    if (isHospital == 1) {
      try {
        await db.collection("hospitais").doc(idHospital).set({
          'id': idHospital,
          'nome': nome,
          'email': email,
          'cnpj': cnpj,
          'uid': '',
          'hospital': isHospital,
          'tipoConta': 1,
          'nivelEmbalagem': 1,
        });
      } catch (e) {
        // Lida com qualquer erro que possa ocorrer ao salvar os dados
        print('Erro ao salvar os dados: $e');
      }
    } else {
      try {
        await db.collection("clientes").doc(idHospital).set({
          'id': idHospital,
          'nome': nome,
          'email': email,
          'cnpj': cnpj,
          'uid': '',
          'hospital': isHospital,
          'tipoConta': 1,
          'nivelEmbalagem': 1,
        });
      } catch (e) {
        // Lida com qualquer erro que possa ocorrer ao salvar os dados
        print('Erro ao salvar os dados: $e');
      }
    }

    return idHospital;
}


  void criarColecao() async {
    try {
      String hospitalId =
          id; // Substitua pelo ID do documento do hospital onde você deseja criar a subcoleção.
      String parentCollection =
          'hospitais'; // Substitua pelo nome da coleção pai (no caso, "hospitais").

      // Referência ao documento pai onde a subcoleção será criada.
      DocumentReference parentDocRef = FirebaseFirestore.instance
          .collection(parentCollection)
          .doc(hospitalId);

      // Criação da subcoleção dentro do documento pai.
      await parentDocRef.collection('embalagem').doc('0').set({});
      await parentDocRef.collection('instrumentais').doc('0').set({});
      await parentDocRef.collection('tipo_instrumental').doc('0').set({});
      await parentDocRef
          .collection('caixas')
          .doc('0')
          .set({'mover': '0', 'id': 0});

      await parentDocRef.collection('instrumentais').doc('0').delete();
      await parentDocRef.collection('tipo_instrumental').doc('0').delete();

      print('Subcoleção criada com sucesso dentro do documento do hospital.');
    } catch (e) {
      print('Erro ao criar a subcoleção: $e');
    }
  }

  void moveInstrumentais() async {
    final String sourceCollection = 'hospitais';
    final String sourceDocumentId = 'Yo6n';
    final String sourceSubcollection = 'instrumentais';
    final String destinationSubcollection = 'instrumentais';
    String idDoc = id;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(sourceCollection)
        .doc(sourceDocumentId)
        .collection(sourceSubcollection)
        .get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    CollectionReference destinationCollectionRef = FirebaseFirestore.instance
        .collection(sourceCollection)
        .doc(idDoc)
        .collection(destinationSubcollection);

    for (QueryDocumentSnapshot document in documents) {
      String docId = document.id;
      if (docId.length > 4) {
        docId = docId.substring(4);

        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['id'] = idDoc + docId;
        print('data $data');
        await destinationCollectionRef.doc(idDoc + docId).set(data);
      } else {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        data['id'] = idDoc + docId;
        print('data $data');

        await destinationCollectionRef.doc(idDoc + docId).set(data);
      }
    }

    print('Instrumentais movidos com sucesso para as novas subcoleções.');
  }

  void moveTipos() async {
    final String sourceCollection = 'hospitais';
    final String sourceDocumentId = 'Yo6n';
    final String sourceSubcollection = 'tipo_instrumental';
    final String destinationSubcollection = 'tipo_instrumental';
    String idDoc = id;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(sourceCollection)
        .doc(sourceDocumentId)
        .collection(sourceSubcollection)
        .get();

    // Step 2: Mover os documentos para a nova subcoleção em 'hospitais'
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    CollectionReference destinationCollectionRef = FirebaseFirestore.instance
        .collection(sourceCollection)
        .doc(idDoc)
        .collection(destinationSubcollection);

    // Mover cada documento individualmente para a nova subcoleção com o mesmo ID
    for (QueryDocumentSnapshot document in documents) {
      String docId = document.id; // ID do documento na subcoleção original
      Object? data = document.data(); // Dados do documento

      await destinationCollectionRef.doc(docId).set(data);
    }

    print('Documentos movidos com sucesso para as novas subcoleções.');
  }

  void moveCaixas() async {
    final String sourceCollection = 'hospitais';
    final String sourceDocumentId = 'Yo6n';
    final String sourceSubcollection = 'caixas';
    final String destinationSubcollection = 'caixas';
    String idDoc = id;
    print(idDoc);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(sourceCollection)
        .doc(sourceDocumentId)
        .collection(sourceSubcollection)
        .get();

    // Step 2: Mover os documentos para a nova subcoleção em 'hospitais'
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    CollectionReference destinationCollectionRef = FirebaseFirestore.instance
        .collection(sourceCollection)
        .doc(idDoc)
        .collection(destinationSubcollection);

    // Mover cada documento individualmente para a nova subcoleção com o mesmo ID
    for (QueryDocumentSnapshot document in documents) {
      String docId = document.id; // ID do documento na subcoleção original
      Object? data = document.data();
      if (data is Map<String, dynamic>) {
        data['disponibilidade'] = 1;
        await destinationCollectionRef.doc(docId).set(data);
      }
    }

    print('Documentos movidos com sucesso para as novas subcoleções.');
  }

  Future<void> salvarDadosCliente(
    User user,
    String nomeController,
    String emailController,
    String cnpjController,
  ) async {
    String nome = nomeController;
    String email = emailController;
    String cnpj = cnpjController;

    try {
      await db.collection("clientes").doc(id).set({
        'id': id,
        'nome': nome,
        'email': email,
        'cnpj': cnpj,
        'uid': user.uid,
        'hospital': 0,
        'tipoConta': 1,
      });

      // Atualize o displayName do usuário com o nome fornecido
      if (user != null) {
        await user.updateDisplayName(nome);
      }
    } catch (e) {
      // Lida com qualquer erro que possa ocorrer ao salvar os dados
      print('Erro ao salvar os dados: $e');
    }
  }
}
