import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';

import '../../util/app_bar_model.dart';
import '../../util/funcoes/buscas.dart';
import '../imobiliaria/imovel_info_page.dart';

class ImovelGridCompletaSemComponente extends StatefulWidget {
  ImovelGridCompletaSemComponente();

  @override
  State<ImovelGridCompletaSemComponente> createState() =>
      _ImovelGridCompletaSemComponenteState();
}

class _ImovelGridCompletaSemComponenteState
    extends State<ImovelGridCompletaSemComponente> {
  bool isDarkMode = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> filteredInstrumentais = [];
  final Buscas instanciaBuscas = Buscas();

  String searchTerm = '';
  bool showFiltradas = false;
  List<Map<String, dynamic>> filteredInstru = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    List<Map<String, dynamic>> instrumentais =
        await instanciaBuscas.buscarTodosImoveis();

    setState(() {
      filteredInstrumentais = instrumentais;
      filteredInstru = instrumentais;
    });
  }

  @override
  Widget build(BuildContext context) {
     bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    Color containerColor =
        isDarkMode ? Colors.black : Color.fromARGB(255, 238, 238, 238);

    if (searchTerm.isEmpty) {
      filteredInstru = showFiltradas ? filteredInstru : filteredInstrumentais;
    } else {
      filteredInstru = filteredInstrumentais.where((instru) {
        final nome = instru['codigo']?.toString()?.toLowerCase() ?? '';

        return nome.contains(searchTerm.toLowerCase());
      }).toList();
    }

    return Scaffold(
      appBar: isSmallScreen ? CustomAppBar(
        subtitle: '',
        title: 'Imóveis',
        isDarkMode: isDarkMode,
      ) : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (!isSmallScreen) CustomMenu(isDarkMode: isDarkMode),
            Expanded(child: Container(
        color: isDarkMode ? Colors.black87 : Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchTerm = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Procurar',
                        labelStyle: TextStyle(
                          color: Color(0xFF6e58e9),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF6e58e9),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                Color(0xFF6e58e9), // Cor do contorno ao clicar
                          ),
                        ),
                        fillColor: isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[200], // Cor do fundo
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: filteredInstru.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (ctx, i) {
                  final instrumental = filteredInstru[i];
                  List<dynamic> infoList = [];
                  for (int i = 0; i < filteredInstru.length; i++) {
                    final instrumental = filteredInstru[i];
                    if (instrumental.containsKey('info')) {
                      dynamic info = instrumental['info'];
                      if (info is List<dynamic>) {
                        infoList.addAll(info);
                      } else if (info is Map<String, dynamic>) {
                        infoList.add(info);
                      }
                    }
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GridTile(
                      child: GestureDetector(
                        child: (infoList != null &&
                                infoList is List &&
                                infoList.isNotEmpty)
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                imageUrl: infoList[i]['image_urls'][0] ?? '',
                              )
                            : Icon(Icons.image_not_supported),
                      ),
                      footer: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        color: containerColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${infoList[i]['preco_original']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.bed,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                          SizedBox(
                                              width:
                                                  4), // Espaço entre o ícone e o texto
                                          SelectableText(
                                            '${infoList[i]['total_dormitorios']} suítes: ${infoList[i]['total_suites']}',
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(), // Spacer para distribuir o espaço restante
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.garage,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                          SizedBox(
                                              width:
                                                  4), // Espaço entre o ícone e o texto
                                          SelectableText(
                                            '${infoList[i]['vagas_garagem']}',
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(), // Spacer para distribuir o espaço restante
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.area_chart,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                          SizedBox(
                                              width:
                                                  4), // Espaço entre o texto "m²" e o valor
                                          SelectableText(
                                            '${infoList[i]['area_total']}',
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: double
                                        .infinity, // Define a largura do container como o máximo possível
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.place,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black54,
                                        ),
                                        SizedBox(
                                            width:
                                                4), // Espaço entre o ícone e o texto
                                        Flexible(
                                          child: SelectableText(
                                            '${infoList[i]['localizacao']}',
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                            // softWrap: true, // Permitrmite que o texto quebre de linha quando necessário
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            List<String> imageUrls = [];
                                            // Converter explicitamente para List<String>
                                            List<dynamic> rawImageUrls =
                                                infoList[i]['image_urls'];
                                            imageUrls.addAll(rawImageUrls
                                                .map((url) => url.toString()));
                                    
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ImoveisInfoPage(
                                                  nome_imovel: infoList[i]
                                                          ['nome_imovel'] ??
                                                      '',
                                                  terreno: infoList[i]
                                                          ['terreno'] ??
                                                      '',
                                                  originalPrice: infoList[i]
                                                          ['preco_original'] ??
                                                      '',
                                                  location: infoList[i]
                                                          ['localizacao'] ??
                                                      '',
                                                  urlsImage: imageUrls ?? [],
                                                  codigo:
                                                      instrumental['codigo'] ??
                                                          '',
                                                  area_total: infoList[i]
                                                          ['area_total'] ??
                                                      '',
                                                  link: instrumental['link'] ??
                                                      '',
                                                  Vagasgaragem: int.tryParse(
                                                          infoList[i][
                                                                  'total_garagem'] ??
                                                              '') ??
                                                      0,
                                                  Totaldormitorios: infoList[i][
                                                          'total_dormitorios'] ??
                                                      '',
                                                  Totalsuites: infoList[i]
                                                          ['total_suites'] ??
                                                      '',
                                                  latitude: infoList[i]
                                                          ['latitude'] ??
                                                      '',
                                                  longitude: infoList[i]
                                                          ['longitude'] ??
                                                      '',
                                                      tipo_pagina: 0,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.info),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),)
          ],
        );
      }),
      drawer: CustomMenu(isDarkMode: false),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
