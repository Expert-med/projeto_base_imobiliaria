import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';

import '../../core/models/imovel_form_data.dart';

class NewImovelList with ChangeNotifier {
  late final List<NewImovel> _items;
  late String nome;

  NewImovelList() {
    _items = [];
    nome = '';
    carregarImoveis(nome);
  }

  Future<void> carregarImoveis(String nome) async {
    print("nome");
    print(nome);
    if (nome == "") {
      final List<NewImovel> imoveis = await buscarImoveis();
      _items.addAll(imoveis);
      notifyListeners();
    } else {
      final List<NewImovel> imoveis = await buscarImoveisLanding(nome);
      _items.addAll(imoveis);
      notifyListeners();
    }
  }

  Future<void> updateImoveisWithDetalhes() async {
    print('updateImoveisWithDetalhes');
    CollectionReference<Map<String, dynamic>> imoveisRef =
        FirebaseFirestore.instance.collection('imoveis');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await imoveisRef.get();

      // Itera sobre os documentos na coleção
      querySnapshot.docs.forEach((doc) async {
        Map<String, dynamic> data = doc.data();
        print('entrou no try');
        // Verifica se o campo detalhes está ausente ou nulo
        if (data['endereco'] == null || !data.containsKey('detalhes')) {
          print('finalidade == 0');
          // Atualiza o documento para adicionar um campo detalhes vazio
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot<Map<String, dynamic>> freshDoc =
                await transaction.get(doc.reference);
            Map<String, dynamic> newData = freshDoc.data() ?? {};
            newData['detalhes'] = {
              "descricao": 'N/A',
              "area_total": 'N/A',
              'area_privativa': 'N/A',
              'dormitorios': 'N/A',
              'banheiros': 'N/A',
              'perfil': 'N/A',
              'vagas_garagem': 'N/A',
              'mobilia': 'N/A',
              'niveis': 'N/A',
              'uso_comercial': 'N/A',
            };
            newData['atualizacoes'] = {
              'data': 'N/A',
              'status': -1,
              'valor': 'N/A',
            };
            newData['caracteristicas'] = {};
            newData['curtidas'] = 'N/A';
            newData['data_cadastro'] = 'N/A';
            newData['finalidade'] = -1;
            newData['id_imovel'] = 'N/A';
            newData['imagens'] = [];
            newData['link_virtual_tour'] = '';
            newData['localizacao'] = {
              "endereco": {
                'logradouro': 'N/A',
                'complemento': 'N/A',
                'bairro': 'N/A',
                'cidade': 'N/A',
                'estado': 'N/A',
                'cep': 'N/A',
              },
              "latitude": 'N/A',
              "longitude": 'N/A',
            };
            newData['preco'] = {
              'preco_promoocional': 'N/A',
              'preco_original': 'N/A',
            };
            newData['tipo'] = -1;
            transaction.update(doc.reference, newData);
          });

          print('Documento atualizado com detalhes vazio: ${doc.id}');
        }
      });

      print('Atualização concluída.');
    } catch (e) {
      print('Erro ao atualizar os documentos: $e');
    }
  }

  List<NewImovel> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

 Future<List<NewImovel>> buscarImoveisLanding(String nome) async {
  try {
    final store = FirebaseFirestore.instance;
    final querySnapshot = await store
        .collection('corretores')
        .where('name', isEqualTo: nome)
        .get();

    final docId = querySnapshot.docs[0].id;

    DocumentReference userRef = store.collection('corretores').doc(docId);

    CollectionReference<Map<String, dynamic>> imoveisRef = userRef.collection('imoveis');

    final querySnapshotImoveis = await imoveisRef.get();

    List<NewImovel> imoveis = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshotImoveis.docs) {
      final resultado = doc.data();

      // Verifique se o resultado possui todos os campos necessários
      if (resultado.containsKey('codigo_imovel') &&
          resultado.containsKey('data') &&
          resultado.containsKey('link') &&
          resultado.containsKey('codigo_imobiliaria') &&
          resultado.containsKey('curtidas') &&
          resultado.containsKey('data_cadastro') &&
          resultado.containsKey('finalidade') &&
          resultado.containsKey('imagens') &&
          resultado.containsKey('tipo')) {
        final caracteristicas = _convertToListMap(resultado['caracteristicas']);
        final atualizacoes = _convertToListMap(resultado['atualizacoes']);
        final localizacao = _convertToListMap(resultado['localizacao']);

        final imovel = NewImovel(
          id: resultado['codigo_imovel'] ?? '',
          data: resultado['data'] ?? '',
          detalhes: resultado['detalhes'] != null ? Map<String, dynamic>.from(resultado['detalhes']) : {},
          link_imovel: resultado['link'] ?? '',
          link_virtual_tour: resultado['link_virtual_tour'] ?? '',
          caracteristicas: resultado['caracteristicas'] ?? '',
          atualizacoes: resultado['atualizacoes'] ?? '',
          codigo_imobiliaria: resultado['codigo_imobiliaria'] ?? '',
          curtidas: resultado['curtidas'] ?? '',
          data_cadastro: resultado['data_cadastro'] ?? '',
          finalidade: resultado['finalidade'] ?? 0,
          imagens: List<String>.from(resultado['imagens'] ?? []),
          localizacao: resultado['localizacao'] ?? {},
          preco: resultado['preco'] ?? '',
          tipo: resultado['tipo'] ?? 0,
        );

        imoveis.add(imovel);
      }
    }

    return imoveis;
  } catch (e) {
    print('Erro ao buscar os imóveis: $e');
    return []; // Retorna uma lista vazia em caso de erro
  }
}


 Future<NewImovel?> buscarImoveisLandingPorId(String nome, String idImovel) async {
  print("nome $nome, id $idImovel");
  final store = FirebaseFirestore.instance;
  final querySnapshot = await store
      .collection('corretores')
      .where('name', isEqualTo: nome)
      .get();

  final docId = querySnapshot.docs[0].id;

  DocumentReference userRef = store.collection('corretores').doc(docId);

  CollectionReference<Map<String, dynamic>> imoveisRef = userRef.collection('imoveis');
  print('encontrou o corretor e imoveis');
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await imoveisRef.where('codigo_imovel', isEqualTo: idImovel).get();
    print('query object, imóvel encontrado com o código');
    NewImovel? imovelEncontrado;
    print('criou imovelEncontrado');
    
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
      final resultado = doc.data();
      print('resultado $resultado');
      // Verifique se o resultado possui todos os campos necessários
      if (resultado.containsKey('codigo_imovel') &&
          resultado.containsKey('data') &&
          resultado.containsKey('link') &&
          resultado.containsKey('codigo_imobiliaria') &&
          resultado.containsKey('curtidas') &&
          resultado.containsKey('data_cadastro') &&
          resultado.containsKey('finalidade') &&
          resultado.containsKey('imagens') &&
          resultado.containsKey('tipo')) {
        final caracteristicas = _convertToListMap(resultado['caracteristicas']);
        final atualizacoes = _convertToListMap(resultado['atualizacoes']);
        final localizacao = _convertToListMap(resultado['localizacao']);

        imovelEncontrado = NewImovel(
          id: resultado['codigo_imovel'] ?? '',
          data: resultado['data'] ?? '',
          detalhes: resultado['detalhes'] != null ? Map<String, dynamic>.from(resultado['detalhes']) : {},
          link_imovel: resultado['link'] ?? '',
          link_virtual_tour: resultado['link_virtual_tour'] ?? '',
          caracteristicas: resultado['caracteristicas'] ?? '',
          atualizacoes: resultado['atualizacoes'] ?? '',
          codigo_imobiliaria: resultado['codigo_imobiliaria'] ?? '',
          curtidas: resultado['curtidas'] ?? '',
          data_cadastro: resultado['data_cadastro'] ?? '',
          finalidade: resultado['finalidade'] ?? 0,
          imagens: List<String>.from(resultado['imagens'] ?? []),
          localizacao: resultado['localizacao'] ?? {},
          preco: resultado['preco'] ?? '',
          tipo: resultado['tipo'] ?? 0,
        );
        break; // Interrompe o loop após encontrar o imóvel
      }
    }

    return imovelEncontrado;
  } catch (e) {
    print('Erro ao buscar o imóvel: $e');
    return null; // Retorna null em caso de erro
  }
}


  Future<List<NewImovel>> buscarImoveis() async {
    final store = FirebaseFirestore.instance;
    final User = FirebaseAuth.instance.currentUser;
    final corretorId = User?.uid ?? '';
    final querySnapshot = await store
        .collection('corretores')
        .where('uid', isEqualTo: corretorId)
        .get();

    final docId = querySnapshot.docs[0].id;

    DocumentReference userRef = store.collection('corretores').doc(docId);

    CollectionReference<Map<String, dynamic>> imoveisRef =
        userRef.collection('imoveis');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await imoveisRef.get();

      List<NewImovel> imoveis = [];

      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final resultado = doc.data();
        final infoList = resultado['detalhes'] ?? <String, dynamic>{};

        if (resultado['codigo_imovel'] != null &&
            resultado['data'] != null &&
            resultado['link'] != null &&
            resultado['codigo_imobiliaria'] != null &&
            resultado['curtidas'] != null &&
            resultado['data_cadastro'] != null &&
            resultado['finalidade'] != null &&
            resultado['imagens'] != null &&
            resultado['tipo'] != null) {
          // Convert each field to the correct type
          final caracteristicas =
              _convertToListMap(resultado['caracteristicas']);
          final atualizacoes = _convertToListMap(resultado['atualizacoes']);
          final localizacao = _convertToListMap(resultado['localizacao']);

          final imovel = NewImovel(
            id: resultado['codigo_imovel'] ?? '',
            data: resultado['data'] ?? '',
            detalhes: resultado['detalhes'] != null
                ? Map<String, dynamic>.from(resultado['detalhes'])
                : {},
            link_imovel: resultado['link'] ??
                '', // Provide a default value if 'link' is null
            link_virtual_tour: resultado['link_virtual_tour'] ?? '',
            caracteristicas: resultado['caracteristicas'] ?? '',
            atualizacoes: resultado['atualizacoes'] ?? '',
            codigo_imobiliaria: resultado['codigo_imobiliaria'] ?? '',
            curtidas: resultado['curtidas'] ?? '',
            data_cadastro: resultado['data_cadastro'] ?? '',
            finalidade: resultado['finalidade'] ?? 0,
            imagens: List<String>.from(resultado['imagens'] ?? []),
            localizacao: resultado['localizacao'] ?? {},
            preco: resultado['preco'] ?? '',
            tipo: resultado['tipo'] ?? 0,
          );

          _items.add(imovel);
          salvarImoveisFavoritos(_items);
          notifyListeners();
        }
      });

      return imoveis;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

 Future<List<String>> fetchImoveisFavoritos() async {
  User? user = FirebaseAuth.instance.currentUser;
  List<String> imoveisFavoritos = [];

  if (user != null) {
    try {
      print('Buscando clientes');
      final snapshot = await FirebaseFirestore.instance
          .collection('clientes')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        imoveisFavoritos =
            List<String>.from(snapshot.docs.first['imoveis_favoritos']);
        return imoveisFavoritos; // Retorna os dados dos clientes
      }
    } catch (error) {
      print('Erro ao buscar informações do cliente: $error');
    }

    try {
      print('Buscando corretores');
      final snapshot = await FirebaseFirestore.instance
          .collection('corretores')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        imoveisFavoritos =
            List<String>.from(snapshot.docs.first['imoveis_favoritos']);
        return imoveisFavoritos; // Retorna os dados dos corretores
      }
    } catch (error) {
      print('Erro ao buscar informações do corretor: $error');
    }
  } else {
    print('Usuário não está logado.');
  }

  // Retorna uma lista vazia se nenhum dado for encontrado
  return imoveisFavoritos;
}



  List<Map<String, dynamic>> _convertToListMap(dynamic value) {
    if (value is Iterable) {
      return List<Map<String, dynamic>>.from(value);
    } else {
      return [];
    }
  }

  Future<void> copiarDocumentos() async {
    final documentosCopiar = [];

    try {
      final CollectionReference<Map<String, dynamic>> imoveisRef =
          FirebaseFirestore.instance.collection('imoveis_teste');
      final CollectionReference<Map<String, dynamic>> imoveisFinalRef =
          FirebaseFirestore.instance.collection('imoveis_final_teste');

      for (final documento in documentosCopiar) {
        final snapshot = await imoveisRef.doc(documento).get();
        if (snapshot.exists) {
          await imoveisFinalRef.doc(documento).set(snapshot.data()!);
          print(
              'Documento $documento copiado para imoveis_final_teste com sucesso.');
        } else {
          print('Documento $documento não encontrado em imoveis_teste.');
        }
      }

      print('Todos os documentos foram copiados com sucesso.');
    } catch (e) {
      print('Erro ao copiar os documentos: $e');
    }
  }

