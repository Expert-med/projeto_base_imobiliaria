import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/imoveis/imovel.dart';
import '../../models/imoveis/imovelList.dart';

class MapPageFlutter extends StatefulWidget {
  @override
  _MapPageFlutterState createState() => _MapPageFlutterState();
}

class _MapPageFlutterState extends State<MapPageFlutter> {
  final PopupController _popupController = PopupController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Demo'),
      ),
      body: MapWidget(
        popupController: _popupController,
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  final PopupController popupController;

  MapWidget({required this.popupController});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late List<Imovel> loadedProducts = [];
  List<Marker> filteredMarkers = [];

  @override
  void initState() {
    final provider = Provider.of<ImovelList>(context, listen: false);
    loadedProducts = provider.items;

    super.initState();
  

  // final List<Marker> _todosMakers = loadedProducts
  //     .take(50) // Pegue apenas os 50 primeiros itens
  //     .expand((imovel) => imovel.infoList.map((info) {
  //           // Parse latitude and longitude only if they are valid doubles
  //           double latitude = double.tryParse(info['latitude']) ?? 0.0;
  //           double longitude = double.tryParse(info['longitude']) ?? 0.0;

  //           return Marker(
  //             width: 40,
  //             height: 40,
  //             point: LatLng(latitude, longitude),
  //             builder: (ctx) => Container(
  //               child: Column(
  //                 children: [
  //                   Icon(
  //                     Icons.location_on,
  //                     size: 40,
  //                     color: Colors.black,
  //                   ),
  //                   Text(
  //                     '${info['nome_imovel']}',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ],
  //               ),
  //             ),
              
  //           );
  //         }))
  //     .toList();

 
  }

   final List<Marker> _markers = [
    Marker(
      width: 40,
      height: 40,
      point: LatLng(-28.25977676240336, -52.41321612830699),
      builder: (ctx) => Container(
        child: Column(
          children: [
            Icon(
              Icons.location_on,
              size: 40,
              color: Colors.black,
            ),
            Text(
              '<--',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
    Marker(
      width: 40,
      height: 40,
      point: LatLng(-50.25977676240336, -120.41321612830699),
      builder: (ctx) => Container(
        child: Column(
          children: [
            Icon(
              Icons.location_on,
              size: 40,
              color: Colors.black,
            ),
            Text(
              '<--',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
    Marker(
      width: 40,
      height: 40,
      point: LatLng(-20.25977676240336, -50.41321612830699),
      builder: (ctx) => Container(
        child: Column(
          children: [
            Icon(
              Icons.location_on,
              size: 40,
              color: Colors.black,
            ),
            Text(
              '<--',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(-28.25977676240336, -52.41321612830699),
        zoom: 12.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: _markers,
        ),
        PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
            markers: _markers,
            popupDisplayOptions: PopupDisplayOptions(
              builder: (BuildContext context, Marker marker) =>
                  ExamplePopup(marker),
            ),
          ),
        ),
      ],
    );
  }
}

class ExamplePopup extends StatelessWidget {
  final Marker marker;

  ExamplePopup(this.marker);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Text(
        'Nome do Marcador',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
