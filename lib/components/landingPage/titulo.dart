import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_grid.dart';

import '../../pages/imoveis/imoveis_landing.dart';
import '../../pages/map/map_flutter.dart';
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
  bool _showGrid = true;
  bool _showList = false;
  bool _isHoveredG = true;
  bool _isHoveredL = false;
  bool _isHoveredM = false;
  List<String> imoveis = [];

  @override
  void initState() {
    super.initState();
    // Chama a função fetchImoveisFavoritos quando o widget é inicializado
    fetchImoveisFavoritos();
  }

  Future<List<String>> fetchImoveisFavoritos() async {
    List<String> imoveisFavoritos = [];

    try {
      print('Buscando corretor ${widget.nome}');
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1500,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Text('Imoveis favoritos'),
          FavoriteImoveisCarousel(
            false,
            imoveis,
          ),
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
                      Text(
                        widget.variaveis['titulo']!['texto_1']!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Color(0xFF6e58e9),
                    width: 2, // largura da borda
                  ),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  color: _isHoveredG ? Colors.white : Color(0xFF6e58e9),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      setState(() {
                        _showGrid = true;
                        _showList = false;
                      });
                    },
                    onHover: (hovering) {
                      setState(() {
                        _isHoveredG = hovering;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: _isHoveredL ? 125 : 55,
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Centralizar o ícone verticalmente
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 30,
                            child: Icon(Icons.grid_on_sharp,
                                color: _isHoveredG
                                    ? Color(0xFF6e58e9)
                                    : Colors.white),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: 1.0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'GRID',
                                  style: TextStyle(
                                      color: _isHoveredG
                                          ? Color(0xFF6e58e9)
                                          : Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Material(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF6e58e9),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    setState(() {
                      _showGrid = false;
                      _showList = true;
                    });
                  },
                  onHover: (hovering) {
                    setState(() {
                      _isHoveredL = hovering;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _isHoveredL ? 125 : 55,
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centralizar o ícone verticalmente
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: _isHoveredL ? 30 : 0,
                          child: Icon(Icons.list, color: Colors.white),
                        ),
                        Expanded(
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: _isHoveredL ? 1.0 : 0.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Lista',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Material(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF6e58e9),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    setState(() {
                      _showGrid = false;
                      _showList = false;
                    });
                  },
                  onHover: (hovering) {
                    setState(() {
                      _isHoveredM = hovering;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _isHoveredM ? 125 : 55,
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centralizar o ícone verticalmente
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: _isHoveredM ? 30 : 0,
                          child: Icon(Icons.place, color: Colors.white),
                        ),
                        Expanded(
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: _isHoveredM ? 1.0 : 0.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'MAPA',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ImovelLanding(nome: widget.nome),
          ),
        ],
      ),
    );
  }
}
