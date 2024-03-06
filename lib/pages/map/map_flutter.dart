import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import '../../components/custom_menu.dart';
import '../../components/imovel/imovel_info_component.dart';
import '../../util/app_bar_model.dart';

class MapPageFlutter extends StatefulWidget {
  @override
  _MapPageFlutterState createState() => _MapPageFlutterState();
}

class _MapPageFlutterState extends State<MapPageFlutter> {
  late List<NewImovel> loadedProducts = [];
  late List<NewImovel> filteredProducts = [];
  late List<Marker> filteredMarkers = [];
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

  late List<Marker> markers;
  final PopupController _popupController = PopupController();

  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final provider = Provider.of<NewImovelList>(context, listen: false);
      loadedProducts = provider.items;

      List<NewImovel> filteredProducts = loadedProducts
          .where((imovel) => imovel.localizacao['latitude'] != "N/A" && imovel.localizacao['longitude'] != "N/A" )
          .toList();

      filteredMarkers = filteredProducts.take(50).map((imovel) {
        double latitude =
            double.tryParse(imovel.localizacao['latitude']) ?? 0.0;
        double longitude =
            double.tryParse(imovel.localizacao['longitude']) ?? 0.0;
        return Marker(
          point: LatLng(latitude, longitude),
          width: 40,
          height: 40,
          builder: (context) => GestureDetector(
            onTap: () {
              setState(() {
                urlsImage = [];
                showInfoScreen = true;
                selectedMarkerTitle = imovel.detalhes['nome_imovel'] ?? "";
                selectedMarkerTerreno = imovel.detalhes['terreno'] ?? "";
                selectedMarkerLocation = imovel.localizacao['endereco']
                            ['logradouro'] +
                        ', ' +
                        imovel.localizacao['endereco']['logradouro'] +
                        ' - ' +
                        imovel.localizacao['endereco']['cidade'] +
                        '/' +
                        imovel.localizacao['endereco']['estado'] ??
                    "";
                selectedMarkerOrigalPrice =
                    imovel.preco['preco_original'] ?? "";
                urlsImage.addAll(imovel.imagens?.cast<String>() ?? []);

                selectedMarkerCodigo = imovel.id ?? "";
                selectedMarkerAreaTotal = imovel.detalhes['area_total'] ?? "";
                selectedMarkerLink = imovel.link_imovel ?? "";

                // Convertendo para int ou mantendo 0 se for nulo ou não puder ser convertido
                selectedVagasgaragem =
                    int.tryParse(imovel.detalhes['vagas_garagem'] ?? "") ?? 0;

                selectedTotaldormitorios =
                    imovel.detalhes['total_dormitorios'] ?? "";
                selectedTotalsuites = imovel.detalhes['area_total'] ?? "";

                selectedMarkerLongitude = imovel.localizacao['longitude'] ?? "";
                selectedMarkerLatitude = imovel.localizacao['latitude'] ?? "";
                selectedCaracteristicas = imovel.caracteristicas ?? {};
              });
            },
            child: Icon(
              Icons.location_on,
              size: 40,
              color: Color.fromARGB(255, 255, 17, 0),
            ),
          ),
        );
      }).toList();

