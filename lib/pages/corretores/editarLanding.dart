import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/corretor/corretor_item.dart';

import '../../components/landingPage/beneficio.dart';
import '../../components/landingPage/footer.dart';
import '../../components/landingPage/landingAppBar.dart';
import '../../components/landingPage/navegacao.dart';
import '../../components/landingPage/perguntas.dart';
import '../../components/landingPage/porque.dart';
import '../../components/landingPage/solucao.dart';
import '../../components/landingPage/titulo.dart';

class EditarLandingPage extends StatefulWidget {
  @override
  _EditarLandingPageState createState() => _EditarLandingPageState();
}

class _EditarLandingPageState extends State<EditarLandingPage> {
  Map<String, dynamic> variaveis = {};
  String cor = '';

  String logo = '';
  String link1 = '';
  String link2 = '';
  String link3 = '';
  String link4 = '';
  String botao1 = '';
  String botao2 = '';

  String titulo_1  = '';
  String subtitulo_1  = '';
  String texto_botao_1 = '';
  String texto_1 = '';
  String link_imagem = '';

  String tag = '';
  String titulo_beneficio_0 = '';
  String subtitulo_beneficio_0 = '';
  String lista_beneficio_0_1 = '';
  String lista_beneficio_0_2 = '';
  String lista_beneficio_0_3 = '';
  String texto_botao_2 = '';
  String link_imagem_2 = '';
  String tag_2 = '';
  String titulo_beneficio_1 = '';
  String subtitulo_beneficio_1 = '';
  String lista_beneficio_1_1 = '';
  String lista_beneficio_1_2 = '';
  String lista_beneficio_1_3 = '';
  String texto_botao_3 = '';
  String link_imagem_3 = '';
  String titulo_solucao1 = '';
  String sub_solucao1 = '';
  String texto_solucao1 = '';
  String sub_solucao2 = '';
  String texto_solucao2 = '';
  String sub_solucao3 = '';
  String texto_solucao3 = '';
  String titulo_pergunta1 = '';
  String sub_pergunta1 = '';
  String pergunta_1 = '';
  String resposta_1 = '';
  String pergunta_2 = '';
  String resposta_2 = '';
  String pergunta_3 = '';
  String resposta_3 = '';
  String titulo_porque = '';
  String subtitulo_porque = '';
  String botao_porque = '';
  String link = '';
  String politica = '';
  String cookies = '';
  String termos = '';
  String nome = '';

  @override
  void initState() {
    super.initState();
    buscaLanding();
  }

  void buscaLanding() async {
    try {
      final store = FirebaseFirestore.instance;
      final User = FirebaseAuth.instance.currentUser;

      final corretorId = User?.uid ?? '';
      final querySnapshot = await store
          .collection('corretores')
          .where('uid', isEqualTo: corretorId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;
        final landingDoc = await store.collection('corretores').doc(docId).collection('landing').doc(docId).get();

        if (landingDoc.exists) {
          final data = landingDoc.data();
          if (data != null) {
            setState(() {
              variaveis = data;
            });
          } else{
            print('Documento da landing page está vazio.');
          }
        }else{
          cadastrarFirebase();
          Navigator.pop(context);
          print("cadastrei");
        }
      } else {
        print('Nenhum corretor encontrado com o ID atual.');
      }
    } catch (error) {
      print('Erro ao buscar as variáveis da landing page: $error');
    }
  }

