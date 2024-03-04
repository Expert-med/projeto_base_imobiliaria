import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import '../../components/custom_menu.dart';
import '../../components/imovel/imovel_info_component.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isDarkMode = false;
  late GoogleMapController mapController;
  late List<NewImovel> loadedProducts = [];
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

  int selectedVagasgaragem = 0;
  String selectedTotaldormitorios = '';
  String selectedTotalsuites = '';
  String selectedMarkerLongitude = '';
  String selectedMarkerLatitude = '';
  Map<String, dynamic>  selectedCaracteristicas ={};

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<NewImovelList>(context, listen: false);
    loadedProducts = provider.items;

    filteredMarkers = loadedProducts
        .take(50) // Pegue apenas os 50 primeiros itens
        .map((imovel) {
      // Criando um marcador para cada imóvel
      double latitude = double.tryParse(imovel.localizacao['latitude']) ?? 0.0;
      double longitude = double.tryParse(imovel.localizacao['longitude']) ?? 0.0;

      return Marker(
        markerId: MarkerId(imovel.detalhes['nome_imovel'] ?? ""),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: imovel.detalhes['nome_imovel'] ?? ""),
        onTap: () {
          setState(() {
            urlsImage = [];
            showInfoScreen = true;
            selectedMarkerTitle = imovel.detalhes['nome_imovel'] ?? "";
            selectedMarkerTerreno = imovel.detalhes['terreno'] ?? "";
            selectedMarkerLocation =  imovel.localizacao['endereco']['logradouro'] + ', '+ imovel.localizacao['endereco']['logradouro'] + ' - '+ imovel.localizacao['endereco']['cidade']+'/'+imovel.localizacao['endereco']['uf'] ?? ""; 
            selectedMarkerOrigalPrice = imovel.detalhes['preco_original'] ?? "";


            selectedMarkerCodigo = imovel.id;
            selectedMarkerAreaTotal = imovel.detalhes['area_total'] ?? "";
            selectedMarkerLink = imovel.link_imovel;
            selectedVagasgaragem = imovel.detalhes['vagas_garagem'] ?? "";
            selectedTotaldormitorios = imovel.detalhes['total_dormitorios'] ?? "";
            selectedTotalsuites = imovel.detalhes['area_total'] ?? "";

            selectedMarkerLongitude = imovel.localizacao['longitude'] ?? "";
            selectedMarkerLatitude = imovel.localizacao['latitude'] ?? "";
            selectedCaracteristicas = imovel.caracteristicas ?? {};
          });
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen ?CustomAppBar(
        subtitle: "",
        title: "Localização dos imóveis",
        isDarkMode: isDarkMode,
      ) : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (!isSmallScreen) CustomMenu(isDarkMode: isDarkMode),
            Expanded(child: Stack(
        children: [
          GoogleMap(
            scrollGesturesEnabled: true,
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
            markers: Set<Marker>.of(filteredMarkers),
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
                          selectedVagasgaragem,
                          selectedTotaldormitorios,
                          selectedTotalsuites,
                          selectedMarkerLatitude,
                          selectedMarkerLongitude,1,
                          selectedCaracteristicas),
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
                                String title = marker.detalhes['nome_imovel'].toString() ?? "";
                                String terreno = marker.detalhes
                                        ['terreno']
                                    .toString();
                                String localizacao =  marker.localizacao['endereco']['logradouro'] + ', '+ marker.localizacao['endereco']['logradouro'] + ' - '+ marker.localizacao['endereco']['cidade']+'/'+marker.localizacao['endereco']['uf'] ?? "";
                           
                                String precoOriginal = marker.detalhes
                                        ['preco_original']
                                    .toString();
                                List<String> imageUrls = [];
                                imageUrls.addAll(marker.
                                        imagens
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
                                            selectedVagasgaragem,
                                            selectedTotaldormitorios,
                                            selectedTotalsuites,
                                            selectedMarkerLatitude,
                                            selectedMarkerLongitude,1,
                                            selectedCaracteristicas),
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
      ),)
          ],
        );
      }),
      drawer: CustomMenu(isDarkMode: false),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 40.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              isDarkMode = !isDarkMode; // Alterna o valor de isDarkMode
            });
          },
          child: Icon(Icons.lightbulb),
        ),
      ),
    );
  }
}