      setState(() {
        markers = filteredMarkers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    
    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              subtitle: "",
              title: "Localização dos imóveis",
              isDarkMode: isDarkMode,
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          if (!isSmallScreen) CustomMenu(isDarkMode: isDarkMode),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 150,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Filtros',
                          style: TextStyle(
                            color: Color(0xFF6e58e9),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: true, // Defina o valor inicial do primeiro checkbox
                              onChanged: (value) {
                                // Implemente a lógica de mudança do estado do checkbox
                              },
                            ),
                            Text('Checkbox 1'),
                          ],
                        ),
                      ),
                      Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: false, // Defina o valor inicial do primeiro checkbox
                                onChanged: (value) {
                                  // Implemente a lógica de mudança do estado do checkbox
                                },
                              ),
                              Text('Checkbox 1'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: false, // Defina o valor inicial do segundo checkbox
                                onChanged: (value) {
                                  // Implemente a lógica de mudança do estado do checkbox
                                },
                              ),
                              Text('Checkbox 2'),
                            ],
                          ),
                        ],
                      ),
                    ),
                      Expanded(
                        child: SizedBox(), // Coluna vazia para manter a distribuição igual
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          center: LatLng(-28.25977676240336, -52.45321612830699),
                          zoom: 13.0,
                        ),
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
                              markers: markers ?? [],
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
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          color: Colors.white,
                          child: showInfoScreen
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showInfoScreen = false;
                                    });
                                  },
                                  child: ImovelInfoComponent(
                                    selectedMarkerTitle, // Título do imóvel
                                    selectedMarkerTerreno, // Terreno do imóvel
                                    selectedMarkerLocation, // Localização do imóvel
                                    selectedMarkerOrigalPrice, // Preço original do imóvel
                                    urlsImage, // URLs das imagens do imóvel
                                    isDarkMode,
                                    selectedMarkerCodigo,
                                    selectedMarkerAreaTotal,
                                    selectedMarkerLink,
                                    selectedVagasgaragem,
                                    selectedTotaldormitorios,
                                    selectedTotalsuites,
                                    selectedMarkerLatitude,
                                    selectedMarkerLongitude,
                                    1,
                                    selectedCaracteristicas,
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
                                              color: Color(0xFF6e58e9),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: Color(0xFF6e58e9),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: filteredMarkers.length,
                                          itemBuilder: (context, index) {
                                            List<NewImovel> filteredProducts =
                                                loadedProducts
                                                    .where((imovel) =>
                                                        imovel.localizacao[
                                                                'latitude'] !=
                                                            "N/A" &&
                                                        imovel.localizacao[
                                                                'longitude'] !=
                                                            "N/A")
                                                    .toList();
                                            final marker =
                                                filteredProducts[index];
                                            String title =
                                                marker.detalhes['nome_imovel']
                                                        .toString() ??
                                                    "";
                                            String link = marker.link_imovel ?? "";
                                            String id = marker.id ?? "";
                                            String terreno = marker
                                                .detalhes['terreno']
                                                .toString();
                                            String localizacao =
                                                marker.localizacao['endereco']
                                                            ['logradouro'] +
                                                        ', ' +
                                                        marker.localizacao[
                                                            'endereco']['logradouro'] +
                                                        ' - ' +
                                                        marker.localizacao[
                                                            'endereco']['cidade'] +
                                                        '/' +
                                                        marker.localizacao[
                                                            'endereco']['estado'] ??
                                                    "";
                                            String precoOriginal =
                                                marker.preco['preco_original']
                                                    .toString();
                                            String total_dormitorios =
                                                marker.detalhes['total_dormitorios']
                                                    .toString();
                                            List<String> imageUrls = [];
                                            imageUrls.addAll(
                                                marker.imagens.cast<String>());

                                            return ListTile(
                                               title: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [                                          
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              imageUrls.isNotEmpty ? imageUrls[0] : ''),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                    ),
                                                    SizedBox(width: 4), // Add some spacing between image and text
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            title,
                                                            style: TextStyle(
                                                              color: Color(0xFF6e58e9),
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          SizedBox(width: 4),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.place,
                                                                color: isDarkMode ? Colors.white : Colors.black54,
                                                              ),
                                                              SizedBox(width: 4),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Container(
                                                                  width: double.infinity,
                                                                  child: Text(
                                                                    localizacao.split('-').join('\n'),
                                                                    style: TextStyle(
                                                                      color: Color(0xFF6e58e9),
                                                                      fontSize: 12,
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis, // Define o comportamento de overflow
                                                                    maxLines: 2, // Define o número máximo de linhas
                                                                  ),
                                                                ),
                                                              ),
              
                                                            ],
                                                          ),
                                                          SizedBox(width: 4),
                                                            Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.bed,
                                                                color: isDarkMode
                                                                    ? Colors.white
                                                                    : Colors.black54,
                                                              ),
                                                              SizedBox(width: 4),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Container(
                                                                  width: double.infinity,
                                                                  child: Text(
                                                                    total_dormitorios,
                                                                    style: TextStyle(
                                                                      color: Color(0xFF6e58e9),
                                                                      fontSize: 12,
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis, // Define o comportamento de overflow
                                                                    maxLines: 2, // Define o número máximo de linhas
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),),
                                                            SizedBox(width: 4),
                                                            Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: Text(
                                                                precoOriginal != "N/A" ? precoOriginal : "Sem preço informado",
                                                                style: TextStyle(
                                                                  color: Color.fromARGB(207, 0, 0, 0),
                                                                  fontSize: precoOriginal != "N/A" ? 20 : 15,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImovelInfoComponent(
                                                      title,
                                                      terreno,
                                                      localizacao,
                                                      precoOriginal,
                                                      imageUrls,
                                                      isDarkMode,
                                                      marker.id ?? "",
                                                      marker.detalhes['area_total'] ??
                                                          "",
                                                      link,
                                                      int.tryParse(marker
                                                              .detalhes[
                                                                  'vagas_garagem'] ??
                                                          "") ??
                                                          0,
                                                      marker.detalhes[
                                                              'total_dormitorios'] ??
                                                          "",
                                                      marker.detalhes['area_total'] ??
                                                          "",
                                                      marker.localizacao['latitude'] ??
                                                          "",
                                                      marker.localizacao['longitude'] ??
                                                          "",
                                                      1,
                                                      marker.caracteristicas ?? {},
                                                    ),
                                                  ),
                                                );
                                              },
                                              tileColor: Colors.grey,
                                              selectedTileColor: Color(0xFF6e58e9),
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
                ),
              ],
            ),
          ),
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
