import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';

class NewImovelList with ChangeNotifier {
  late final List<NewImovel> _items;

  NewImovelList() {
    _items = [];
    _carregarImoveis();
  }

  Future<void> _carregarImoveis() async {
   //updateImoveisWithDetalhes();
    final List<NewImovel> imoveis = await buscarImoveis();
    _items.addAll(imoveis);
    notifyListeners();
  }

  Future<void> updateImoveisWithDetalhes() async {
    print('teste');
    CollectionReference<Map<String, dynamic>> imoveisRef =
        FirebaseFirestore.instance.collection('um_por_imob');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await imoveisRef.get();

      // Itera sobre os documentos na coleção
      querySnapshot.docs.forEach((doc) async {
        Map<String, dynamic> data = doc.data();

        // Verifica se o campo detalhes está ausente ou nulo
        if ( data['localizacao']['endereco'] == {} ) {
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

  Future<List<NewImovel>> buscarImoveis() async {
    CollectionReference<Map<String, dynamic>> imoveisRef =
        FirebaseFirestore.instance.collection('um_por_imob');

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
            resultado['link_virtual_tour'] != null &&
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
          //print(imovel.caracteristicas);
          imoveis.add(imovel);
        }
      });

      return imoveis;
    } catch (e) {
      print('Erro ao buscar os imóveis: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  List<Map<String, dynamic>> _convertToListMap(dynamic value) {
    if (value is Iterable) {
      return List<Map<String, dynamic>>.from(value);
    } else {
      return [];
    }
  }

  Future<void> copiarDocumentos() async {
    final documentosCopiar = [
      'V1011-1073',
      'V1012-1073',
      'V1019-1073',
      'V1029-1073',
      'V1033-030c',
      'V1033-1073',
      'V1035-0b6f',
      'V1036-1073',
      'V1037-030c',
      'V1037-1073',
      'V1038-030c',
      'V1038-1073',
      'V1039-030c',
      'V1043-030c',
      'V1045-030c',
      'V1046-030c',
      'V1046-1073',
      'V1055-0b6f',
      'V1060-0b6f',
      'V1069-1073',
      'V1070-0b6f',
      'V1070-1073',
      'V1071-0b6f',
      'V1072-1073',
      'V1074-0b6f',
      'V1075-0b6f',
      'V1076-030c',
      'V1076-0b6f',
      'V1077-1073',
      'V1078-1073',
      'V1095-1073',
      'V1105-030c',
      'V1108-1073',
      'V1111-030c',
      'V1112-1073',
      'V1113-1073',
      'V1121-1073',
      'V1122-1073',
      'V1124-1073',
      'V1125-1073',
      'V1131-1073',
      'V1132-1073',
      'V1133-0b6f',
      'V1135-1073',
      'V1136-0b6f',
      'V1139-030c',
      'V1141-030c',
      'V1141-1073',
      'V1143-1073',
      'V1147-0b6f',
      'V115-0b6f',
      'V1152-1073',
      'V1153-1073',
      'V1156-1073',
      'V1157-1073',
      'V1168-1073',
      'V1170-1073',
      'V1171-0b6f',
      'V1172-1073',
      'V1174-1073',
      'V1177-030c',
      'V1181-030c',
      'V1181-1073',
      'V1187-1073',
      'V1188-0b6f',
      'V1188-1073',
      'V1189-030c',
      'V1190-1073',
    ];

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
      }
    } else {
      print('Usuário não autenticado.');
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

  List<NewImovel> get items => [..._items];

  void addProduct(NewImovel product) {
    _items.add(product);
    notifyListeners();
  }
}