import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

  import 'package:flutter_map/flutter_map.dart';
  import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:get/get.dart';
  import 'package:projeto_imobiliaria/components/landingPage/landingAppBar.dart';
  import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
  import 'package:provider/provider.dart';
  import 'package:url_launcher/url_launcher.dart';

  import '../../theme/appthemestate.dart';
  import '../landingPage/footer.dart';
import '../landingPage/navegacao.dart';
import 'info_caracteristicas_component.dart';
  import 'package:latlong2/latlong.dart';

  class ImovelInfoComponent extends StatefulWidget {
    Map<String, dynamic> caracteristicas;
    final NewImovel imovel;
    final int tipo_pagina;

    ImovelInfoComponent(this.tipo_pagina, this.caracteristicas, this.imovel);

    @override
    _ImovelInfoComponentState createState() => _ImovelInfoComponentState();
  }

  class _ImovelInfoComponentState extends State<ImovelInfoComponent> {
    // Indice da imagem atual
    int _currentIndex = 0;
    Map<String, dynamic> variaveis = {};
    late String nomeComEspacos = "";
    //late GoogleMapController mapController;
    // Controlador do CarouselSlider
    final CarouselController _carouselController = CarouselController();

    @override
    void initState() {
      super.initState();
      final currentRoute = Get.currentRoute;
      final nome = currentRoute.split('/corretor/')[1];
      final sem = nome.split("/imoveis")[0];
      nomeComEspacos = sem.replaceAll('-', ' ');
      buscaLanding(nomeComEspacos);
    }

    void _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir o link: $url';
      }
    }

    void buscaLanding(String nome) async {
      try {
        final store = FirebaseFirestore.instance;

        final querySnapshot = await store
            .collection('corretores')
            .where('name', isEqualTo: nome)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final docId = querySnapshot.docs[0].id;
          final landingDoc = await store
              .collection('corretores')
              .doc(docId)
              .collection('landing')
              .doc(docId)
              .get();

          if (landingDoc.exists) {
            final data = landingDoc.data();
            if (data != null) {
              setState(() {
                variaveis = data;
              });
            } else {
              print('Documento da landing page está vazio.');
            }
          }
        } else {
          print('Nenhum corretor encontrado com o ID atual.');
        }
      } catch (error) {
        print('Erro ao buscar as variáveis da landing page: $error');
      }
    }

    @override
    Widget build(BuildContext context) {
      final themeNotifier = Provider.of<AppThemeStateNotifier>(context);

      return Scaffold(
        appBar: CustomAppBar(variaveis: variaveis, nome: nomeComEspacos),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // Adicionando bordas arredondadas
                      color: !themeNotifier.isDarkModeEnabled
                        ? Color.fromARGB(255, 238, 238, 238)
                        : Colors.black,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 8, bottom: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${widget.imovel.detalhes['nome_imovel']}  ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Cód.',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${widget.imovel.detalhes['nome_imovel'].substring(widget.imovel.detalhes['nome_imovel'].indexOf('Cód') + 3)}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 8, bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.place,
                              color: themeNotifier.isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${widget.imovel.localizacao['endereco']['cidade']}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alinhar os elementos no topo
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CarouselSlider(
                                  carouselController: _carouselController,
                                  options: CarouselOptions(
                                    height: widget.tipo_pagina == 0 ? 250 : 200,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentIndex = index;
                                      });
                                    },
                                  ),
                                  items: widget.imovel.imagens.map((url) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: widget.tipo_pagina == 0
                                              ? 450
                                              : 250,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.8,
                                                          child: Image.network(
                                                            url,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 8,
                                                          right: 8,
                                                          child: IconButton(
                                                            icon: Icon(
                                                                Icons.close),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Image.network(
                                              url,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                /*
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back,
                                          ),
                                      onPressed: () {
                                        if (_currentIndex > 0) {
                                          _carouselController.previousPage();
                                        }
                                      },
                                    ),
                                    Text(
                                      '${_currentIndex + 1} / ${widget.imovel.imagens.length}',
                                      style: TextStyle(),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward,
                                          ),
                                      onPressed: () {
                                        if (_currentIndex <
                                            widget.imovel.imagens.length - 1) {
                                          _carouselController.nextPage();
                                        }
                                      },
                                    ),
                                  ],
                                ),*/
                              ],
                            ),
                          ),
                        ),
                        if (widget.tipo_pagina == 0)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SelectableText(
                                                    'A partir de ',
                                                    style: TextStyle(
                                                      color: themeNotifier
                                                              .isDarkModeEnabled
                                                          ? Colors.white
                                                          : Colors.black54,
                                                    ),
                                                  ),
                                                  SelectableText(
                                                    '${widget.imovel.preco['preco_original']}',
                                                    style: const TextStyle(
                                                      color: Colors.purple,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          color: themeNotifier.isDarkModeEnabled
                                              ? Colors.black54
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.bed,
                                                  size: 32,
                                                  color: themeNotifier
                                                          .isDarkModeEnabled
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                                SizedBox(height: 8),
                                                SelectableText(
                                                  '${widget.imovel.detalhes['total_dormitorios']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: themeNotifier
                                                            .isDarkModeEnabled
                                                        ? Colors.white
                                                        : Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              16), // Adicione um espaço entre os dois Cards
                                      Expanded(
                                        child: Card(
                                          color: themeNotifier.isDarkModeEnabled
                                              ? Colors.black54
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.garage,
                                                  size: 32,
                                                  color: themeNotifier
                                                          .isDarkModeEnabled
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                                SizedBox(height: 8),
                                                SelectableText(
                                                  '${widget.imovel.detalhes['vagas_garagem']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: themeNotifier
                                                            .isDarkModeEnabled
                                                        ? Colors.white
                                                        : Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          color: themeNotifier.isDarkModeEnabled
                                              ? Colors.black54
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.aspect_ratio,
                                                  size: 32,
                                                  color: themeNotifier
                                                          .isDarkModeEnabled
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                                SizedBox(height: 8),
                                                SelectableText(
                                                  ' ${widget.imovel.detalhes['area_total']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: themeNotifier
                                                            .isDarkModeEnabled
                                                        ? Colors.white
                                                        : Colors.black54,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                SelectableText(
                                                  'Área total',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: themeNotifier
                                                            .isDarkModeEnabled
                                                        ? Colors.white
                                                        : Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              16), // Adicione um espaço entre os dois Cards
                                      Expanded(
                                        child: Card(
                                          color: themeNotifier.isDarkModeEnabled
                                              ? Colors.black54
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.aspect_ratio,
                                                  size: 32,
                                                  color: themeNotifier
                                                          .isDarkModeEnabled
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                                SizedBox(height: 8),
                                                SelectableText(
                                                  '${widget.imovel.detalhes['area_privativa']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: themeNotifier
                                                            .isDarkModeEnabled
                                                        ? Colors.white
                                                        : Colors.black54,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                SelectableText(
                                                  'Área privativa',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: themeNotifier
                                                            .isDarkModeEnabled
                                                        ? Colors.white
                                                        : Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        ImovelCaracteristicasWidget(
                          caracteristicas: widget.caracteristicas,
                          isDarkMode: themeNotifier.isDarkModeEnabled,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(
                        'Localização do imóvel:',
                        style: TextStyle(
                          color: themeNotifier.isDarkModeEnabled
                              ? Colors.white
                              : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: themeNotifier.isDarkModeEnabled
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FlutterMap(
                          options: MapOptions(
                              center: LatLng(
                                double.parse(
                                    widget.imovel.localizacao['latitude']),
                                double.parse(
                                    widget.imovel.localizacao['longitude']),
                              ),
                              zoom: 13.0,
                              maxZoom: 18.0),
                          children: <Widget>[
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerClusterLayerWidget(
                              options: MarkerClusterLayerOptions(
                                maxClusterRadius: 120,
                                size: Size(40, 40),
                                markers: [
                                  Marker(
                                    point: LatLng(
                                      double.parse(widget
                                          .imovel.localizacao['latitude']),
                                      double.parse(widget
                                          .imovel.localizacao['longitude']),
                                    ),
                                    width: 40,
                                    height: 40,
                                    builder: (context) => GestureDetector(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.location_on,
                                        size: 40,
                                        color: Color.fromARGB(255, 255, 17, 0),
                                      ),
                                    ),
                                  ),
                                ],
                                polygonOptions: PolygonOptions(
                                  borderColor: Color.fromARGB(255, 255, 1, 1),
                                  color: Colors.black12,
                                  borderStrokeWidth: 3,
                                ),
                                builder: (context, markers) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromARGB(255, 255, 0, 0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        markers.length.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (widget.imovel.link_imovel != '')
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'Acesse o imóvel',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                _launchURL(widget.imovel.link_imovel);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.open_in_new,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Navegacao(variaveis: variaveis),
              Footer(variaveis: variaveis),
            ],
          ),
        ),
      ),
    );
  }
}