Future<void> salvarImoveisFavoritos(List<NewImovel> imoveis) async {
  final user = FirebaseAuth.instance.currentUser;
  final email = user?.email;

  if (email != null) {
    final clientesRef = FirebaseFirestore.instance.collection('clientes');
    final querySnapshot =
        await clientesRef.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      final List<dynamic> imoveisFavoritos = userData['imoveis_favoritos'];

      List<String> listaImoveisString = [];

      for (var imovel in imoveisFavoritos) {
        listaImoveisString.add(imovel.toString());
      }
      print('listaImoveisString $listaImoveisString');
      // Agora você tem todos os imóveis favoritos do usuário como strings
      // na lista listaImoveisString. Você pode fazer o que quiser com ela.
      marcarImoveisFavoritos(imoveis, listaImoveisString);
    } else {
      print('Usuário não encontrado na coleção "clientes"');
      // Se o usuário não for encontrado na coleção "clientes", busque na coleção "corretores"
      await _buscarImoveisFavoritosCorretor(user, imoveis);
    }
  } else {
    // Se o usuário não estiver logado, busque na coleção "corretores"
    await _buscarImoveisFavoritosCorretor(user, imoveis);
  }
}

Future<void> _buscarImoveisFavoritosCorretor(
    User? user, List<NewImovel> imoveis) async {
  final corretoresRef =
      FirebaseFirestore.instance.collection('corretores');
  final querySnapshot =
      await corretoresRef.where('uid', isEqualTo: user?.uid).get();

  if (querySnapshot.docs.isNotEmpty) {
    final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
    final List<dynamic> imoveisFavoritos = userData['imoveis_favoritos'];

    List<String> listaImoveisString = [];

    for (var imovel in imoveisFavoritos) {
      listaImoveisString.add(imovel.toString());
    }
    print('listaImoveisString $listaImoveisString');
    // Agora você tem todos os imóveis favoritos do usuário como strings
    // na lista listaImoveisString. Você pode fazer o que quiser com ela.
    marcarImoveisFavoritos(imoveis, listaImoveisString);
  } else {
    print('Usuário não encontrado na coleção "corretores"');
  }
}


  Future<void> marcarImoveisFavoritos(
      List<NewImovel> imoveis, List<String> imoveisFavoritos) async {
    print('marcarImoveisFavoritos');
    print(imoveisFavoritos);
    for (int i = 0; i < imoveis.length; i++) {
      bool encontrado = false;
      for (int j = 0; j < imoveisFavoritos.length; j++) {
        if (imoveis[i].id == imoveisFavoritos[j]) {
          encontrado = true;
          break; // Se encontrado, não é necessário continuar o loop
        }
      }
      imoveis[i].isFavorite = encontrado;
    }
  }

  void cadastrarImovel(
      dynamic user, ImovelFormData _formData, String codigo_imovel) async {
    try {
      String data_atual_formatada =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final store = FirebaseFirestore.instance;
      final User = FirebaseAuth.instance.currentUser;
      final corretorId = user?.uid ?? '';
      final querySnapshot = await store
          .collection('corretores')
          .where('uid', isEqualTo: corretorId)
          .get();

      final docId = querySnapshot.docs[0].id;

      DocumentReference userRef = store.collection('corretores').doc(docId);

      DocumentReference docRef =
          userRef.collection('imoveis').doc(codigo_imovel);

      Map<String, dynamic> data = {
        'atualizacoes': {
          'data': data_atual_formatada,
          'status': 1,
          'valor': _formData.precoOriginal ?? 0,
        },
        'caracteristicas': _formData.caracteristicasDoImovel ?? {},
        'codigo_imobiliaria': user.id,
        'codigo_imovel': codigo_imovel,
        'curtidas': 'N/A',
        'data': data_atual_formatada ?? '',
        'data_cadastro': data_atual_formatada ?? '',
        'detalhes': {
          'area_privativa': _formData.areaPrivativa ?? '',
          'area_privativa_casa': _formData.areaPrivativaCasa ?? '',
          'area_total': _formData.areaTotal ?? '',
          'mobilia': _formData.mobilia ?? '',
          'nome_imovel': _formData.nomeImovel ?? '',
          'terreno': _formData.terreno ?? '',
          'total_dormitorios': _formData.totalDormitorios ?? '',
          'total_suites': _formData.totalSuites ?? '',
          'vagas_garagem': _formData.totalGaragem ?? 0,
        },
        'finalidade': 0,
        'id_imovel': codigo_imovel,
        'imagens': _formData.imageUrls ?? [],
        'link': '',
        'localizacao': {
          'latitude': _formData.latitude ?? '',
          'longitude': _formData.longitude ?? '',
          'endereco': {
            'logradouro': _formData.localizacao!.split(',')[0] ?? '',
            'complemento': 'N/A',
            'bairro': _formData.localizacao!.split(',')[1].split('-')[0] ?? '',
            'cidade': _formData.localizacao!.split('-')[1].split("/")[0] ?? '',
            'estado': _formData.localizacao!.split('/')[1].split("+")[0] ?? '',
            'cep': _formData.localizacao!.split('+')[1] ?? '',
          },
        },
        'preco': {
          'preco_original': _formData.precoOriginal,
          'preco_promocional': '',
        },
        'tipo': 0,
      };

      await docRef.set(data);
      Map<String, dynamic> localizacao =
          Map<String, dynamic>.from(data['localizacao']);
      Map<String, dynamic> caracteristicas =
          Map<String, dynamic>.from(data['caracteristicas']);
      Map<String, dynamic> detalhes =
          Map<String, dynamic>.from(data['detalhes']);
      Map<String, dynamic> preco = Map<String, dynamic>.from(data['preco']);
      List<String> imagens = List<String>.from(data['imagens']);

      NewImovel newImovel = NewImovel(
        id: codigo_imovel,
        detalhes: detalhes,
        caracteristicas: caracteristicas,
        localizacao: localizacao,
        preco: preco,
        link_imovel: data['link'],
        link_virtual_tour: '',
        codigo_imobiliaria: user.id,
        data_cadastro: data_atual_formatada,
        data: data_atual_formatada,
        imagens: imagens,
        curtidas: 'N/A',
        finalidade: data['finalidade'],
        tipo: data['tipo'],
        atualizacoes: data['atualizacoes'],
      );

      _items.add(newImovel);
      notifyListeners();
      print('Imóvel cadastrado com sucesso!');
    } catch (error) {
      print('Erro ao cadastrar o imóvel: $error');
    }
  }

  void addProduct(NewImovel product) {
    _items.add(product);
    notifyListeners();
    carregarImoveis(nome);
  }

  List<NewImovel> get items => [..._items];
}