  void cadastrarFirebase() async {
    try {
      final store = FirebaseFirestore.instance;
      final User = FirebaseAuth.instance.currentUser;

      final corretorId = User?.uid ?? '';
      final querySnapshot = await store
          .collection('corretores')
          .where('uid', isEqualTo: corretorId)
          .get();

    
        final docId = querySnapshot.docs[0].id;


        DocumentReference userRef = store.collection('corretores').doc(docId);

        DocumentReference docRef = userRef.collection('landing').doc(docId);
      
   
      
 
      final Map<String, Map<String, dynamic>> variaveis = {
        "cores":{
          "corPrincipal": "0xFFF7F7F7",
        },
        "appBar":{
          "logo": "https://images.tcdn.com.br/img/img_prod/1244492/1693228776_logo_expert_med.png",
          "link1": "link1",
          "link2": "link2",
          "link3": "link3",
          "link4": "link4",
          "botao1": "botao 1",
          "botao2": "botao 2",
        },
        'titulo': {
          "titulo_1": 'Título 1',
            "subtitulo_1": 'Subtitulo 1',
            "texto_botao_1": 'Texto botao 1',
            "texto_1": "Texto 1",
            "link_imagem": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAAMFBMVEXMzMz////Jycn19fXQ0ND8/Pzl5eXf39/t7e34+PjU1NTy8vLOzs7q6urn5+fb29sVjvDeAAACFUlEQVR4nO3c246qMABAUSzITZT//9tR8QKIYo+J5qRrvQ1gYnaYUoohywAAAAAAAAAAAAAAAAAAAIDfCJ/49Zf/slDnHyh+/fW/Kuw2n9j++vt/Vdh+FGuT1KklVgSxIgyx6jLeIdVY1T/MGrp0Y8V/shDrfWJFEOu05c1wYoWiL8uqeKdX8rFCPcyedt36J5OP1URMNhOPFfL7zHz9DjnxWP34PuawNm6lHWu6WrNdiBXa0cbEY01vkdvHY8vxHEOsV7FCNdkq1otY4TykbW+TisRj5eNW8zErXIb//Lo98VjVONZ+Giu01x31ZUfasbLQjGLN5vDtfU851Eo8Vtbd15hnI1YxXn3uz0enHivLLlOtfH4rPV2pPxcSK7Tlfl+28wlpM2k1DP5iDU/z58fkm5nTJVGsxUMWHlofr5ViLR1RP7Y6fUKshQP2S62Ol0uPwh73H5ZbbbatWPPd1ZNWx1pizfY+b3WReqzxY7FGrJHHWF3Z3f/qxRqZxzqvLtS3KfzqqZVyrOvFL++HefzqoJVurNDdb2yaMiwsn4p1W8+ajVD7IpweUoh1NV4pfZyr747/ja9/R5lmrFAsjuVN//rUSjLW85HcmXVzjbW4tPCGBGMdVmfqYmV+Bx9FrAhiRRArglgRxIogVgSxIogVQawIYkUQK4JXFcTwEowYXq8CAAAAAAAAAAAAAAAAAAAA/6U/XQUVFutJ5WsAAAAASUVORK5CYII=",
        },
        'beneficio_0': {
          "tag": "tag",
          "titulo_beneficio_0": 'Título beneficio 1',
          "subtitulo_beneficio_0": 'Subtitulo beneficio 1',
          "lista_beneficio_0_1": 'Lista beneficio 1',
          "lista_beneficio_0_2": 'Lista beneficio 2',
          "lista_beneficio_0_3": 'Lista beneficio 3',
          "texto_botao": 'Botão',
          "link_imagem": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAAMFBMVEXMzMz////Jycn19fXQ0ND8/Pzl5eXf39/t7e34+PjU1NTy8vLOzs7q6urn5+fb29sVjvDeAAACFUlEQVR4nO3c246qMABAUSzITZT//9tR8QKIYo+J5qRrvQ1gYnaYUoohywAAAAAAAAAAAAAAAAAAAIDfCJ/49Zf/slDnHyh+/fW/Kuw2n9j++vt/Vdh+FGuT1KklVgSxIgyx6jLeIdVY1T/MGrp0Y8V/shDrfWJFEOu05c1wYoWiL8uqeKdX8rFCPcyedt36J5OP1URMNhOPFfL7zHz9DjnxWP34PuawNm6lHWu6WrNdiBXa0cbEY01vkdvHY8vxHEOsV7FCNdkq1otY4TykbW+TisRj5eNW8zErXIb//Lo98VjVONZ+Giu01x31ZUfasbLQjGLN5vDtfU851Eo8Vtbd15hnI1YxXn3uz0enHivLLlOtfH4rPV2pPxcSK7Tlfl+28wlpM2k1DP5iDU/z58fkm5nTJVGsxUMWHlofr5ViLR1RP7Y6fUKshQP2S62Ol0uPwh73H5ZbbbatWPPd1ZNWx1pizfY+b3WReqzxY7FGrJHHWF3Z3f/qxRqZxzqvLtS3KfzqqZVyrOvFL++HefzqoJVurNDdb2yaMiwsn4p1W8+ajVD7IpweUoh1NV4pfZyr747/ja9/R5lmrFAsjuVN//rUSjLW85HcmXVzjbW4tPCGBGMdVmfqYmV+Bx9FrAhiRRArglgRxIogVgSxIogVQawIYkUQK4JXFcTwEowYXq8CAAAAAAAAAAAAAAAAAAAA/6U/XQUVFutJ5WsAAAAASUVORK5CYII=",
        },
        'beneficio_1': {
          "tag": "tag",
          "titulo_beneficio_1": 'Título beneficio 2',
          "subtitulo_beneficio_1": 'Subtitulo beneficio 2',
          "lista_beneficio_0_1": 'Lista beneficio 1',
          "lista_beneficio_0_2": 'Lista beneficio 2',
          "lista_beneficio_0_3": 'Lista beneficio 3',
          "texto_botao": 'Botão',
          "link_imagem": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAAMFBMVEXMzMz////Jycn19fXQ0ND8/Pzl5eXf39/t7e34+PjU1NTy8vLOzs7q6urn5+fb29sVjvDeAAACFUlEQVR4nO3c246qMABAUSzITZT//9tR8QKIYo+J5qRrvQ1gYnaYUoohywAAAAAAAAAAAAAAAAAAAIDfCJ/49Zf/slDnHyh+/fW/Kuw2n9j++vt/Vdh+FGuT1KklVgSxIgyx6jLeIdVY1T/MGrp0Y8V/shDrfWJFEOu05c1wYoWiL8uqeKdX8rFCPcyedt36J5OP1URMNhOPFfL7zHz9DjnxWP34PuawNm6lHWu6WrNdiBXa0cbEY01vkdvHY8vxHEOsV7FCNdkq1otY4TykbW+TisRj5eNW8zErXIb//Lo98VjVONZ+Giu01x31ZUfasbLQjGLN5vDtfU851Eo8Vtbd15hnI1YxXn3uz0enHivLLlOtfH4rPV2pPxcSK7Tlfl+28wlpM2k1DP5iDU/z58fkm5nTJVGsxUMWHlofr5ViLR1RP7Y6fUKshQP2S62Ol0uPwh73H5ZbbbatWPPd1ZNWx1pizfY+b3WReqzxY7FGrJHHWF3Z3f/qxRqZxzqvLtS3KfzqqZVyrOvFL++HefzqoJVurNDdb2yaMiwsn4p1W8+ajVD7IpweUoh1NV4pfZyr747/ja9/R5lmrFAsjuVN//rUSjLW85HcmXVzjbW4tPCGBGMdVmfqYmV+Bx9FrAhiRRArglgRxIogVgSxIogVQawIYkUQK4JXFcTwEowYXq8CAAAAAAAAAAAAAAAAAAAA/6U/XQUVFutJ5WsAAAAASUVORK5CYII=",
        },
        "solucao": {
          "titulo_1": 'Título Solução',
          "subtitulo_1": 'Subtitulo solução',
          "texto_icone_1": 'solucao 1',
          "subtitulo_2": 'Subtitulo da solucao',
          "texto_icone_2": 'solucao 2',
          "subtitulo_3": 'Subtitulo da solucao',
          "texto_icone_3": 'solucao 3',
        },
        "perguntas": {
          "titulo_1": 'Título perguntas',
          "subtitulo_1": 'Subtitulo perguntas',
          "pergunta1": 'pergunta 1',
          "resposta1": "resposta da pergunta 1",
          "pergunta2": 'pergunta 2',
          "resposta2": "resposta da pergunta 2",
          "pergunta3": 'pergunta 3',
          "resposta3": "resposta da pergunta 3",
        },
        "porque":{
          "titulo_1": 'Título focado no problema que você resolve',
          "subtitulo_1": 'Subtitulo do problema',
          "texto_botao_1": 'botao',
        },
        "links":{
          "logo": "https://images.tcdn.com.br/img/img_prod/1244492/1693228776_logo_expert_med.png",
          "link":"Link"
        },
        "footer":{
          "politica": "Política de privacidade",
          "cookies": "Política de cookies",
          "termos": "Termos e Condições",
        }
      };

     
      await docRef.set(variaveis);
      print('Imóvel cadastrado com sucesso!');
    } catch (error) {
      print('Erro ao cadastrar o imóvel: $error');
    }
  }

