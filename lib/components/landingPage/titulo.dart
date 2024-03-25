import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_grid.dart';

import '../../pages/imoveis/imoveis_landing.dart';
import '../../pages/map/map_flutter.dart';
import '../../util/redes_sociais_util.dart';
import '../imovel/imovel_carousel_favorites.dart';
import '../imovel/imovel_list_view.dart';

class Titulo extends StatefulWidget {
  final Map<String, dynamic> variaveis;
  final String nome;

  const Titulo({
    Key? key,
    required this.variaveis,
    required this.nome,
  }) : super(key: key);

  @override
  State<Titulo> createState() => _TituloState();
}

class _TituloState extends State<Titulo> {
  List<String> imoveis = [];
  String facebook = '';
  String instagram = '';
  String linkedin = '';
  String celular = '';
  @override
  void initState() {
    super.initState();
    // Chama a função fetchImoveisFavoritos quando o widget é inicializado
    fetchImoveisFavoritos();
    saveRedesSociais();
  }

  Future<List<String>> fetchImoveisFavoritos() async {
    List<String> imoveisFavoritos = [];

    try {

      final snapshot = await FirebaseFirestore.instance
          .collection('corretores')
          .where('name',
              isEqualTo: widget.nome) // Verifique se 'nome' é o campo correto
          .get();

      print('Buscou ${snapshot.docs}'); // Exibe os documentos retornados
      print('Buscou ${snapshot.docs}'); // Exibe os documentos retornados

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          if (doc.data().containsKey('imoveis_favoritos')) {
            print(
                'Document: ${doc.id}, Imóveis Favoritos: ${doc['imoveis_favoritos']}');
            imoveisFavoritos = List<String>.from(doc['imoveis_favoritos']);
            setState(() {
              imoveis = imoveisFavoritos;
            });
            break; // Saímos do loop após encontrar e atribuir os imóveis favoritos
          } else {
            print(
                'O documento ${doc.id} não possui o campo "imoveis_favoritos"');
          }
        }
      }
    } catch (error) {
      print('Erro ao buscar informações do corretor: $error');
    }
    print(imoveis);
    return imoveisFavoritos;
  }

  Future<void> saveRedesSociais() async {
    try {
      final store = FirebaseFirestore.instance;

      final querySnapshot = await store
          .collection('corretores')
          .where('name', isEqualTo: widget.nome)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;
        final contato = querySnapshot.docs[0].data()['contato'];

        if (contato != null && contato['redes_sociais'] != null) {
          final redesSociais = contato['redes_sociais'];
          setState(() {
            facebook = redesSociais['facebook'] ?? '';
            instagram = redesSociais['instagram'] ?? '';
            linkedin = redesSociais['linkedin'] ?? '';
            celular = contato['celular'] ?? '';
          });
          print(
              'Informações das redes sociais salvas nas variáveis com sucesso!');
        } else {
          print(
              'O corretor não possui informações de contato ou redes sociais.');
        }
      } else {
        print('Nenhum corretor encontrado com o nome ${widget.nome}.');
      }
    } catch (error) {
      print('Erro ao buscar as variáveis da landing page: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1200,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          
          Padding(
            padding: EdgeInsets.all(20),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 450,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          widget.variaveis['titulo']!['link_imagem']!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 40), // Preenchimento apenas à esquerda
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinhado à esquerda
                    children: [
                      Text(
                        widget.variaveis['titulo']!['titulo_1']!,
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.variaveis['titulo']!['subtitulo_1']!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 10.0,
                              minimumSize: Size(200, 60),
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Text(
                              widget.variaveis['titulo']!['texto_botao_1']!,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 10),
                      RedesSociaisRow(
                          celular: celular,
                          facebook: facebook,
                          instagram: instagram,
                          linkedin: linkedin),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ImovelLanding(
              nome: widget.nome,
              fav: 0,
            ),
          ),
        ],
      ),
    );
  }
}
