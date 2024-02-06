

import 'package:cloud_firestore/cloud_firestore.dart';

class updateCMEBanco{

  void atualizarDisponibilidadeCaixa(DocumentReference hospitalDoc, int idCaixa, int idEmbalagemMaisRecente) async {
    try {
      String idCaixaAtual =  idCaixa.toString();

      await hospitalDoc.collection("caixas").doc(idCaixaAtual).update(
        {'disponibilidade': 0, 'ultimaEmb': idEmbalagemMaisRecente},
      );
      print('Valor atualizado no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

  void atualizarDisponibilidadeCaixaMedicamento(DocumentReference hospitalDoc, int idCaixa, int idEmbalagemMaisRecente) async {
    try {
      String idCaixaAtual =  idCaixa.toString();

      await hospitalDoc.collection("caixas_medicamentos").doc(idCaixaAtual).update(
        {'disponibilidade': 0, 'ultimaEmb': idEmbalagemMaisRecente},
      );
      print('Valor atualizado no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

   void atualizarDisponibilidadeCaixaTerceiros(DocumentReference hospitalDoc, int idCaixa, int idEmbalagemMaisRecente) async {
    try {
      String idCaixaAtual = idCaixa.toString();

      await hospitalDoc
          .collection("tercerizados_caixas")
          .doc(idCaixaAtual)
          .update(
        {'disponibilidade': 0, 'ultimaEmb': idEmbalagemMaisRecente},
      );
      print('Valor atualizado no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }
 
 
  void atualizarEstoqueDosInstrumentais(DocumentReference hospitalDoc,List<dynamic> instrumentaisList) async {
    Map<String, int> contagemRepeticoes = {};
    print(instrumentaisList);
    for (var instrumental in instrumentaisList) {
      if (instrumental != null) {
        var id = instrumental['id'];

        if (contagemRepeticoes.containsKey(id)) {
          contagemRepeticoes[id] = contagemRepeticoes[id]! + 1;
        } else {
          contagemRepeticoes[id] = 1;
        }
      }
    }

    for (var instrumental in instrumentaisList) {
      if (instrumental != null) {
        var id = instrumental['id'];

        int repeticoes = contagemRepeticoes[id] ?? 0;

        if (instrumental['especifico'] == 0) {
          print('estoque == 0');
          int estoqueAtual = instrumental['estoque'];
          int emUsoAtual = instrumental['em_uso'];
          int novoEstoque = estoqueAtual - repeticoes;
          int novoUso = emUsoAtual + repeticoes;

          await hospitalDoc
              .collection("instrumentais")
              .doc(id)
              .update({'estoque': novoEstoque, 'em_uso': novoUso}).then((_) {
            print('Estoque do instrumental com ID $id atualizado com sucesso.');
          }).catchError((error) {
            print(
                'Erro ao atualizar o estoque do instrumental com ID $id: $error');
          });
        } else if (instrumental['especifico'] == 1) {
          print('estoque != 0');
          String idClicado = id.substring(0, 8);
          final DocumentReference instrumentalRef =
              hospitalDoc.collection('instrumentais').doc(idClicado);

          final DocumentReference colecaoRef =
              instrumentalRef.collection('especificos').doc(id);
          print(id);
          int tipo;

          int emUsoAtual = instrumental['em_uso'];
          int novoUso = emUsoAtual + 1;

          try {
            await colecaoRef.update({
              "id": id,
              "em_uso": 1,
              "especifico": 1,
              "nome": instrumental['nome'],
              "imageURL": instrumental['imageURL'],
              "observacao": instrumental['observacao'],
              "tipo": instrumental['tipo'],
            });
          } catch (e) {
            print('Error parsing tipo: $e');
            return;
          }
          print(' o id instruAtual é $id');

          await hospitalDoc.collection("instrumentais").doc(idClicado).update({
            'em_uso': FieldValue.increment(1),
            'estoque': FieldValue.increment(-1)
          }).then((_) {
            print('Estoque do instrumental com ID $id atualizado com sucesso.');
          }).catchError((error) {
            print(
                'Erro ao atualizar o estoque do instrumental com ID $id: $error');
          });
        }
      }
    }
  }

}