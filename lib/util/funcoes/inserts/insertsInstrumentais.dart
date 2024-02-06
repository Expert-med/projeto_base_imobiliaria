import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InsertInstrumentais {
  Future<void> inserirInstruEspecifico(
      BuildContext context,
      DocumentReference hospitalDoc,
      String idInstruAtual,
      String idEspecifico,
      TextEditingController _nomeController,
      TextEditingController _tipoControllerAux,
      List<String> _imagePaths,
      TextEditingController _observacoesController) async {
    final DocumentReference instrumentalRef =
        hospitalDoc.collection('instrumentais').doc(idInstruAtual);

    final DocumentReference colecaoRef = instrumentalRef
        .collection('especificos')
        .doc('${idInstruAtual}${idEspecifico}');
    print(idInstruAtual);
    int tipo;

    try {
      tipo = int.parse(_tipoControllerAux.text);
    } catch (e) {
      print('Error parsing tipo: $e');
      return;
    }

    print(' o id instruAtual é $idInstruAtual');
    updateInstrumentalValues(hospitalDoc, idInstruAtual, context);
    try {
      await colecaoRef.set({
        "id": '${idInstruAtual}${idEspecifico}',
        "nome": _nomeController.text,
        "tipo": tipo,
        "estoque": 1,
        "em_uso": 0,
        "imageURL": _imagePaths,
        "especifico": 1,
        "observacao": _observacoesController.text,
      });

      print('Elemento inserido com sucesso na subcoleção "especifico"');
    } catch (e) {
      print('Erro ao inserir elemento na subcoleção "especifico": $e');
    }
  }

  Future<void> updateInstrumentalValues(DocumentReference hospitalDoc,
      String idInstrumental, BuildContext context) async {
    print('entrou em updateInstrumentalValues');
    print(idInstrumental);
    try {
      final DocumentReference instrumentalRef =
          hospitalDoc.collection('instrumentais').doc(idInstrumental);

      final DocumentSnapshot instrumentalSnapshot = await instrumentalRef.get();

      int estoqueInstru = instrumentalSnapshot['estoque'] ?? 0;
      int emUso = instrumentalSnapshot['em_uso'] ?? 0;
      int total = instrumentalSnapshot['total'] ?? 0;
      int qtd = instrumentalSnapshot['quantidade'] ?? 0;
      int qtdEspecifico = instrumentalSnapshot['qtdEspecifico'] ?? 0;

      if (emUso >= 0 && emUso <= qtd - estoqueInstru) {
        await instrumentalRef.update({
          'estoque': estoqueInstru + 1,
          'total': total + 1,
          'quantidade': qtd + 1,
          'qtdEspecifico': qtdEspecifico + 1,
        });
      } else {
        print('Instrumental with ID  $idInstrumental found.');
      }
    } catch (error) {
      print('Error updating value');
    }
  }

  Future<String> cadastrarInstrumentalCliente(
      DocumentReference clienteDoc,
      String idInstruAtual,
      TextEditingController _nomeController,
      List<String> _imagePaths,
      TextEditingController _observacoesController) async {
    print(clienteDoc);
    Map<String, dynamic> instrumentalData = {
      "id": idInstruAtual,
      "nome": _nomeController.text,
      "imageURL": _imagePaths,
      "especifico": 0,
      'qtdEspecifico': 0,
      "quantidade": 1,
      "total": 1,
      "estoque": 1,
      "em_uso": 0,
      "uso": 1,
      "observacao": _observacoesController.text,
    };

    DocumentReference documentRef =
        clienteDoc.collection("instrumentais").doc(idInstruAtual);

    await documentRef.set(instrumentalData).catchError((error) {
      print('Erro ao adicionar dados: $error');
    });

    DocumentReference especificoRef =
        clienteDoc.collection('especifico').doc(idInstruAtual);
    await especificoRef.set({}).catchError((error) {
      print('Erro ao adicionar dados à subcoleção "especifico": $error');
    });

    return idInstruAtual;
  }

  Future<String> cadastrarInstrumentalHospital(
    DocumentReference hospitalDoc,
    String idInstruAtual,
    TextEditingController _nomeController,
    List<String> _imagePaths,
    TextEditingController _observacoesController,
    TextEditingController _tipoControllerAux,
    TextEditingController _qtdController,
  ) async {
    print('hospital doc: $hospitalDoc');
    int tipo = int.parse(_tipoControllerAux.text);
    if (idInstruAtual != null && idInstruAtual.isNotEmpty) {
      Map<String, dynamic> instrumentalData = {
        "id": idInstruAtual,
        "nome": _nomeController.text,
        "tipo": tipo,
        "imageURL": _imagePaths,
        "especifico": 0,
        'qtdEspecifico': 0,
        "quantidade": int.parse(_qtdController.text),
        "total": int.parse(_qtdController.text),
        "estoque": int.parse(_qtdController.text),
        "em_uso": 0,
        "observacao": _observacoesController.text,
      };
      print(instrumentalData);
      hospitalDoc
          .collection("instrumentais")
          .doc(idInstruAtual)
          .set(instrumentalData)
          .then((_) {
        print(
            "Nova caixa criada com sucesso $idInstruAtual + ${hospitalDoc.id}");
      }).catchError((error) {
        print("Erro ao criar nova caixa: $error");
      });
    } else {
      print('id vazuo $idInstruAtual');
    }

    // DocumentReference especificoRef =
    //     hospitalDoc.collection('especificos').doc(idInstruAtual);
    // await especificoRef.set({}).catchError((error) {
    //   print('Erro ao adicionar dados à subcoleção "especifico": $error');
    // });

    return idInstruAtual;
  }
}
