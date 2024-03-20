import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';

import '../../components/landingPage/beneficio.dart';
import '../../components/landingPage/footer.dart';
import '../../components/landingPage/landingAppBar.dart';
import '../../components/landingPage/navegacao.dart';
import '../../components/landingPage/perguntas.dart';
import '../../components/landingPage/porque.dart';
import '../../components/landingPage/solucao.dart';
import '../../components/landingPage/titulo.dart';


class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final Map<String, Map<String, String>> variaveis = {
    "cores":{
      "corPrincipal": "0xFFF7F7F7",
    },
    "appBar":{
      "logo": "https://images.tcdn.com.br/img/img_prod/1244492/1693228776_logo_expert_med.png",
      "link1": "home",
      "link2": "CONTATO",
      "link3": "SOBRE",
      "link4": "SERVIÇOS",
      "botao1": "LOGIN",
      "botao2": "CADASTRO",
    },
    'titulo': {
       "titulo_1": 'Título focado no problema que você resolve',
        "subtitulo_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
        "texto_botao_1": 'botao1',
        "texto_1": "Texto teste ao lado do botao",
        "link_imagem": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAAMFBMVEXMzMz////Jycn19fXQ0ND8/Pzl5eXf39/t7e34+PjU1NTy8vLOzs7q6urn5+fb29sVjvDeAAACFUlEQVR4nO3c246qMABAUSzITZT//9tR8QKIYo+J5qRrvQ1gYnaYUoohywAAAAAAAAAAAAAAAAAAAIDfCJ/49Zf/slDnHyh+/fW/Kuw2n9j++vt/Vdh+FGuT1KklVgSxIgyx6jLeIdVY1T/MGrp0Y8V/shDrfWJFEOu05c1wYoWiL8uqeKdX8rFCPcyedt36J5OP1URMNhOPFfL7zHz9DjnxWP34PuawNm6lHWu6WrNdiBXa0cbEY01vkdvHY8vxHEOsV7FCNdkq1otY4TykbW+TisRj5eNW8zErXIb//Lo98VjVONZ+Giu01x31ZUfasbLQjGLN5vDtfU851Eo8Vtbd15hnI1YxXn3uz0enHivLLlOtfH4rPV2pPxcSK7Tlfl+28wlpM2k1DP5iDU/z58fkm5nTJVGsxUMWHlofr5ViLR1RP7Y6fUKshQP2S62Ol0uPwh73H5ZbbbatWPPd1ZNWx1pizfY+b3WReqzxY7FGrJHHWF3Z3f/qxRqZxzqvLtS3KfzqqZVyrOvFL++HefzqoJVurNDdb2yaMiwsn4p1W8+ajVD7IpweUoh1NV4pfZyr747/ja9/R5lmrFAsjuVN//rUSjLW85HcmXVzjbW4tPCGBGMdVmfqYmV+Bx9FrAhiRRArglgRxIogVgSxIogVQawIYkUQK4JXFcTwEowYXq8CAAAAAAAAAAAAAAAAAAAA/6U/XQUVFutJ5WsAAAAASUVORK5CYII=",
    },
    'beneficio_0': {
      "tag": "tag",
      "titulo_beneficio_0": 'Título focado no problema que você resolve',
      "subtitulo_beneficio_0": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
      "lista_beneficio_0_1": '+5,000 pessoas como tu já compraram este produto.',
      "lista_beneficio_0_2": '+5,000 pessoas como tu já compraram este produto.',
      "lista_beneficio_0_3": '+5,000 pessoas como tu já compraram este produto.',
      "texto_botao": 'Botão',
      "link_imagem": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAAMFBMVEXMzMz////Jycn19fXQ0ND8/Pzl5eXf39/t7e34+PjU1NTy8vLOzs7q6urn5+fb29sVjvDeAAACFUlEQVR4nO3c246qMABAUSzITZT//9tR8QKIYo+J5qRrvQ1gYnaYUoohywAAAAAAAAAAAAAAAAAAAIDfCJ/49Zf/slDnHyh+/fW/Kuw2n9j++vt/Vdh+FGuT1KklVgSxIgyx6jLeIdVY1T/MGrp0Y8V/shDrfWJFEOu05c1wYoWiL8uqeKdX8rFCPcyedt36J5OP1URMNhOPFfL7zHz9DjnxWP34PuawNm6lHWu6WrNdiBXa0cbEY01vkdvHY8vxHEOsV7FCNdkq1otY4TykbW+TisRj5eNW8zErXIb//Lo98VjVONZ+Giu01x31ZUfasbLQjGLN5vDtfU851Eo8Vtbd15hnI1YxXn3uz0enHivLLlOtfH4rPV2pPxcSK7Tlfl+28wlpM2k1DP5iDU/z58fkm5nTJVGsxUMWHlofr5ViLR1RP7Y6fUKshQP2S62Ol0uPwh73H5ZbbbatWPPd1ZNWx1pizfY+b3WReqzxY7FGrJHHWF3Z3f/qxRqZxzqvLtS3KfzqqZVyrOvFL++HefzqoJVurNDdb2yaMiwsn4p1W8+ajVD7IpweUoh1NV4pfZyr747/ja9/R5lmrFAsjuVN//rUSjLW85HcmXVzjbW4tPCGBGMdVmfqYmV+Bx9FrAhiRRArglgRxIogVgSxIogVQawIYkUQK4JXFcTwEowYXq8CAAAAAAAAAAAAAAAAAAAA/6U/XQUVFutJ5WsAAAAASUVORK5CYII=",
    },
    'beneficio_1': {
      "tag": "tag",
      "titulo_beneficio_1": 'Título focado no problema que você resolve',
      "subtitulo_beneficio_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
      "lista_beneficio_0_1": '+5,000 pessoas como tu já compraram este produto.',
      "lista_beneficio_0_2": '+5,000 pessoas como tu já compraram este produto.',
      "lista_beneficio_0_3": '+5,000 pessoas como tu já compraram este produto.',
      "texto_botao": 'Botão',
      "link_imagem": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAAMFBMVEXMzMz////Jycn19fXQ0ND8/Pzl5eXf39/t7e34+PjU1NTy8vLOzs7q6urn5+fb29sVjvDeAAACFUlEQVR4nO3c246qMABAUSzITZT//9tR8QKIYo+J5qRrvQ1gYnaYUoohywAAAAAAAAAAAAAAAAAAAIDfCJ/49Zf/slDnHyh+/fW/Kuw2n9j++vt/Vdh+FGuT1KklVgSxIgyx6jLeIdVY1T/MGrp0Y8V/shDrfWJFEOu05c1wYoWiL8uqeKdX8rFCPcyedt36J5OP1URMNhOPFfL7zHz9DjnxWP34PuawNm6lHWu6WrNdiBXa0cbEY01vkdvHY8vxHEOsV7FCNdkq1otY4TykbW+TisRj5eNW8zErXIb//Lo98VjVONZ+Giu01x31ZUfasbLQjGLN5vDtfU851Eo8Vtbd15hnI1YxXn3uz0enHivLLlOtfH4rPV2pPxcSK7Tlfl+28wlpM2k1DP5iDU/z58fkm5nTJVGsxUMWHlofr5ViLR1RP7Y6fUKshQP2S62Ol0uPwh73H5ZbbbatWPPd1ZNWx1pizfY+b3WReqzxY7FGrJHHWF3Z3f/qxRqZxzqvLtS3KfzqqZVyrOvFL++HefzqoJVurNDdb2yaMiwsn4p1W8+ajVD7IpweUoh1NV4pfZyr747/ja9/R5lmrFAsjuVN//rUSjLW85HcmXVzjbW4tPCGBGMdVmfqYmV+Bx9FrAhiRRArglgRxIogVgSxIogVQawIYkUQK4JXFcTwEowYXq8CAAAAAAAAAAAAAAAAAAAA/6U/XQUVFutJ5WsAAAAASUVORK5CYII=",
    },
    "solucao": {
      "titulo_1": 'Título focado no problema que você resolve',
      "subtitulo_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
      "texto_icone_1": 'solucao 1',
      "subtitulo_2": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
      "texto_icone_2": 'solucao 2',
      "subtitulo_3": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
      "texto_icone_3": 'solucao 1',
    },
    "perguntas": {
      "titulo_1": 'Título focado no problema que você resolve',
      "subtitulo_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
      "pergunta1": 'pergunta 1',
      "resposta1": "resposta da pergunta 1",
      "pergunta2": 'pergunta 2',
      "resposta2": "resposta da pergunta 2",
      "pergunta3": 'pergunta 3',
      "resposta3": "resposta da pergunta 3",
    },
    "porque":{
      "titulo_1": 'Título focado no problema que você resolve',
      "subtitulo_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
      "texto_botao_1": 'botao1',
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
        print(docRef);
   
      
 
      final Map<String, dynamic> variaveis = {
        "cores":{
          "corPrincipal": "0xFFF7F7F7",
        },
        "appBar":{
          "logo": "https://images.tcdn.com.br/img/img_prod/1244492/1693228776_logo_expert_med.png",
          "link1": "home",
          "link2": "CONTATO",
          "link3": "SOBRE",
          "link4": "SERVIÇOS",
          "botao1": "LOGIN",
          "botao2": "CADASTRO",
        },
        'titulo': {
          "titulo_1": 'Título focado no problema que você resolve',
            "subtitulo_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
            "texto_botao_1": 'botao1',
            "texto_1": "Texto teste ao lado do botao",
            "link_imagem": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAAMFBMVEXMzMz////Jycn19fXQ0ND8/Pzl5eXf39/t7e34+PjU1NTy8vLOzs7q6urn5+fb29sVjvDeAAACFUlEQVR4nO3c246qMABAUSzITZT//9tR8QKIYo+J5qRrvQ1gYnaYUoohywAAAAAAAAAAAAAAAAAAAIDfCJ/49Zf/slDnHyh+/fW/Kuw2n9j++vt/Vdh+FGuT1KklVgSxIgyx6jLeIdVY1T/MGrp0Y8V/shDrfWJFEOu05c1wYoWiL8uqeKdX8rFCPcyedt36J5OP1URMNhOPFfL7zHz9DjnxWP34PuawNm6lHWu6WrNdiBXa0cbEY01vkdvHY8vxHEOsV7FCNdkq1otY4TykbW+TisRj5eNW8zErXIb//Lo98VjVONZ+Giu01x31ZUfasbLQjGLN5vDtfU851Eo8Vtbd15hnI1YxXn3uz0enHivLLlOtfH4rPV2pPxcSK7Tlfl+28wlpM2k1DP5iDU/z58fkm5nTJVGsxUMWHlofr5ViLR1RP7Y6fUKshQP2S62Ol0uPwh73H5ZbbbatWPPd1ZNWx1pizfY+b3WReqzxY7FGrJHHWF3Z3f/qxRqZxzqvLtS3KfzqqZVyrOvFL++HefzqoJVurNDdb2yaMiwsn4p1W8+ajVD7IpweUoh1NV4pfZyr747/ja9/R5lmrFAsjuVN//rUSjLW85HcmXVzjbW4tPCGBGMdVmfqYmV+Bx9FrAhiRRArglgRxIogVgSxIogVQawIYkUQK4JXFcTwEowYXq8CAAAAAAAAAAAAAAAAAAAA/6U/XQUVFutJ5WsAAAAASUVORK5CYII=",
        },
        'beneficio_0': {
          "tag": "tag",
          "titulo_beneficio_0": 'Título focado no problema que você resolve',
          "subtitulo_beneficio_0": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
          "lista_beneficio_0_1": '+5,000 pessoas como tu já compraram este produto.',
          "lista_beneficio_0_2": '+5,000 pessoas como tu já compraram este produto.',
          "lista_beneficio_0_3": '+5,000 pessoas como tu já compraram este produto.',
          "texto_botao": 'Botão',
          "link_imagem": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAAMFBMVEXMzMz////Jycn19fXQ0ND8/Pzl5eXf39/t7e34+PjU1NTy8vLOzs7q6urn5+fb29sVjvDeAAACFUlEQVR4nO3c246qMABAUSzITZT//9tR8QKIYo+J5qRrvQ1gYnaYUoohywAAAAAAAAAAAAAAAAAAAIDfCJ/49Zf/slDnHyh+/fW/Kuw2n9j++vt/Vdh+FGuT1KklVgSxIgyx6jLeIdVY1T/MGrp0Y8V/shDrfWJFEOu05c1wYoWiL8uqeKdX8rFCPcyedt36J5OP1URMNhOPFfL7zHz9DjnxWP34PuawNm6lHWu6WrNdiBXa0cbEY01vkdvHY8vxHEOsV7FCNdkq1otY4TykbW+TisRj5eNW8zErXIb//Lo98VjVONZ+Giu01x31ZUfasbLQjGLN5vDtfU851Eo8Vtbd15hnI1YxXn3uz0enHivLLlOtfH4rPV2pPxcSK7Tlfl+28wlpM2k1DP5iDU/z58fkm5nTJVGsxUMWHlofr5ViLR1RP7Y6fUKshQP2S62Ol0uPwh73H5ZbbbatWPPd1ZNWx1pizfY+b3WReqzxY7FGrJHHWF3Z3f/qxRqZxzqvLtS3KfzqqZVyrOvFL++HefzqoJVurNDdb2yaMiwsn4p1W8+ajVD7IpweUoh1NV4pfZyr747/ja9/R5lmrFAsjuVN//rUSjLW85HcmXVzjbW4tPCGBGMdVmfqYmV+Bx9FrAhiRRArglgRxIogVgSxIogVQawIYkUQK4JXFcTwEowYXq8CAAAAAAAAAAAAAAAAAAAA/6U/XQUVFutJ5WsAAAAASUVORK5CYII=",
        },
        'beneficio_1': {
          "tag": "tag",
          "titulo_beneficio_1": 'Título focado no problema que você resolve',
          "subtitulo_beneficio_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
          "lista_beneficio_0_1": '+5,000 pessoas como tu já compraram este produto.',
          "lista_beneficio_0_2": '+5,000 pessoas como tu já compraram este produto.',
          "lista_beneficio_0_3": '+5,000 pessoas como tu já compraram este produto.',
          "texto_botao": 'Botão',
          "link_imagem": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAAMFBMVEXMzMz////Jycn19fXQ0ND8/Pzl5eXf39/t7e34+PjU1NTy8vLOzs7q6urn5+fb29sVjvDeAAACFUlEQVR4nO3c246qMABAUSzITZT//9tR8QKIYo+J5qRrvQ1gYnaYUoohywAAAAAAAAAAAAAAAAAAAIDfCJ/49Zf/slDnHyh+/fW/Kuw2n9j++vt/Vdh+FGuT1KklVgSxIgyx6jLeIdVY1T/MGrp0Y8V/shDrfWJFEOu05c1wYoWiL8uqeKdX8rFCPcyedt36J5OP1URMNhOPFfL7zHz9DjnxWP34PuawNm6lHWu6WrNdiBXa0cbEY01vkdvHY8vxHEOsV7FCNdkq1otY4TykbW+TisRj5eNW8zErXIb//Lo98VjVONZ+Giu01x31ZUfasbLQjGLN5vDtfU851Eo8Vtbd15hnI1YxXn3uz0enHivLLlOtfH4rPV2pPxcSK7Tlfl+28wlpM2k1DP5iDU/z58fkm5nTJVGsxUMWHlofr5ViLR1RP7Y6fUKshQP2S62Ol0uPwh73H5ZbbbatWPPd1ZNWx1pizfY+b3WReqzxY7FGrJHHWF3Z3f/qxRqZxzqvLtS3KfzqqZVyrOvFL++HefzqoJVurNDdb2yaMiwsn4p1W8+ajVD7IpweUoh1NV4pfZyr747/ja9/R5lmrFAsjuVN//rUSjLW85HcmXVzjbW4tPCGBGMdVmfqYmV+Bx9FrAhiRRArglgRxIogVgSxIogVQawIYkUQK4JXFcTwEowYXq8CAAAAAAAAAAAAAAAAAAAA/6U/XQUVFutJ5WsAAAAASUVORK5CYII=",
        },
        "solucao": {
          "titulo_1": 'Título focado no problema que você resolve',
          "subtitulo_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
          "texto_icone_1": 'solucao 1',
          "subtitulo_2": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
          "texto_icone_2": 'solucao 2',
          "subtitulo_3": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
          "texto_icone_3": 'solucao 1',
        },
        "perguntas": {
          "titulo_1": 'Título focado no problema que você resolve',
          "subtitulo_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
          "pergunta1": 'pergunta 1',
          "resposta1": "resposta da pergunta 1",
          "pergunta2": 'pergunta 2',
          "resposta2": "resposta da pergunta 2",
          "pergunta3": 'pergunta 3',
          "resposta3": "resposta da pergunta 3",
        },
        "porque":{
          "titulo_1": 'Título focado no problema que você resolve',
          "subtitulo_1": 'Descreva de forma breve e direta o que é o seu produto, pra quem ele é e o que torna ele tão especial.',
          "texto_botao_1": 'botao1',
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

  @override
  Widget build(BuildContext context) {
    int corPrincipal = int.parse(variaveis["cores"]!["corPrincipal"]!);
    Color corPrincipalColor = Color(corPrincipal);
    return Scaffold(
      appBar: CustomAppBar(variaveis: variaveis,),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView( // Adicione um SingleChildScrollView
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: corPrincipalColor,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Titulo(variaveis: variaveis),
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
              ],
            ),
          );
        },
      ),
      drawer: CustomMenu(isDarkMode: true),
    );
  }
    
}
