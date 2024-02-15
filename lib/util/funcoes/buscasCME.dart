import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class buscasCME {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<String>> buscarImagensCaixa(
      DocumentReference hospitalDoc, int id) async {
    try {
      final snapshot = await hospitalDoc
          .collection("caixas")
          .where("id", isEqualTo: id)
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final caixaDoc = snapshot.docs[0];

        if (caixaDoc.exists) {
          final caixaData = caixaDoc.data() as Map<String, dynamic>;

          if (caixaData.containsKey('imagesURL') &&
              caixaData['imagesURL'] != null) {
            final urlImagens = List<String>.from(caixaData['imagesURL']);

            return urlImagens;
          } else {
            print("A lista de imagens da caixa $id está vazia.");
          }
        } else {
          print("A caixa com o ID fornecido não existe.");
        }
      } else {
        print("Nenhuma caixa encontrada com o ID fornecido.");
      }
    } catch (error) {
      print('Erro ao buscar imagens da caixa hospitalDoc $id: $error');
    }

    return []; // Retorna uma lista vazia se ocorrer um erro ou não encontrar imagens.
  }

  Future<List<Map<String, dynamic>>> buscarCaixasPorId(
      DocumentReference hospitalDoc, int id) async {
    try {
      final QuerySnapshot snapshot = await hospitalDoc
          .collection("caixas")
          .where('id', isEqualTo: id, isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> caixaAtual = snapshot.docs
            .map((caixaAtual) => caixaAtual.data() as Map<String, dynamic>)
            .toList();

        return caixaAtual;
      } else {
        print("Não foram encontradas caixas no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as caixas: $error');
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> buscarCaixasDisponiveis(
      DocumentReference hospitalDoc) async {
    try {
      QuerySnapshot snapshot = await hospitalDoc
          .collection("caixas")
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> caixaAtual = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .where((caixa) => caixa['id'] > 0)
            .where((caixa) => caixa['disponibilidade'] == 1)
            .toList();

        return caixaAtual; // Retorna a lista de caixas encontradas.
      } else {
        print("Não foram encontradas caixas no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as caixas: $error');
    }

    return []; // Retorna uma lista vazia se ocorrer um erro ou não encontrar caixas.
  }

  Future<List<Map<String, dynamic>>> buscarCaixasDisponiveisTerceiros(
    DocumentReference hospitalDoc,
  ) async {
    try {
      final QuerySnapshot snapshot = await hospitalDoc
          .collection("tercerizados_caixas")
          .where("disponibilidade", isEqualTo: 1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> material = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .toList();

        // Ordena a lista de materiais com base em algum critério, se necessário.
        material.sort((a, b) {
          final int idA = int.tryParse(a['id'].toString()) ?? 0;
          final int idB = int.tryParse(b['id'].toString()) ?? 0;
          return idA.compareTo(idB);
        });

        return material;
      } else {
        print("Não foram encontradas caixas no banco de dados.");
        return [];
      }
    } catch (error) {
      print('Erro ao buscar as caixas: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> buscarCaixasMedicamentosDisponiveis(
      DocumentReference hospitalDoc) async {
    try {
      QuerySnapshot snapshot = await hospitalDoc
          .collection("caixas_medicamentos")
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> caixaAtual = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .where((caixa) => caixa['id'] > 0)
            .where((caixa) => caixa['disponibilidade'] == 1)
            .toList();

        return caixaAtual;
      } else {
        print("Não foram encontradas caixas no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as caixas: $error');
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> buscarTodasCaixas(
      DocumentReference hospitalDoc, int id) async {
    try {
      final QuerySnapshot snapshot = await hospitalDoc
          .collection("caixas")
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> caixaAtual = snapshot.docs
            .map((caixaAtual) => caixaAtual.data() as Map<String, dynamic>)
            .toList();

        return caixaAtual;
      } else {
        print("Não foram encontradas caixas no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as caixas: $error');
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> buscarEmbalagensPeloIdCaixa(
      DocumentReference hospitalDoc, int idCaixa) async {
    List<Map<String, dynamic>> embalagens = [];
    try {
      QuerySnapshot snapshot = await hospitalDoc
          .collection("embalagem")
          .where('idCaixa', isEqualTo: idCaixa)
          .get();

      if (snapshot.docs.isNotEmpty) {
        embalagens = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .toList();
        embalagens.sort((a, b) {
          final int idA = a['id'] as int? ?? 0;
          final int idB = b['id'] as int? ?? 0;
          return idA.compareTo(idB);
        });

        return embalagens;
      } else {
        print("Não foram encontradas embalagens no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as embalagens: $error');
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> buscarTodasAsCaixas(
      DocumentReference hospitalDoc) async {
    try {
      QuerySnapshot snapshot = await hospitalDoc
          .collection("caixas")
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> caixas = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .toList();

        return caixas; // Retorna a lista de caixas encontradas.
      } else {
        print("Não foram encontradas caixas no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as caixas: $error');
    }

    return []; // Retorna uma lista vazia se ocorrer um erro ou não encontrar caixas.
  }

  Future<int> buscarProximoIdCaixa(DocumentReference hospitalDoc) async {
    try {
      QuerySnapshot snapshot = await hospitalDoc
          .collection("caixas")
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        int ultimoId = snapshot.docs[0]["id"] ?? 0;
        int proximoId = ultimoId + 1;
        return proximoId;
      } else {
        // Se não houver caixas no banco de dados, comece com o ID 1.
        return 1;
      }
    } catch (error) {
      print('Erro ao buscar o próximo ID da caixa: $error');
      throw error; // Você pode tratar o erro conforme necessário.
    }
  }

  Future<List<Map<String, dynamic>>> buscarTodasEmbalagens(
      DocumentReference hospitalDoc) async {
    List<Map<String, dynamic>> embalagens = [];
    try {
      QuerySnapshot snapshot = await hospitalDoc
          .collection("embalagem")
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        embalagens = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .toList();
        embalagens.sort((a, b) {
          final int idA = a['id'] as int? ?? 0;
          final int idB = b['id'] as int? ?? 0;
          return idA.compareTo(idB);
        });

        return embalagens;
      } else {
        print("Não foram encontradas embalagens no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as embalagens: $error');
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> buscarUltimas5EmbalagensFinalizadas(
      DocumentReference hospitalDoc) async {
    List<Map<String, dynamic>> embalagens = [];
    try {
      QuerySnapshot snapshot = await hospitalDoc
          .collection("embalagem")
          .where('finalizado', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        embalagens = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .toList();
        embalagens.sort((a, b) {
          final int idB = a['id'] as int? ?? 0;
          final int idA = b['id'] as int? ?? 0;
          return idA.compareTo(idB);
        });

        return embalagens;
      } else {
        print("Não foram encontradas embalagens no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as embalagens: $error');
    }

    return [];
  }

  Future<Map<String, dynamic>> buscarInstrumentaisHospital(
    DocumentReference hospitalDoc,
    int idCaixa,
  ) async {
    try {
      QuerySnapshot snapshot = await hospitalDoc
          .collection("caixas")
          .where("id", isEqualTo: idCaixa)
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot caixaDoc = snapshot.docs[0];

        if (caixaDoc.exists) {
          Map<String, dynamic> caixaData =
              caixaDoc.data() as Map<String, dynamic>;

          if (caixaData.containsKey('instrumentais') &&
              caixaData['instrumentais'] != null) {
            return caixaData;
          } else {
            print("A lista de instrumentos da caixa $idCaixa está vazia.");
          }
        } else {
          print("A caixa com o ID fornecido não existe.");
        }
      } else {
        print("Nenhuma caixa encontrada com o ID fornecido.");
      }
    } catch (error) {
      print(
          'Erro ao buscar instrumentos da caixa hospitalDoc $idCaixa: $error');
    }

    // Retorna um mapa vazio em caso de erro ou não encontrar a caixa.
    return {};
  }

  Future<Map<String, dynamic>> buscarInstrumentaisCliente(
    DocumentReference clienteDoc,
    int idCaixa,
  ) async {
    try {
      QuerySnapshot snapshot = await clienteDoc
          .collection("caixas")
          .where("id", isEqualTo: idCaixa)
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot caixaDoc = snapshot.docs[0];

        if (caixaDoc.exists) {
          Map<String, dynamic> caixaData =
              caixaDoc.data() as Map<String, dynamic>;

          if (caixaData.containsKey('instrumentais') &&
              caixaData['instrumentais'] != null) {
            return caixaData;
          } else {
            print("A lista de instrumentos da caixa $idCaixa está vazia.");
          }
        } else {
          print("A caixa com o ID fornecido não existe.");
        }
      } else {
        print("Nenhuma caixa encontrada com o ID fornecido.");
      }
    } catch (error) {
      print(
          'Erro ao buscar instrumentos da caixa hospitalDoc $idCaixa: $error');
    }

    // Retorna um mapa vazio em caso de erro ou não encontrar a caixa.
    return {};
  }

  Future<Map<String, dynamic>> buscarCaixaEmb(
      DocumentReference hospitalDoc, int idCaixa, int idEmbalagem) async {
    if (idCaixa != 0) {
      final snapshot = await hospitalDoc
          .collection("caixas")
          .where("id", isEqualTo: idCaixa)
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final document = snapshot.docs[0];
        if (document.exists) {
          final data = document.data();
          if (data != null &&
              data is Map<String, dynamic> &&
              data.containsKey('instrumentais')) {
            final List<dynamic> instrumentais = document.get('instrumentais');
            return data as Map<String, dynamic>;
          } else {
            print(
                "O campo 'instrumentais' não existe no documento: ${document.id}");
          }
        } else {
          print("Documento não encontrado: ${document.id}");
        }
      } else {
        print(
            "Não foram encontrados tipos de instrumentais no banco de dados.");
      }
    } else {
      final snapshot = await hospitalDoc
          .collection("embalagem")
          .where("id", isEqualTo: idEmbalagem)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final document = snapshot.docs[0];
        if (document.exists) {
          final data = document.data();
          if (data != null &&
              data is Map<String, dynamic> &&
              data.containsKey('instrumentais')) {
            final List<dynamic> instrumentaisData =
                document.get('instrumentais');
            final List<dynamic> instrumentos = [];
            for (var instrumento in instrumentaisData) {
              instrumentos.add(instrumento['id']);
            }
            return data as Map<String, dynamic>;
          } else {
            print("O campo 'instrumentais' não existe no documento: ");
          }
        } else {
          print("Documento não encontrado: ${document.id}");
        }
      } else {
        print(
            "Não foram encontrados tipos de instrumentais no banco de dados.");
      }
    }

    // Retorna um mapa vazio em caso de erro ou não encontrar os dados.
    return {};
  }

  Future<Map<String, dynamic>?> buscarInstrumentalSubcolecao(
      DocumentReference hospitalDoc, String id) async {
    String modifiedId = id.length > 4 ? id.substring(0, 8) : id;

    final snapshot = await hospitalDoc
        .collection('instrumentais')
        .where('id', isEqualTo: modifiedId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final instrumentalSnapshot = snapshot.docs.first;
      final colecaoRef =
          instrumentalSnapshot.reference.collection('especificos');

      final subcolecaoSnapshot = await colecaoRef.get();

      if (subcolecaoSnapshot.docs.isNotEmpty) {
        for (final doc in subcolecaoSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>?;

          if (data != null && data['id'] == id) {
            return data; // Retorna o data se o instrumental for encontrado
          }
        }
      } else {
        print('Coleção especifico não encontrada');
      }
    } else {
      print('Instrumental com ID $id não encontrado');
    }

    return null; // Retorna null se o instrumental não for encontrado
  }

  Future<List<Map<String, dynamic>>> buscarTodosHospitais() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('hospitais').get();

      List<Map<String, dynamic>> hospitais = querySnapshot.docs
          .map<Map<String, dynamic>>(
              (doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return hospitais;
    } catch (error) {
      print('Erro ao buscar os hospitais: $error');
      throw error; // Você pode optar por lançar o erro para que o chamador da função possa lidar com ele.
    }
  }

  Future<List<Map<String, dynamic>>> buscarTodosClientes() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('clientes').get();

      List<Map<String, dynamic>> clientes = querySnapshot.docs
          .map<Map<String, dynamic>>(
              (doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return clientes;
    } catch (error) {
      print('Erro ao buscar os hospitais: $error');
      throw error; // Você pode optar por lançar o erro para que o chamador da função possa lidar com ele.
    }
  }

  Future<List<Map<String, dynamic>>> buscarTodosImoveis() async {
    List<Map<String, dynamic>> filteredInstrumentais = [];

    QuerySnapshot snapshot = await db.collection("imoveis").get();

    if (snapshot.docs.isNotEmpty) {
      filteredInstrumentais = snapshot.docs.map((doc) {
        Map<String, dynamic> instrumentalData =
            doc.data() as Map<String, dynamic>;
        return instrumentalData;
      }).toList();
    }

    return filteredInstrumentais;
  }

  Future<List<Map<String, dynamic>>> buscarTodosInstrumentais(
      DocumentReference userDoc, int eHospital) async {
    List<Map<String, dynamic>> filteredInstrumentais = [];

    if (eHospital == 1) {
      QuerySnapshot snapshot = await userDoc.collection("instrumentais").get();

      if (snapshot.docs.isNotEmpty) {
        filteredInstrumentais = snapshot.docs.map((doc) {
          Map<String, dynamic> instrumentalData =
              doc.data() as Map<String, dynamic>;
          return instrumentalData;
        }).toList();
      }
    } else {
      QuerySnapshot snapshot = await userDoc.collection("instrumentais").get();

      if (snapshot.docs.isNotEmpty) {
        filteredInstrumentais = snapshot.docs.map((doc) {
          Map<String, dynamic> instrumentalData =
              doc.data() as Map<String, dynamic>;
          return instrumentalData;
        }).toList();
      }
    }

    return filteredInstrumentais;
  }

  Future<List<Map<String, dynamic>>> buscarTiposInstrumentos(
      DocumentReference hospitalDoc) async {
    try {
      QuerySnapshot? querySnapshot = await hospitalDoc
          .collection('tipo_instrumental')
          .where('id', isNotEqualTo: 0)
          .get();

      if (querySnapshot != null) {
        List<Map<String, dynamic>> tipo = querySnapshot.docs
            .map<Map<String, dynamic>>(
                (doc) => doc.data() as Map<String, dynamic>)
            .toList();
        return tipo;
      } else {
        print('QuerySnapshot is null.');
        return []; // Return an empty list in case of no data.
      }
    } catch (error) {
      print('Erro ao buscar os tipos de instrumentos: $error');
      return []; // Return an empty list on error.
    }
  }

  Future<List<Map<String, dynamic>>> buscarLocaisArmazenamento(
      DocumentReference hospitalDoc) async {
    try {
      QuerySnapshot? querySnapshot = await hospitalDoc
          .collection('locais_armazenamento')
          .where('id', isNotEqualTo: 0)
          .get();

      if (querySnapshot != null) {
        List<Map<String, dynamic>> tipo = querySnapshot.docs
            .map<Map<String, dynamic>>(
                (doc) => doc.data() as Map<String, dynamic>)
            .toList();
        return tipo;
      } else {
        print('QuerySnapshot is null.');
        return []; // Return an empty list in case of no data.
      }
    } catch (error) {
      print('Erro ao buscar os tipos de instrumentos: $error');
      return []; // Return an empty list on error.
    }
  }

  Future<Map<String, dynamic>> buscarTipoInstrumental(
      DocumentReference userDoc, int idTipo) async {
    try {
      final QuerySnapshot snapshot = await userDoc
          .collection("tipo_instrumental")
          .where('id', isEqualTo: idTipo, isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final tipoInstru = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .toList();

        final Map<String, dynamic> tipoInstrumental = tipoInstru.isNotEmpty
            ? tipoInstru[0] as Map<String, dynamic>
            : Map<String, dynamic>();

        return tipoInstrumental;
      } else {
        print("Não foram encontradas tipoInstru no banco de dados.");
        return Map<String, dynamic>();
      }
    } catch (error) {
      print('Erro ao buscar as tipoInstru: $error');
      return Map<String, dynamic>();
    }
  }

  Future<List<Map<String, dynamic>>> buscarEmbalagemRetorno(
      DocumentReference userDoc) async {
    try {
      final QuerySnapshot snapshot = await userDoc
          .collection("embalagem")
          .where('cirurgia', isEqualTo: 30)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> embalagens = snapshot.docs
            .map((emb) => emb.data() as Map<String, dynamic>)
            .toList();

        List<Map<String, dynamic>> embFinal =
            embalagens.where((emb) => emb['idCaixa'] > 0).toList();

        return embFinal;
      } else {
        print("Não foram encontradas embalagens no banco de dados.");
        return [];
      }
    } catch (error) {
      print('Erro ao buscar as embalagens: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> buscarEmbalagemMedicamentoRetorno(
      DocumentReference userDoc) async {
    try {
      final QuerySnapshot snapshot = await userDoc
          .collection("embalagem")
          .where('cirurgia', isEqualTo: 30)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> embalagens = snapshot.docs
            .map((emb) => emb.data() as Map<String, dynamic>)
            .toList();

        List<Map<String, dynamic>> embFinal =
            embalagens.where((emb) => emb['tipoCaixa'] == 1).toList();

        return embFinal;
      } else {
        print("Não foram encontradas embalagens no banco de dados.");
        return [];
      }
    } catch (error) {
      print('Erro ao buscar as embalagens: $error');
      return [];
    }
  }

  Future<QueryDocumentSnapshot?> buscarFornecedor(
      DocumentReference userDoc, int idCaixa) async {
    try {
      print('Fornecedor $idCaixa');
      final QuerySnapshot snapshot = await userDoc
          .collection("tercerizados_caixas")
          .where("id", isEqualTo: idCaixa)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[0];
      } else {
        print("A caixa com o ID fornecido não existe.");
        return null;
      }
    } catch (error) {
      print('Erro ao buscar instrumentos da caixa $idCaixa: $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> buscarInstrumentaisPorCaixa(
      DocumentReference userDoc, int idCaixa) async {
    List<Map<String, dynamic>> filteredInstrumentais = [];

    QuerySnapshot snapshot = await userDoc
        .collection("caixas")
        .where("id", isEqualTo: idCaixa)
        .get();

    if (snapshot.docs.isNotEmpty) {
      filteredInstrumentais = snapshot.docs.map((doc) {
        Map<String, dynamic> instrumentalData =
            doc.data() as Map<String, dynamic>;
        return instrumentalData;
      }).toList();
    }

    return filteredInstrumentais;
  }

  Future<Map<String, dynamic>> buscarDadosEmbalagemPorId(
      DocumentReference hospitalDoc, int idEmbalagem) async {
    try {
      final snapshot = await hospitalDoc
          .collection("embalagem")
          .where('id', isNotEqualTo: 0)
          .where("id", isEqualTo: idEmbalagem)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final embalagemData = snapshot.docs[0].data() as Map<String, dynamic>;
        return embalagemData;
      } else {
        print("Não foram encontradas caixas no banco de dados.");
        return {};
      }
    } catch (error) {
      print('Erro ao buscar as embalagens: $error');
      return {};
    }
  }

  Future<DocumentSnapshot?> buscarInstrumentosTercerizados(
    DocumentReference hospitalDoc,
    int idCaixa,
  ) async {
    try {
      final QuerySnapshot snapshot = await hospitalDoc
          .collection("tercerizados_caixas")
          .where("id", isEqualTo: idCaixa)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[0];
      } else {
        print("A caixa com o ID fornecido não existe.");
        return null;
      }
    } catch (error) {
      print('Erro ao buscar instrumentos da caixa $idCaixa: $error');
      return null;
    }
  }

  Future<int> fetchImagePathsSize(
      DocumentReference hospitalDoc, String idInstru) async {
    try {
      final DocumentSnapshot snapshot =
          await hospitalDoc.collection("instrumentais").doc(idInstru).get();

      if (snapshot.exists) {
        List<dynamic> imageUrls = snapshot['imageURL'];
        int imageCount = imageUrls.length;
        return imageCount;
      } else {
        print("Instrumental with ID ${idInstru} not found.");
        return 0; // Ou qualquer outro valor padrão que você preferir
      }
    } catch (error) {
      print('Error fetching image paths: $error');
      return 0; // Ou qualquer outro valor padrão que você preferir
    }
  }

  Future<int> fetchImagePathsSizeCaixas(
      DocumentReference hospitalDoc, int idCaixa) async {
    try {
      final DocumentSnapshot snapshot =
          await hospitalDoc.collection("caixas").doc(idCaixa.toString()).get();

      if (snapshot.exists) {
        List<dynamic> imageUrls = snapshot['imagesURL'];
        int imageCount = imageUrls.length;

        return imageCount;
      } else {
        print("Instrumental with ID ${idCaixa} not found.");
        return 0; // Ou qualquer outro valor padrão que você preferir
      }
    } catch (error) {
      print('Error fetching image paths: $error');
      return 0; // Ou qualquer outro valor padrão que você preferir
    }
  }

  Future<List<Map<String, dynamic>>> buscarDadosInstrumentais(
      DocumentReference hospitalDoc, String idInstru) async {
    try {
      final QuerySnapshot snapshot = await hospitalDoc
          .collection("instrumentais")
          .where("id", isEqualTo: idInstru)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> caixas = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .toList();

        if (caixas.isNotEmpty) {
          return caixas;
        } else {
          print("A lista de caixas está vazia.");
          return []; // Ou qualquer outro valor padrão que você preferir
        }
      } else {
        print("Não foram encontradas caixas no banco de dados");
        return []; // Ou qualquer outro valor padrão que você preferir
      }
    } catch (error) {
      print('Erro ao buscar os instrumentais: $error');
      return []; // Ou qualquer outro valor padrão que você preferir
    }
  }

  List<Map<String, dynamic>> buscarUltimos7Dias(
      List<Map<String, dynamic>> embalagens, String dataAtual) {
    final partesDataAtual = dataAtual.split('/');
    if (partesDataAtual.length != 3) {
      return [];
    }

    final diaAtual = int.tryParse(partesDataAtual[0]);
    final mesAtual = int.tryParse(partesDataAtual[1]);
    final anoAtual = int.tryParse(partesDataAtual[2]);

    if (diaAtual == null || mesAtual == null || anoAtual == null) {
      return [];
    }

    final dataAtualObj = DateTime(anoAtual, mesAtual, diaAtual);

    final seteDiasAtras = dataAtualObj.subtract(Duration(days: 7));

    List<Map<String, dynamic>> embalagensultimos = [];

    for (final embalagem in embalagens) {
      final infoAdicionais = embalagem['infoAdicionais'];
      if (infoAdicionais != null) {
        final dataEmbStr = infoAdicionais['dataAtual'];

        final partesData = dataEmbStr.split('/');
        if (partesData.length != 3) {
          continue;
        }

        final dia = int.tryParse(partesData[0]);
        final mes = int.tryParse(partesData[1]);
        final ano = int.tryParse(partesData[2]);

        if (dia == null || mes == null || ano == null) {
          continue;
        }

        try {
          final dataEmbObj = DateTime(ano, mes, dia);

          if (dataEmbObj.isAfter(seteDiasAtras) &&
                  dataEmbObj.isBefore(dataAtualObj) ||
              dataEmbObj.isAtSameMomentAs(dataAtualObj)) {
            embalagensultimos.add(embalagem);
          }
        } catch (e) {}
      }
    }

    return embalagensultimos;
  }

  Future<String> buscaLogo(String idConta) async {
    final ref = firebase_storage.FirebaseStorage.instance
        .ref('logos/logo-$idConta.jpeg');
    final url = await ref.getDownloadURL();
    return url;
  }

  List<Map<String, dynamic>> caixas = [];
  Future<void> buscarTipo(DocumentReference hospitalDoc) async {
    try {
      QuerySnapshot snapshot = await hospitalDoc
          .collection("tipo_instrumental")
          .where('id', isNotEqualTo: 0)
          .get();

      if (snapshot.docs.isNotEmpty) {
        caixas = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .toList();
      } else {
        print("Não foram encontradas caixas no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as caixas: $error');
    }
  }

  List<Map<String, dynamic>> getCaixas() {
    return caixas;
  }

  Future<List<Map<String, dynamic>>> buscarMeusUsuarios(
      DocumentReference hospitalDoc) async {
    List<Map<String, dynamic>> embalagens = [];
    try {
      QuerySnapshot snapshot = await hospitalDoc.collection("usuarios").get();

      if (snapshot.docs.isNotEmpty) {
        embalagens = snapshot.docs
            .map((caixa) => caixa.data() as Map<String, dynamic>)
            .toList();
        embalagens.sort((a, b) {
          final String idA = a['uid'] as String? ?? '';
          final String idB = b['uid'] as String? ?? '';
          return idA.compareTo(idB);
        });

        return embalagens;
      } else {
        print("Não foram encontradas embalagens no banco de dados.");
      }
    } catch (error) {
      print('Erro ao buscar as embalagens: $error');
    }

    return [];
  }

  Future<void> inserirUsuario(
    BuildContext context,
    DocumentReference hospitalDoc,
    String idHospital,
    String _nomeController,
    String _uid,
    String idCliente,
  ) async {
    print('entrou');

    DocumentReference clienteDoc;
    final DocumentReference instrumentalRef =
        hospitalDoc.collection('usuarios').doc(_uid);

    // Increment the last ID by 1 to get the new ID
    try {
      await instrumentalRef.set({
        "nome": _nomeController,
        "id": idCliente,
        "uid": _uid,
        "tipo_usuario": 2,
      });

      clienteDoc = db.collection("clientes").doc(idCliente);

// Obtenha o documento do cliente para obter a lista atual de hospitais
      DocumentSnapshot clienteSnapshot = await clienteDoc.get();
      Map<String, dynamic> clienteData =
          clienteSnapshot.data() as Map<String, dynamic>? ?? {};
      List<dynamic> idHospitais =
          clienteData["id_hospital"] as List<dynamic>? ?? [];

// Supondo que hospitalDoc seja do tipo DocumentReference
      idHospitais.add(idHospital);

// Atualize o documento do cliente com a nova lista de hospitais
      await clienteDoc.update({
        "id_hospital": idHospitais,
      });

      print('Elemento inserido com sucesso na subcoleção "especifico"');
    } catch (e) {
      print('Erro ao inserir elemento na subcoleção "especifico": $e');
    }
  }

  Future<void> removerUsuario(
    BuildContext context,
    DocumentReference hospitalDoc,
    String idHospital,
    String _uid,
    String idCliente,
  ) async {
    print('entrou');

    DocumentReference clienteDoc = db.collection("clientes").doc(idCliente);
    print(idHospital);
    print(_uid);
    try {
      await clienteDoc.update({
        "id_hospital": FieldValue.arrayRemove([idHospital]),
      });
      await hospitalDoc.collection('usuarios').doc(_uid).delete();

      print('Elemento removido com sucesso');
    } catch (e) {
      print('Erro ao remover elemento: $e');
    }
  }

  Future<void> inserirIDTemporario(
    BuildContext context,
    String idHospital,
    String idCliente,
  ) async {
    print('entrou');

    try {
      DocumentReference clienteDoc = db.collection("clientes").doc(idCliente);
      DocumentSnapshot clienteSnapshot = await clienteDoc.get();
      Map<String, dynamic> clienteData =
          clienteSnapshot.data() as Map<String, dynamic>? ?? {};

      await clienteDoc.update({
        "valida": 1,
        "id_temp": idHospital,
      });

      print('Elemento inserido com sucesso na subcoleção "especifico"');
    } catch (e) {
      print('Erro ao inserir elemento na subcoleção "especifico": $e');
    }
  }

  Future<void> removerIdTemporario(
    BuildContext context,
    String idCliente,
  ) async {
    print('entrou');

    try {
      DocumentReference clienteDoc = db.collection("clientes").doc(idCliente);
      DocumentSnapshot clienteSnapshot = await clienteDoc.get();
      Map<String, dynamic> clienteData =
          clienteSnapshot.data() as Map<String, dynamic>? ?? {};

      await clienteDoc.update({
        "valida": 0,
        "id_temp": '',
      });

      print('Elemento inserido com sucesso na subcoleção "especifico"');
    } catch (e) {
      print('Erro ao inserir elemento na subcoleção "especifico": $e');
    }
  }
}
