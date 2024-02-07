import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:projeto_imobiliaria/models/app_bar_model.dart';
import 'package:projeto_imobiliaria/models/houses/imovel.dart';
import '../../models/houses/imovelList.dart';
import '../drawer_page.dart';
import 'map_info_page.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  List<Marker> filteredMarkers = [];
  bool showInfoScreen = false;
  String selectedMarkerTitle = '';

@override
  void initState() {
    super.initState();

    final provider = Provider.of<ImovelList>(context, listen: false);
    final List<Imovel> loadedProducts = provider.items;

    // Criar marcadores usando os dados dos produtos
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
                    showInfoScreen = true;
                    selectedMarkerTitle = info['nome_imovel'].toString();
                  });
                },
              );
            }))
        .toList();
  }


  @override
  Widget build(BuildContext context) {
 

    return Scaffold(
      appBar: CustomAppBar(
        subtitle: "Localização dos hospitais",
        title: "MAPA EXPERTMED",
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
                      child: InfoMapPage(selectedMarkerTitle),
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
                                setState(() {
                                  
                                });
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
                                final marker = filteredMarkers[index];
                                return ListTile(
                                  title: Text(marker.infoWindow.title ?? '',style: TextStyle(color: Colors.black),),
                                  onTap: () {
                                    setState(() {
                                      showInfoScreen = true;
                                      selectedMarkerTitle =
                                          marker.infoWindow.title ?? '';
                                    });
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
      drawer: DrawerPage(isDarkMode: false),
    );
  }
}
