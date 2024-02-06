import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsertManutencao {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late DocumentReference manutencaodoc = db.collection("manutencao").doc("1");

  Future<int> obterUltimoIdServico() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await manutencaodoc
          .collection("servico")
          .orderBy("id", descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        int ultimoId = int.parse(snapshot.docs[0]["id"]);
        return ultimoId + 1;
      } else {
        return 10000; // Se a coleção estiver vazia, retorna 10000.
      }
    } catch (error) {
      print('Erro ao buscar o último ID: $error');
      throw error; // Propaga o erro para quem chamou a função.
    }
  }

  Future<void> inserirElemento(
      int index,
      List<Map<String, dynamic>> servicoController,
      Duration? _selectedDuration,
      int eHospital,
      String idCliente,
      List<Map<String, dynamic>> instrumentaisLista,
      String nomeCliente,
      String defeitoController,
      TextEditingController _observacoesController,
      TextEditingController _responsavelController,
      int isFabricacao,
      var _selectedDate,
      TextEditingController valorTotalController,
      String idServicoAntigo,
      Timestamp data_criacao_servico) async {
    int idServicoAtual = await obterUltimoIdServico();
    print('idServicoAtual $idServicoAtual');
    final DocumentReference colecaoRef =
        manutencaodoc.collection('servico').doc(idServicoAtual.toString());

    List<String> servicosIds =
        servicoController.map((servico) => servico['id'].toString()).toList();
    String formattedDuration = _selectedDuration != null
        ? '${_selectedDuration!.inHours}h ${(_selectedDuration!.inMinutes % 60)}min'
        : '';

    try {
      Map<String, dynamic> novaCaixa = {
        "id": idServicoAtual.toString(),
        'tipoCliente': eHospital,
        "cliente": idCliente,
        "instrumentais": [],
        "clienteNome": nomeCliente,
        "defeito": defeitoController,
        "observacoes": _observacoesController.text,
        "responsavel": _responsavelController.text,
        "reparo_Realizado": servicosIds,
        "fabricacao": isFabricacao,
        "data_reparo": _selectedDate != null
            ? _selectedDate
            : DateFormat('d/M/y').format(DateTime.now()),
        "tempo_servico": formattedDuration,
        "data_registro": data_criacao_servico,
        "valor": valorTotalController.text,
        "finalizado": 20,
        "em_andamento": 10,
        "concluido": 0,
        "lote": 1,
      };
      for (int i = 0; i < instrumentaisLista.length; i++) {
        if (i == index) {
          int quantidade = instrumentaisLista[i]['quantidade'] ??
              0; // Use 0 as default if quantidade is null
          String instrumentalNome = instrumentaisLista[i]['nome'];
          String instrumentaid = instrumentaisLista[i]['id'];
          int tipoId = instrumentaisLista[i]['tipo'] ?? 0;
          List<String> urlImagens = [];
          for (int j = 0; j < quantidade; j++) {
            Map<String, dynamic> novoInstrumental = {
              "id": instrumentaid,
              "nome": instrumentalNome,
              "tipo": tipoId,
              "servicos": instrumentaisLista[i]['servicos'],
              "imageUrl": urlImagens,
              "quantidade": 1,
              "concluido": instrumentaisLista[i]['concluido'] ?? 0
            };
            novaCaixa['instrumentais'].add(novoInstrumental);
          }
        }
      }

      manutencaodoc
          .collection("servico")
          .doc(idServicoAtual.toString())
          .set(novaCaixa)
          .then((_) {
        print("Nova caixa criada com sucesso");
        removerInstrumental(index, idServicoAntigo);
        inserirManutencaoCliente(
            idServicoAtual,
            eHospital,
            idCliente,
            servicoController,
            _selectedDuration,
            nomeCliente,
            _selectedDate,
            defeitoController,
            instrumentaisLista[index]['id'],
            _observacoesController.text.toString(),
            _responsavelController.text.toString(),
            valorTotalController.text.toString(),
            instrumentaisLista,
            index);
      }).catchError((error) {
        print("Erro ao criar nova caixa: $error");
      });

      print('Elemento inserido com sucesso na subcoleção "servico"');
    } catch (e) {
      print('Erro ao inserir elemento na subcoleção "servico": $e');
    }
  }

  Future<void> finalizarParaTodosConcluidos(

    List<Map<String, dynamic>> servicoController,
    Duration? _selectedDuration,
    int eHospital,
    String idCliente,
    List<Map<String, dynamic>> instrumentaisLista,
    String nomeCliente,
    String defeitoController,
    TextEditingController _observacoesController,
    TextEditingController _responsavelController,
    int isFabricacao,
    var _selectedDate,
    TextEditingController valorTotalController,
    String idServicoAntigo,
    Timestamp data_criacao_servico,
  ) async {
    int idServicoAtual = await obterUltimoIdServico();
    print('idServicoAtual $idServicoAtual');
    final DocumentReference colecaoRef =
        manutencaodoc.collection('servico').doc(idServicoAtual.toString());

    List<String> servicosIds =
        servicoController.map((servico) => servico['id'].toString()).toList();
    String formattedDuration = _selectedDuration != null
        ? '${_selectedDuration!.inHours}h ${(_selectedDuration!.inMinutes % 60)}min'
        : '';

    try {
      Map<String, dynamic> novaCaixa = {
        "id": idServicoAtual.toString(),
        'tipoCliente': eHospital,
        "cliente": idCliente,
        "instrumentais": [],
        "clienteNome": nomeCliente,
        "defeito": defeitoController,
        "observacoes": _observacoesController.text,
        "responsavel": _responsavelController.text,
        "reparo_Realizado": servicosIds,
        "fabricacao": isFabricacao,
        "data_reparo": _selectedDate != null
            ? _selectedDate
            : DateFormat('d/M/y').format(DateTime.now()),
        "tempo_servico": formattedDuration,
        "data_registro": data_criacao_servico,
        "valor": valorTotalController.text,
        "finalizado": 20,
        "em_andamento": 10,
        "concluido": 0,
        "lote": 1,
      };

      for (int i = 0; i < instrumentaisLista.length; i++) {
        int quantidade = instrumentaisLista[i]['quantidade'] ?? 0;
        String instrumentalNome = instrumentaisLista[i]['nome'];
        String instrumentaid = instrumentaisLista[i]['id'];
        int tipoId = instrumentaisLista[i]['tipo'] ?? 0;
        List<String> urlImagens = [];
        if (instrumentaisLista[i]['concluido'] == 1) {
          for (int j = 0; j < quantidade; j++) {
            Map<String, dynamic> novoInstrumental = {
              "id": instrumentaid,
              "nome": instrumentalNome,
              "tipo": tipoId,
              "servicos": instrumentaisLista[i]['servicos'],
              "imageUrl": urlImagens,
              "quantidade": 1,
              "concluido": instrumentaisLista[i]['concluido'] ?? 0
            };

            novaCaixa['instrumentais'].add(novoInstrumental);
          }
        }
      }

      manutencaodoc
          .collection("servico")
          .doc(idServicoAtual.toString())
          .set(novaCaixa)
          .then((_) {
        print("Nova caixa criada com sucesso");
        
        // inserirManutencaoCliente(
        //   idServicoAtual,
        //   eHospital,
        //   idCliente,
        //   servicoController,
        //   _selectedDuration,
        //   nomeCliente,
        //   _selectedDate,
        //   defeitoController,
        //   instrumentaisLista[index]['id'],
        //   _observacoesController.text.toString(),
        //   _responsavelController.text.toString(),
        //   valorTotalController.text.toString(),
        //   instrumentaisLista,
        //   index,
        // );
      }).catchError((error) {
        print("Erro ao criar nova caixa: $error");
      });

      print('Elemento inserido com sucesso na subcoleção "servico"');
    } catch (e) {
      print('Erro ao inserir elemento na subcoleção "servico": $e');
    }
  }

  Future<void> inserirElementosFinalizados(
      List<int> indices,
      List<Map<String, dynamic>> servicoController,
      Duration? _selectedDuration,
      int eHospital,
      String idCliente,
      List<Map<String, dynamic>> instrumentaisLista,
      String nomeCliente,
      String defeitoController,
      TextEditingController _observacoesController,
      TextEditingController _responsavelController,
      int isFabricacao,
      var _selectedDate,
      TextEditingController valorTotalController,
      String idServicoAntigo,
      Timestamp data_criacao_servico) async {
    int idServicoAtual = await obterUltimoIdServico();
    print('idServicoAtual $idServicoAtual');
    final DocumentReference colecaoRef =
        manutencaodoc.collection('servico').doc(idServicoAtual.toString());

    List<String> servicosIds =
        servicoController.map((servico) => servico['id'].toString()).toList();
    String formattedDuration = _selectedDuration != null
        ? '${_selectedDuration!.inHours}h ${(_selectedDuration!.inMinutes % 60)}min'
        : '';

    try {
      Map<String, dynamic> novaCaixa = {
        "id": idServicoAtual.toString(),
        'tipoCliente': eHospital,
        "cliente": idCliente,
        "instrumentais": [],
        "clienteNome": nomeCliente,
        "defeito": defeitoController,
        "observacoes": _observacoesController.text,
        "responsavel": _responsavelController.text,
        "reparo_Realizado": servicosIds,
        "fabricacao": isFabricacao,
        "data_reparo": _selectedDate != null
            ? _selectedDate
            : DateFormat('d/M/y').format(DateTime.now()),
        "tempo_servico": formattedDuration,
        "data_registro": data_criacao_servico,
        "valor": valorTotalController.text,
        "finalizado": 20,
        "em_andamento": 10,
        "concluido": 0,
        "lote": 1,
      };
      for (int i = 0; i < instrumentaisLista.length; i++) {
        if (indices.contains(i)) {
          int quantidade = instrumentaisLista[i]['quantidade'] ?? 0;
          String instrumentalNome = instrumentaisLista[i]['nome'];
          String instrumentaid = instrumentaisLista[i]['id'];
          int tipoId = instrumentaisLista[i]['tipo'] ?? 0;
          List<String> urlImagens = [];
          for (int j = 0; j < quantidade; j++) {
            Map<String, dynamic> novoInstrumental = {
              "id": instrumentaid,
              "nome": instrumentalNome,
              "tipo": tipoId,
              "servicos": instrumentaisLista[i]['servicos'],
              "imageUrl": urlImagens,
              "quantidade": 1,
            };
            novaCaixa['instrumentais'].add(novoInstrumental);
          }
        }
      }

      manutencaodoc
          .collection("servico")
          .doc(idServicoAtual.toString())
          .set(novaCaixa)
          .then((_) {
        print("Nova caixa criada com sucesso");
        for (int index in indices) {
          removerInstrumental(index, idServicoAntigo);
          inserirManutencaoCliente(
              idServicoAtual,
              eHospital,
              idCliente,
              servicoController,
              _selectedDuration,
              nomeCliente,
              _selectedDate,
              defeitoController,
              instrumentaisLista[index]['id'],
              _observacoesController.text.toString(),
              _responsavelController.text.toString(),
              valorTotalController.text.toString(),
              instrumentaisLista,
              index);
        }
      }).catchError((error) {
        print("Erro ao criar nova caixa: $error");
      });

      print('Elemento inserido com sucesso na subcoleção "servico"');
    } catch (e) {
      print('Erro ao inserir elemento na subcoleção "servico": $e');
    }
  }

  Future<void> removerInstrumental(int index, String idServico) async {
    print('$idServico - $index');
    try {
      DocumentSnapshot docSnapshot =
          await manutencaodoc.collection('servico').doc(idServico).get();

      if (docSnapshot.exists) {
        List<dynamic>? instrumentais = docSnapshot['instrumentais'];

        if (instrumentais != null &&
            index >= 0 &&
            index < instrumentais.length) {
          instrumentais.removeAt(index);

          await manutencaodoc
              .collection('servico')
              .doc(idServico)
              .update({'instrumentais': instrumentais});

          print('Instrumental removido do Firestore com sucesso');
        } else {
          print('Index out of bounds or instrumentais is null');
        }
      } else {
        print('Document with id $idServico does not exist');
      }
    } catch (e) {
      print('Erro ao remover instrumental do Firestore: $e');
    }
  }

  Future<void> inserirManutencaoCliente(
      int idManutencaoExpert,
      int eHospital,
      String idClienteController,
      List<Map<String, dynamic>> servicoController,
      Duration? _selectedDuration,
      String clienteController,
      var _selectedDate,
      String defeitoController,
      String instrumentalController,
      String observacoesController,
      String responsavelController,
      String valueController,
      List<Map<String, dynamic>> instrumentaisLista,
      int index) async {
    print('entro uem inserirManutencaoCliente');
    if (eHospital == 1) {
      CollectionReference hospitalCollection = db.collection("hospitais");
      QuerySnapshot querySnapshot = await hospitalCollection
          .where("id", isEqualTo: idClienteController)
          .get();

      try {
        List<DocumentSnapshot> clienteDocs = querySnapshot.docs;

        for (var clienteDoc in clienteDocs) {
          QuerySnapshot instrumentaisSnapshot =
              await clienteDoc.reference.collection("manutencoes").get();

          List<String> servicosIds = servicoController
              .map((servico) => servico['id'].toString())
              .toList();
          String formattedDuration = _selectedDuration != null
              ? '${_selectedDuration!.inHours}h ${(_selectedDuration!.inMinutes % 60)}min'
              : '';
          String idManutecaoAtual =
              await buscarUltimoIDECriarNovo(eHospital, idClienteController);
          print('idManutecaoAtual $idManutecaoAtual');
          try {
            Map<String, dynamic> novaCaixa = {
              "id_expert": idManutencaoExpert,
              "fabricacao": 0,
              "aceito": 1,
              "cliente": idClienteController,
              "clienteNome": clienteController,
              "concluido": 0,
              "data_registro": DateTime.now(),
              "data_reparo": _selectedDate,
              "defeito": defeitoController,
              "em_andamento": 0,
              "finalizado": 0,
              "id": idManutecaoAtual,
              "instrumentais": [],
              "lote": 1,
              "observacoes": observacoesController,
              "reparo_Realizado": servicosIds,
              "responsavel": responsavelController,
              "tempo_servico": formattedDuration,
              'tipoCliente': eHospital,
              "valor": valueController,
            };

            for (int i = 0; i < instrumentaisLista.length; i++) {
              if (i == index) {
                int quantidade = instrumentaisLista[i]['quantidade'] ??
                    0; // Use 0 as default if quantidade is null
                String instrumentalNome = instrumentaisLista[i]['nome'];
                String instrumentaid = instrumentaisLista[i]['id'];
                int tipoId = instrumentaisLista[i]['tipo'] ?? 0;
                List<String> urlImagens = [];
                for (int j = 0; j < quantidade; j++) {
                  Map<String, dynamic> novoInstrumental = {
                    "id": instrumentaid,
                    "nome": instrumentalNome,
                    "tipo": tipoId,
                    "servicos": instrumentaisLista[i]['servicos'],
                    "imageUrl": urlImagens,
                    "quantidade": 1,
                  };
                  novaCaixa['instrumentais'].add(novoInstrumental);
                }
              }
            }

            CollectionReference servicoCollection =
                clienteDoc.reference.collection("manutencoes");
            servicoCollection.doc(idManutecaoAtual).set(novaCaixa).then((_) {
              print("Nova caixa criada com sucesso");
              atualizarInstrumental(eHospital, idClienteController,
                  instrumentalController, idManutecaoAtual);
            }).catchError((error) {
              print("Erro ao criar nova caixa: $error");
            });

            print('Elemento inserido com sucesso na subcoleção "servico"');
          } catch (e) {
            print('Erro ao inserir elemento na subcoleção "servico": $e');
          }
        }
      } catch (e) {
        print('Erro ao buscar dados do cliente: $e');
      }
    } else {
      CollectionReference hospitalCollection = db.collection("clientes");
      QuerySnapshot querySnapshot = await hospitalCollection
          .where("id", isEqualTo: idClienteController)
          .get();

      try {
        List<DocumentSnapshot> clienteDocs = querySnapshot.docs;

        for (var clienteDoc in clienteDocs) {
          QuerySnapshot instrumentaisSnapshot =
              await clienteDoc.reference.collection("manutencoes").get();

          List<String> servicosIds = servicoController
              .map((servico) => servico['id'].toString())
              .toList();
          String formattedDuration = _selectedDuration != null
              ? '${_selectedDuration!.inHours}h ${(_selectedDuration!.inMinutes % 60)}min'
              : '';
          String idManutecaoAtual =
              await buscarUltimoIDECriarNovo(eHospital, idClienteController);
          print('idManutecaoAtual $idManutecaoAtual');
          try {
            Map<String, dynamic> novaCaixa = {
              "id_expert": idManutencaoExpert,
              "fabricacao": 0,
              "aceito": 1,
              "cliente": idClienteController,
              "clienteNome": clienteController,
              "concluido": 0,
              "data_registro": DateTime.now(),
              "data_reparo": _selectedDate,
              "defeito": defeitoController,
              "em_andamento": 0,
              "finalizado": 0,
              "id": idManutecaoAtual,
              "instrumentais": [],
              "lote": 1,
              "observacoes": observacoesController,
              "reparo_Realizado": servicosIds,
              "responsavel": responsavelController,
              "tempo_servico": formattedDuration,
              'tipoCliente': eHospital,
              "valor": valueController,
            };

            for (int i = 0; i < instrumentaisLista.length; i++) {
              if (i == index) {
                int quantidade = instrumentaisLista[i]['quantidade'] ??
                    0; // Use 0 as default if quantidade is null
                String instrumentalNome = instrumentaisLista[i]['nome'];
                String instrumentaid = instrumentaisLista[i]['id'];
                int tipoId = instrumentaisLista[i]['tipo'] ?? 0;
                List<String> urlImagens = [];
                for (int j = 0; j < quantidade; j++) {
                  Map<String, dynamic> novoInstrumental = {
                    "id": instrumentaid,
                    "nome": instrumentalNome,
                    "tipo": tipoId,
                    "servicos": instrumentaisLista[i]['servicos'],
                    "imageUrl": urlImagens,
                    "quantidade": 1,
                  };
                  novaCaixa['instrumentais'].add(novoInstrumental);
                }
              }
            }

            CollectionReference servicoCollection =
                clienteDoc.reference.collection("manutencoes");
            servicoCollection.doc(idManutecaoAtual).set(novaCaixa).then((_) {
              print("Nova caixa criada com sucesso");

              atualizarInstrumental(eHospital, idClienteController,
                  instrumentalController, idManutecaoAtual);
            }).catchError((error) {
              print("Erro ao criar nova caixa: $error");
            });

            print('Elemento inserido com sucesso na subcoleção "servico"');
          } catch (e) {
            print('Erro ao inserir elemento na subcoleção "servico": $e');
          }
        }
      } catch (e) {
        print('Erro ao buscar dados do cliente: $e');
      }
    }
  }

  Future<void> atualizarInstrumental(int eHospital, String idClienteController,
      String instrumentalController, String idServicoAtual) async {
    if (eHospital == 1) {
      CollectionReference hospitalCollection = db.collection("hospitais");
      QuerySnapshot querySnapshot = await hospitalCollection
          .where("id", isEqualTo: idClienteController)
          .get();

      try {
        List<DocumentSnapshot> clienteDocs = querySnapshot.docs;

        for (var clienteDoc in clienteDocs) {
          try {
            print('atualizarInstrumental');

            final DocumentReference instrumentalRef =
                clienteDoc.reference.collection("instrumentais").doc(
                      instrumentalController,
                    );

            // Verifica se o documento existe antes de tentar atualizá-lo
            final documentSnapshot = await instrumentalRef.get();
            if (documentSnapshot.exists) {
              await instrumentalRef.update({
                "manutencoes": FieldValue.arrayUnion([idServicoAtual]),
              });
              print('Elemento inserido com sucesso na subcoleção "servico"');
            } else {
              print('O documento não existe: $instrumentalController,');
            }

            String idClicado = instrumentalController.substring(0, 8);
            print(idClicado);
            print(
              instrumentalController,
            );
            final DocumentReference colecaoRef = clienteDoc.reference
                .collection('instrumentais')
                .doc(idClicado)
                .collection('especificos')
                .doc(
                  instrumentalController,
                );
            print('colecaoRef');
            final especificoDocumentSnapshot = await colecaoRef.get();
            if (especificoDocumentSnapshot.exists) {
              await colecaoRef.update({
                "manutencoes": FieldValue.arrayUnion([idServicoAtual]),
              });
              print(
                  'Elemento inserido com sucesso na subcoleção "especificos"');
            } else {
              print(
                  'O documento não existe na subcoleção "especificos": ${instrumentalController},');
            }
          } catch (e) {
            print('Erro ao atualizar documento: $e');
          }
        }
      } catch (e) {
        print('Erro ao buscar dados do cliente: $e');
      }
    } else {
      CollectionReference hospitalCollection = db.collection("clientes");
      QuerySnapshot querySnapshot = await hospitalCollection
          .where("id", isEqualTo: idClienteController)
          .get();

      try {
        List<DocumentSnapshot> clienteDocs = querySnapshot.docs;

        for (var clienteDoc in clienteDocs) {
          try {
            final DocumentReference instrumentalRef =
                clienteDoc.reference.collection("instrumentais").doc(
                      instrumentalController,
                    );

            // Verifica se o documento existe antes de tentar atualizá-lo
            final documentSnapshot = await instrumentalRef.get();
            if (documentSnapshot.exists) {
              await instrumentalRef.update({
                "manutencoes": FieldValue.arrayUnion([idServicoAtual]),
              });
              print('Elemento inserido com sucesso na subcoleção "servico"');
            } else {
              print('O documento não existe: $instrumentalController,');
            }

            String idClicado = instrumentalController.substring(0, 8);

            final DocumentReference colecaoRef = clienteDoc.reference
                .collection('instrumentais')
                .doc(idClicado)
                .collection('especificos')
                .doc(
                  instrumentalController,
                );

            final especificoDocumentSnapshot = await colecaoRef.get();
            if (especificoDocumentSnapshot.exists) {
              await colecaoRef.update({
                "manutencoes": FieldValue.arrayUnion([idServicoAtual]),
              });
              print(
                  'Elemento inserido com sucesso na subcoleção "especificos"');
            } else {
              print(
                  'O documento não existe na subcoleção "especificos": $instrumentalController,');
            }
          } catch (e) {
            print('Erro ao atualizar documento: $e');
          }
        }
      } catch (e) {
        print('Erro ao buscar dados do cliente: $e');
      }
    }
  }

  Future<String> buscarUltimoIDECriarNovo(
      int eHospital, String idClienteController) async {
    if (eHospital == 1) {
      try {
        CollectionReference hospitalCollection = db.collection("hospitais");
        QuerySnapshot querySnapshot = await hospitalCollection
            .where("id", isEqualTo: idClienteController)
            .get();

        List<DocumentSnapshot> clienteDocs = querySnapshot.docs;

        for (var clienteDoc in clienteDocs) {
          Query instrumentaisQuery = clienteDoc.reference
              .collection("manutencoes")
              .orderBy("id", descending: true)
              .limit(1);

          QuerySnapshot querySnapshot = await instrumentaisQuery.get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot ultimoDocumento = querySnapshot.docs.first;
            String ultimoID =
                (ultimoDocumento.data() as Map<String, dynamic>?)?["id"] ?? "";

            int ultimoIDNumero = int.tryParse(ultimoID) ?? 0;
            int novoIDNumero = ultimoIDNumero + 1;
            String novoID = novoIDNumero.toString();
            return novoID;
          } else {
            return "1"; // Se não houver documentos na coleção, comece com "0001"
          }
        }
      } catch (error) {
        print("Erro ao buscar o último ID: $error");
      }
    } else {
      try {
        CollectionReference hospitalCollection = db.collection("clientes");
        QuerySnapshot querySnapshot = await hospitalCollection
            .where("id", isEqualTo: idClienteController)
            .get();

        List<DocumentSnapshot> clienteDocs = querySnapshot.docs;

        for (var clienteDoc in clienteDocs) {
          Query instrumentaisQuery = clienteDoc.reference
              .collection("manutencoes")
              .orderBy("id", descending: true)
              .limit(1);

          QuerySnapshot querySnapshot = await instrumentaisQuery.get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot ultimoDocumento = querySnapshot.docs.first;
            String ultimoID =
                (ultimoDocumento.data() as Map<String, dynamic>?)?["id"] ?? "";

            int ultimoIDNumero = int.tryParse(ultimoID) ?? 0;
            int novoIDNumero = ultimoIDNumero + 1;
            String novoID = novoIDNumero.toString();
            return novoID;
          } else {
            return "1"; // Se não houver documentos na coleção, comece com "0001"
          }
        }
      } catch (error) {
        print("Erro ao buscar o último ID: $error");
      }
    }

    return ""; // Retorno padrão vazio caso a condição não seja atendida
  }
}
