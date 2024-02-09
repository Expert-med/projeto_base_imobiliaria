import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:projeto_imobiliaria/models/imoveis/imovel.dart';
import '../../components/custom_menu.dart';
import '../../models/imoveis/imovelList.dart';
import '../../components/imovel/imovel_info_component.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isDarkMode = false;
  late GoogleMapController mapController;
  late List<Imovel> loadedProducts = [];
  List<Marker> filteredMarkers = [];
  bool showInfoScreen = false;
  String selectedMarkerTitle = '';
  String selectedMarkerTerreno = '';
  String selectedMarkerLocation = '';
  String selectedMarkerOrigalPrice = '';
  List<String> urlsImage = [];
  String selectedMarkerCodigo = '';
  String selectedMarkerAreaTotal = '';
  String selectedMarkerLink = '';

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<ImovelList>(context, listen: false);
    loadedProducts = provider.items;

    filteredMarkers = loadedProducts
        .take(50) // Pegue apenas os 50 primeiros itens
        .expand((imovel) => imovel.infoList.map((info) {
              // Parse latitude and longitude only if they are valid doubles
              double latitude = double.tryParse(info['latitude']) ?? 0.0;
              double longitude = double.tryParse(info['longitude']) ?? 0.0;

              return Marker(
                markerId: MarkerId(info['nome_imovel']),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(title: info['nome_imovel'].toString()),
                onTap: () {
                  setState(() {
                    urlsImage = [];
                    showInfoScreen = true;
                    selectedMarkerTitle = info['nome_imovel'].toString();
                    selectedMarkerTerreno = info['terreno'].toString();
                    selectedMarkerLocation = info['localizacao'].toString();
                    selectedMarkerOrigalPrice =
                        info['preco_original'].toString();
                    // Convertendo para Iterable<String> antes de adicionar à lista
                    urlsImage.addAll(info['image_urls'].cast<String>());

                    selectedMarkerCodigo = imovel.codigo;
                    selectedMarkerAreaTotal = info['area_total'].toString();
                    selectedMarkerLink = imovel.link;
                  });
                },
              );
            }))
        .toList();
  }

  @override
  Widget build(BuildContext context) {

    bool isSmallScreen = MediaQuery.of(context).size.width < 900;


    return Scaffold(
      appBar: CustomAppBar(
        subtitle: "Localização dos hospitais",
        title: "MAPA EXPERTMED",
        isDarkMode: isDarkMode,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-28.25977676240336, -52.41321612830699),
              zoom: 15,
            ),
            onMapCreated: (controller) => mapController = controller,
            onTap: (LatLng latLng) {
              setState(() {
                showInfoScreen = false;
              });
            },
            markers: filteredMarkers.toSet(),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              color: Colors.white,
              child: showInfoScreen
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          showInfoScreen = false;
                        });
                      },
                      child: ImovelInfoComponent(
                        selectedMarkerTitle,
                        selectedMarkerTerreno,
                        selectedMarkerLocation,
                        selectedMarkerOrigalPrice,
                        urlsImage,
                        isDarkMode,
                        selectedMarkerCodigo,
                        selectedMarkerAreaTotal,
                        selectedMarkerLink,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          showInfoScreen = false;
                        });
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Pesquisar',
                                labelStyle: TextStyle(
                                  color: Color(0xFF466B66),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF466B66),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredMarkers.length,
                              itemBuilder: (context, index) {
                                final marker = loadedProducts[index];
                                // Acessando as informações do marcador diretamente
                                String title = marker.infoList[index]
                                        ['nome_imovel']
                                    .toString();
                                String terreno = marker.infoList[index]
                                        ['terreno']
                                    .toString();
                                String localizacao = marker.infoList[index]
                                        ['localizacao']
                                    .toString();
                                String precoOriginal = marker.infoList[index]
                                        ['preco_original']
                                    .toString();
                                List<String> imageUrls = [];
                                imageUrls.addAll(marker.infoList[index]
                                        ['image_urls']
                                    .cast<String>());
                                return ListTile(
                                  title: Text(
                                    title,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImovelInfoComponent(
                                          title, // Título do imóvel
                                          terreno, // Terreno do imóvel
                                          localizacao, // Localização do imóvel
                                          precoOriginal, // Preço original do imóvel
                                          imageUrls, // URLs das imagens do imóvel
                                          isDarkMode,
                                          selectedMarkerCodigo,
                                          selectedMarkerAreaTotal,
                                          selectedMarkerLink,
                                        ),
                                      ),
                                    );
                                  },
                                  tileColor: Colors.grey,
                                  selectedTileColor: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
      drawer: CustomMenu(isDarkMode: false),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDarkMode = !isDarkMode; // Alterna o valor de isDarkMode
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
