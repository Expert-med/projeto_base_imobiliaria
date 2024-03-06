import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'info_caracteristicas_component.dart';

class ImovelInfoComponent extends StatefulWidget {
  bool isDarkMode;
  Map<String, dynamic> caracteristicas;
  final NewImovel imovel;
  final int tipo_pagina;

  ImovelInfoComponent(
      this.isDarkMode, this.tipo_pagina, this.caracteristicas, this.imovel);

  @override
  _ImovelInfoComponentState createState() => _ImovelInfoComponentState();
}

class _ImovelInfoComponentState extends State<ImovelInfoComponent> {
  // Indice da imagem atual
  int _currentIndex = 0;
  late GoogleMapController mapController;
  // Controlador do CarouselSlider
  final CarouselController _carouselController = CarouselController();

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.isDarkMode ? Colors.black45 : Colors.white;
    Color textColor = !widget.isDarkMode ? Colors.black87 : Colors.white;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          
          color: backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // Adicionando bordas arredondadas
      color: Color.fromARGB(255, 238, 238, 238),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.imovel.detalhes['nome_imovel'].substring(0, widget.imovel.detalhes['nome_imovel'].indexOf('Cód'))}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: 'Cód',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: '${widget.imovel.detalhes['nome_imovel'].substring(widget.imovel.detalhes['nome_imovel'].indexOf('Cód') + 3)}',
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
          padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.place,
                color: widget.isDarkMode ? Colors.white : Colors.black54,
              ),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${widget.imovel.localizacao['endereco']['bairro']}',
                  style: TextStyle(fontSize: 15, color: textColor),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back,
                                          color: textColor),
                                      onPressed: () {
                                        if (_currentIndex > 0) {
                                          _carouselController.previousPage();
                                        }
                                      },
                                    ),
                                    Text(
                                      '${_currentIndex + 1} / ${widget.imovel.imagens.length}',
                                      style: TextStyle(color: textColor),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward,
                                          color: textColor),
                                      onPressed: () {
                                        if (_currentIndex <
                                            widget.imovel.imagens.length - 1) {
                                          _carouselController.nextPage();
                                        }
                                      },
                                    ),
                                  ],
                                ),
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
                                                      color: widget.isDarkMode
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
                                          color: widget.isDarkMode
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
                                                  color: widget.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                                SizedBox(height: 8),
                                                SelectableText(
                                                  '${widget.imovel.detalhes['total_dormitorios']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: widget.isDarkMode
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
                                          color: widget.isDarkMode
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
                                                  color: widget.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                                SizedBox(height: 8),
                                                SelectableText(
                                                  '${widget.imovel.detalhes['vagas_garagem']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: widget.isDarkMode
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
                                          color: widget.isDarkMode
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
                                                  color: widget.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                                SizedBox(height: 8),
                                                SelectableText(
                                                  ' ${widget.imovel.detalhes['area_total']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: widget.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black54,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                SelectableText(
                                                  'Área total',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: widget.isDarkMode
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
                                          color: widget.isDarkMode
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
                                                  color: widget.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                                SizedBox(height: 8),
                                                SelectableText(
                                                  '${widget.imovel.detalhes['area_privativa']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: widget.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black54,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                SelectableText(
                                                  'Área privativa',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: widget.isDarkMode
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
                          isDarkMode: widget.isDarkMode,
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
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              widget.isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(
                                  widget.imovel.localizacao['latitude']),
                              double.parse(
                                  widget.imovel.localizacao['longitude']),
                            ),
                            zoom: 15,
                          ),
                          onMapCreated: (controller) =>
                              mapController = controller,
                          onTap: (LatLng latLng) {},
                          markers: Set<Marker>.of(
                            [
                              Marker(
                                markerId: MarkerId(
                                    widget.imovel.detalhes['nome_imovel']),
                                position: LatLng(
                                  double.parse(
                                      widget.imovel.localizacao['latitude']),
                                  double.parse(
                                      widget.imovel.localizacao['longitude']),
                                ),
                                infoWindow: InfoWindow(
                                    title:
                                        widget.imovel.detalhes['nome_imovel']),
                                onTap: () {
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
