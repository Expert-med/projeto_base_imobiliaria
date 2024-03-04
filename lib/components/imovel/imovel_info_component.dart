import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'info_caracteristicas_component.dart';

class ImovelInfoComponent extends StatefulWidget {
  final String nome_imovel;
  final String terreno;
  final String location;
  final String originalPrice;
  final List<String> urlsImage;
  final String codigo;
  final String area_total;
  final String link;
  bool isDarkMode;
  final String latitude;
  final String longitude;

  final int vagas_garagem;
  final String total_dormitorios;
  final String total_suites;
  Map<String, dynamic> caracteristicas;

  final int tipo_pagina;
  ImovelInfoComponent(
      this.nome_imovel,
      this.terreno,
      this.location,
      this.originalPrice,
      this.urlsImage,
      this.isDarkMode,
      this.codigo,
      this.area_total,
      this.link,
      this.vagas_garagem,
      this.total_dormitorios,
      this.total_suites,
      this.latitude,
      this.longitude,
      this.tipo_pagina,
      this.caracteristicas);

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

    double latitude = double.tryParse(widget.latitude) ?? 0;
    double longitude = double.tryParse(widget.longitude) ?? 0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                  color: widget.isDarkMode ? Colors.black : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10), // Borda arredondada
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
                                                '${widget.nome_imovel.substring(0, widget.nome_imovel.indexOf('Cód'))}',
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
                                            text:
                                                '${widget.nome_imovel.substring(widget.nome_imovel.indexOf('Cód') + 3)}',
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
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${widget.location}',
                                  style:
                                      TextStyle(fontSize: 15, color: textColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinhar os elementos no topo
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
                              items: widget.urlsImage.map((url) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: widget.tipo_pagina == 0 ? 450 : 250,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height:
                                                          MediaQuery.of(context)
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
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.of(context)
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
                                  icon: Icon(Icons.arrow_back, color: textColor),
                                  onPressed: () {
                                    if (_currentIndex > 0) {
                                      _carouselController.previousPage();
                                    }
                                  },
                                ),
                                Text(
                                  '${_currentIndex + 1} / ${widget.urlsImage.length}',
                                  style: TextStyle(color: textColor),
                                ),
                                IconButton(
                                  icon:
                                      Icon(Icons.arrow_forward, color: textColor),
                                  onPressed: () {
                                    if (_currentIndex <
                                        widget.urlsImage.length - 1) {
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
                      ImovelCaracteristicasWidget(
                        caracteristicas: widget.caracteristicas,
                        isDarkMode: widget.isDarkMode,
                      ),
                  ],
                ),
                if (widget.tipo_pagina == 1)
                  ImovelCaracteristicasWidget(
                    caracteristicas: widget.caracteristicas,
                    isDarkMode: widget.isDarkMode,
                  ),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: widget.isDarkMode ? Colors.white : Colors.black54,
                    ),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${widget.location}',
                        style: TextStyle(fontSize: 15, color: textColor),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${widget.originalPrice}',
                      style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Card(
                      color: widget.isDarkMode ? Colors.black54 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.bed,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                            SizedBox(width: 4),
                            Column(
                              children: [
                                SelectableText(
                                  '${widget.total_dormitorios}',
                                  style: TextStyle(
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                                SelectableText(
                                  'Suítes: ${widget.total_suites}',
                                  style: TextStyle(
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(), // Spacer para distribuir o espaço restante
                    Card(
                      color: widget.isDarkMode ? Colors.black54 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.garage,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                            SizedBox(width: 4),
                            SelectableText(
                              '${widget.vagas_garagem}',
                              style: TextStyle(
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          
                    Spacer(),
                    Card(
                      color: widget.isDarkMode ? Colors.black54 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.aspect_ratio,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                            SizedBox(width: 4),
                            SelectableText(
                              '${widget.area_total}',
                              style: TextStyle(
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      color: widget.isDarkMode ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: widget.isDarkMode ? Colors.black : Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude),
                      zoom: 15,
                    ),
                    onMapCreated: (controller) => mapController = controller,
                    onTap: (LatLng latLng) {
                      // Lógica para lidar com o toque no mapa (opcional)
                    },
                    markers: Set<Marker>.of(
                      // Usando Set para garantir que os marcadores sejam únicos
                      [
                        Marker(
                          markerId: MarkerId(widget.nome_imovel),
                          position: LatLng(latitude, longitude),
                          infoWindow: InfoWindow(title: widget.nome_imovel),
                          onTap: () {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                          _launchURL(widget.link);
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
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
