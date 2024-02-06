import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:projeto_imobiliaria/models/app_bar_model.dart';

import 'drawer_page.dart';

void main() => runApp(MapSearchPage());

class MapSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;

  List<Marker> markers = [
    Marker(
      markerId: MarkerId('HSVP'),
      position: LatLng(-28.25977676240336, -52.41321612830699),
      infoWindow: InfoWindow(title: 'HSVP'),
    ),
    Marker(
      markerId: MarkerId('HO'),
      position: LatLng(-28.25648077106535, -52.41755420018248),
      infoWindow: InfoWindow(title: 'HO'),
    ),
    Marker(
      markerId: MarkerId('HC'),
      position: LatLng(-28.256042209828635, -52.4030390115612),
      infoWindow: InfoWindow(title: 'HC'),
    ),
    Marker(
      markerId: MarkerId('EXPERT MED'),
      position: LatLng(-28.25812004525615, -52.41185560014869),
      infoWindow: InfoWindow(title: 'EXPERTMED'),
    ),
  ];

  List<Marker> filteredMarkers = [];

  bool showInfoScreen = false;
  String selectedMarkerTitle = '';

  late Marker tappedMarker;

  @override
  void initState() {
    // Inicialize a lista filtrada com todos os marcadores no início
    filteredMarkers = markers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          subtitle: "Localização dos hospitais", title: "MAPA EXPERTMED"),
      body: Stack(
        children: [
          // Mapa ocupando 70% da tela
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-28.25977676240336, -52.41321612830699),
              zoom: 15,
            ),
            onMapCreated: (controller) => mapController = controller,
            onTap: (LatLng latLng) {
              // Fechar a InfoScreen se estiver aberta
              setState(() {
                showInfoScreen = false;
              });
            },
            markers: filteredMarkers.map(
              (marker) => Marker(
                markerId: marker.markerId,
                position: marker.position,
                infoWindow: marker.infoWindow,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), 
                onTap: () {
                  // Armazenar o marcador clicado
                  tappedMarker = marker;
                  // Ao tocar no marcador, exibir a InfoScreen
                  setState(() {
                    showInfoScreen = true;
                    selectedMarkerTitle = marker.infoWindow.title as String;
                  });
                },
              ),
            ).toSet(),
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
                      child: InfoScreen(selectedMarkerTitle),
                    )
                  : GestureDetector(
                      onTap: () {
                        // Adicione essa parte para fechar a InfoScreen se ela estiver aberta
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
                                  filteredMarkers = markers
                                      .where((marker) =>
                                          marker.infoWindow.title
                                              .toString()
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                      .toList();
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
                            child: GestureDetector(
                              behavior: HitTestBehavior.deferToChild,
                              onTap: () {
                                // Adicione essa parte para fechar a InfoScreen se ela estiver aberta
                                setState(() {
                                  showInfoScreen = false;
                                });
                              },
                              child: ListView.builder(
                                itemCount: filteredMarkers.length,
                                itemBuilder: (context, index) {
                                  final marker = filteredMarkers[index];
                                  return ListTile(
                                    title: Text(marker.infoWindow.title as String),
                                    onTap: () {
                                      setState(() {
                                        showInfoScreen = true;
                                        selectedMarkerTitle =
                                            marker.infoWindow.title as String;
                                      });
                                    },
                                    tileColor: Colors.grey,
                                    selectedTileColor: Colors.grey,
                                  );
                                },
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
      drawer: DrawerPage(isDarkMode: false),
    );
  }
}

class InfoScreen extends StatelessWidget {
  final String title;

  InfoScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        backgroundColor: Color(0xFF466B50),
      ),
      body: Center(
        child: Text('Informações sobre $title'),
      ),
    );
  }
}