  // Função para gerar o JSON com as informações inseridas
  Map<String, dynamic> generateJSON() {
    return {
      "cores":{
          "corPrincipal": cor,
        },
        "appBar": {
        "logo": logo,
        "link1": link1,
        "link2": link2,
        "link3": link3,
        "link4": link4,
        "botao1": botao1,
        "botao2": botao2,
      },
        'titulo': {
            "titulo_1": titulo_1,
            "subtitulo_1": subtitulo_1,
            "texto_botao_1": texto_botao_1,
            "texto_1": texto_1,
            "link_imagem": link_imagem
          },


        'beneficio_0': {
          "tag": tag,
          "titulo_beneficio_0": titulo_beneficio_0,
          "subtitulo_beneficio_0": subtitulo_beneficio_0,
          "lista_beneficio_0_1": lista_beneficio_0_1,
          "lista_beneficio_0_2": lista_beneficio_0_2,
          "lista_beneficio_0_3": lista_beneficio_0_3,
          "texto_botao": texto_botao_2,
          "link_imagem": link_imagem_2
        },
        'beneficio_1': {
          "tag": tag_2,
          "titulo_beneficio_1": titulo_beneficio_1,
          "subtitulo_beneficio_1": subtitulo_beneficio_1,
          "lista_beneficio_0_1": lista_beneficio_1_1,
          "lista_beneficio_0_2": lista_beneficio_1_2,
          "lista_beneficio_0_3": lista_beneficio_1_3,
          "texto_botao": texto_botao_3,
          "link_imagem": link_imagem_3
        },
        "solucao": {
          "titulo_1": titulo_solucao1,
          "subtitulo_1": sub_solucao1,
          "texto_icone_1": texto_solucao1,
          "subtitulo_2": sub_solucao2,
          "texto_icone_2": texto_solucao2,
          "subtitulo_3":  sub_solucao3,
          "texto_icone_3": texto_solucao3,
        },
        "perguntas": {
          "titulo_1": titulo_pergunta1,
          "subtitulo_1": sub_pergunta1,
          "pergunta1": pergunta_1,
          "resposta1": resposta_1,
          "pergunta2": pergunta_2,
          "resposta2": resposta_2,
          "pergunta3": pergunta_3,
          "resposta3": resposta_3,
        },
        "porque":{
          "titulo_1": titulo_porque,
          "subtitulo_1": subtitulo_porque,
          "texto_botao_1": botao_porque,
        },
        "links":{
          "logo": logo,
          "link": link,
        },
        "footer":{
          "politica": politica,
          "cookies": cookies,
          "termos": termos,
        }
    };
  }

