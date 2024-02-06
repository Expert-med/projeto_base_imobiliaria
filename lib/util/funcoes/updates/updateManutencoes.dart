import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateManutencoes {
  Future<void>atualizarFeitoServicos(
    DocumentReference manutencaoDoc,
    bool? value,
    String idServico,
    int index,
  ) async {
    try {
      DocumentReference servicoDoc =
          manutencaoDoc.collection("servico").doc(idServico);

      DocumentSnapshot servicoSnapshot = await servicoDoc.get();

      Map<String, dynamic>? data =
          servicoSnapshot.data() as Map<String, dynamic>?;
      print('data: $data');

      if (servicoSnapshot.exists && data != null) {
        List<dynamic>? servicos = data['instrumentais'][index]['servicos'];
        print('lista de serviços desse servico: $servicos');

        if (servicos != null && index >= 0 && index < servicos.length) {
          // Cria uma cópia da lista antes de modificá-la
          List<dynamic> novaListaServicos = List.from(servicos);

          if (value == true) {
            novaListaServicos[index]['feito'] = 1;
          } else {
            novaListaServicos[index]['feito'] = 0;
          }

          // Atualiza o documento com a nova lista
          await servicoDoc.update({'instrumentais': data['instrumentais']});

          print('Valor atualizado com sucesso no Firebase Firestore!');
        } else {
          print('Índice inválido ou lista de serviços ausente.');
        }
      } else {
        print('Documento não encontrado ou lista de serviços ausente.');
      }
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

Future<void> atualizarInstrumentalConcluido(
    DocumentReference manutencaoDoc,
    bool? value,
    String idServico,
    int index,
  ) async {
    try {
      DocumentReference servicoDoc =
          manutencaoDoc.collection("servico").doc(idServico);

      DocumentSnapshot servicoSnapshot = await servicoDoc.get();

      if (servicoSnapshot.exists) {
        Map<String, dynamic>? data = servicoSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          List<dynamic>? servicos = data['instrumentais'];

          if (servicos != null && index >= 0 && index < servicos.length) {
            // Atualiza o valor 'concluido' do instrumental específico
            servicos[index]['concluido'] = value == true ? 1 : 0;

            // Atualiza o documento com a nova lista
            await servicoDoc.update({'instrumentais': servicos});

            print('Valor atualizado com sucesso no Firebase Firestore!');
          } else {
            print('Índice inválido ou lista de serviços ausente.');
          }
        } else {
          print('Dados do serviço nulos.');
        }
      } else {
        print('Documento do serviço não encontrado.');
      }
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
}


  

  Future<void> atualizarFinalizado(
      DocumentReference manutencaodoc, String idServico, bool? value) async {
    try {
      String idServ = idServico.toString(); // Obtém o ID da embalagem

      await manutencaodoc.collection("servico").doc(idServ).update({
        'finalizado': value == true ? 20 : 0,
      });
      atualizarTodosServicos(manutencaodoc, idServico);

      print('Valor atualizado no Firebase Firestore.');
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

  Future<void> atualizarTodosServicos(
    DocumentReference manutencaoDoc,
    String idServico,
  ) async {
    try {
      DocumentReference servicoDoc =
          manutencaoDoc.collection("servico").doc(idServico);

      DocumentSnapshot servicoSnapshot = await servicoDoc.get();

      Map<String, dynamic>? data =
          servicoSnapshot.data() as Map<String, dynamic>?;
      print('data: $data');

      if (servicoSnapshot.exists && data != null) {
        List<dynamic> novaListaInstrumentais = List.from(data['instrumentais']);

        for (int i = 0; i < novaListaInstrumentais.length; i++) {
          List<dynamic>? servicos = novaListaInstrumentais[i]['servicos'];

          if (servicos != null) {
            for (int j = 0; j < servicos.length; j++) {
              servicos[j]['feito'] = 1;
            }
          }
        }

        await servicoDoc.update({'instrumentais': novaListaInstrumentais});

        print('Valores atualizados com sucesso no Firebase Firestore!');
      } else {
        print('Documento não encontrado ou lista de instrumentais ausente.');
      }
    } catch (error) {
      print('Erro ao atualizar os valores no Firebase Firestore: $error');
    }
  }

  Future<void> atualizarEmAndamento(BuildContext context,
      DocumentReference manutencaoDoc, String idServico, bool? value) async {
    try {
      String idServ = idServico.toString(); // Obtém o ID da embalagem

      await manutencaoDoc
          .collection("servico")
          .doc(idServ)
          .update({'em_andamento': value == true ? 10 : 0});
      print('Valor atualizado no Firebase Firestore.');
      _exibirMensagem(context);
    } catch (error) {
      print('Erro ao atualizar o valor no Firebase Firestore: $error');
    }
  }

  void _exibirMensagem(BuildContext context) {
    final snackBar = SnackBar(
      content: Text("Serviço foi atualizado para 'em andamento'"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