  void saveJSONToFirebase(Map<String, dynamic> jsonString) async {
    try {
      final store = FirebaseFirestore.instance;
      final User = FirebaseAuth.instance.currentUser;

      if (User != null) {
        final corretorId = User?.uid ?? '';
        final querySnapshot = await store
            .collection('corretores')
            .where('uid', isEqualTo: corretorId)
            .get();

      
        final docId = querySnapshot.docs[0].id;

        DocumentReference userRef = store.collection('corretores').doc(docId);
        
        DocumentReference docRef = userRef.collection('landing').doc(docId);

        await docRef.set(jsonString);
        print('JSON salvo no Firebase com sucesso.');
      } else {
        print('Usuário não autenticado.');
      }
    } catch (error) {
      print('Erro ao salvar o JSON no Firebase: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar landing page (Preencher todos os campos)'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     
                      ExpansionTile(
                            title: Text(
                              "Cores",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    cor = value;
                                  });
                                },
                                decoration: InputDecoration(labelText: "Cor principal"),
                              ),
                            ]),
                      ExpansionTile(
                            title: Text(
                              "Menu",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    logo = value;
                                  });
                                },
                                decoration: InputDecoration(labelText: 'Logo'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    link1 = value;
                                  });
                                },
                                decoration: InputDecoration(labelText: 'Link 1'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    link2 = value;
                                  });
                                },
                                decoration: InputDecoration(labelText: 'Link 2'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    link3 = value;
                                  });
                                },
                                decoration: InputDecoration(labelText: 'Link 3'),
                              ),
                              // TextField(
                              //   onChanged: (value) {
                              //     setState(() {
                              //       link4 = value;
                              //     });
                              //   },
                              //   decoration: InputDecoration(labelText: 'Link 4'),
                              // ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    botao1 = value;
                                  });
                                },
                                decoration: InputDecoration(labelText: 'Botão 1'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    botao2 = value;
                                  });
                                },
                                decoration: InputDecoration(labelText: 'Botão 2'),
                              ),
                            ]),
                      ExpansionTile(
                            title: Text(
                              "Título",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              TextField(
                        onChanged: (value) {
                          setState(() {
                            titulo_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Titulo 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            subtitulo_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Subtitulo 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            texto_botao_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Texto botao 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            texto_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Texto 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            link_imagem = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Link da imagem'),
                      ),
                            ]),
                      ExpansionTile(
                            title: Text(
                              "Beneficios 1",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              TextField(
                        onChanged: (value) {
                          setState(() {
                            tag = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Tag 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            titulo_beneficio_0 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Titulo beneficio'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            subtitulo_beneficio_0 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Subtitulo beneficio 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            lista_beneficio_0_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Lista beneficio 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            lista_beneficio_0_2 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Lista beneficio 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            lista_beneficio_0_3 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Lista beneficio 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            texto_botao_2 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Texto botão'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            link_imagem_2 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Link da imagem'),
                      ),
                            ]),
                      ExpansionTile(
                            title: Text(
                              "Beneficios 2",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              TextField(
                        onChanged: (value) {
                          setState(() {
                            tag_2 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Tag 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            titulo_beneficio_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Titulo beneficio 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            subtitulo_beneficio_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Subtitulo beneficio 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            lista_beneficio_1_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Lista beneficio 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            lista_beneficio_1_2 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Lista beneficio 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            lista_beneficio_1_3 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Lista beneficio 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            texto_botao_3 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Texto botão'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            link_imagem_3 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Link da imagem'),
                      ),
                            ]),
                      ExpansionTile(
                            title: Text(
                              "Solução",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              TextField(
                        onChanged: (value) {
                          setState(() {
                            titulo_solucao1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Titulo'),
                      ),
                      
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            sub_solucao1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Subtitulo'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            texto_solucao1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Titulo icone 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            sub_solucao2 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Subtitulo 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            texto_solucao2 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Titulo icone 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            sub_solucao3 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Subtitulo 3'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            texto_solucao3 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Titulo icone 3'),
                      ),
                            ]),
                      ExpansionTile(
                            title: Text(
                              "Pergunta",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                                TextField(
                        onChanged: (value) {
                          setState(() {
                            titulo_pergunta1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Titulo'),
                      ),
                      
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            sub_pergunta1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Subtitulo'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            pergunta_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Pergunta 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            resposta_1 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Resposta 1'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            pergunta_2 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Pergunta 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            resposta_2 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Resposta 2'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            pergunta_3 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Pergunta 3'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            resposta_3 = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Resposta 3'),
                      ),
                            ]),
                      ExpansionTile(
                            title: Text(
                              "Porque",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              TextField(
                        onChanged: (value) {
                          setState(() {
                            titulo_porque = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Titulo'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            subtitulo_porque = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Subtitulo'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            botao_porque = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Botão'),
                      ),
                            ]),
                      ExpansionTile(
                            title: Text(
                              "Link",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              TextField(
                        onChanged: (value) {
                          setState(() {
                            link = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Lista de link'),
                      ),
                            ]),
                      ExpansionTile(
                            title: Text(
                              "Rodapé",
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              TextField(
                        onChanged: (value) {
                          setState(() {
                            politica = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Politica'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            cookies = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'cookies'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            termos = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Termos'),
                      ),
                            ]),
                      ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> jsonData = generateJSON();
                          String jsonString = json.encode(jsonData);
                          saveJSONToFirebase(jsonData);
                          print(jsonData);
                        },
                        child: Text('Gerar nova landing page'),
                      ),

                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomAppBar(variaveis: variaveis,nome: ''),
                    //Titulo(variaveis: variaveis, nome: ,),
                    Solucao(variaveis: variaveis),
                    Beneficio(tipoPagina: 0, variaveis: variaveis),
                    Beneficio(tipoPagina: 1, variaveis: variaveis),
                    Perguntas(variaveis: variaveis),
                    Porque(variaveis: variaveis),
                    Navegacao(variaveis: variaveis),
                    Footer(variaveis: variaveis),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
