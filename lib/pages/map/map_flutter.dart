import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_list_map.dart';
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
  late ScrollController _scrollController;
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
  String _searchText = '';
  Map<String, dynamic> selectedCaracteristicas = {};
  late List<NewImovel> imoveisFiltrados;
  bool showFiltradas = false;
  NewImovel imovelAtual = NewImovel(
      id: '',
      detalhes: {},
      caracteristicas: {},
      localizacao: {},
      preco: {},
      link_imovel: '',
      link_virtual_tour: '',
      codigo_imobiliaria: '',
      data_cadastro: '',
      data: '',
      imagens: [],
      curtidas: '',
      finalidade: 0,
      tipo: 0,
      atualizacoes: {});
  late List<Marker> markers;
  final PopupController _popupController = PopupController();

  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final provider = Provider.of<NewImovelList>(context, listen: false);
      loadedProducts = provider.items;

      List<NewImovel> filteredProducts = loadedProducts
          .where((imovel) =>
              imovel.localizacao['latitude'] != "N/A" &&
              imovel.localizacao['longitude'] != "N/A")
          .toList();

      filteredMarkers = filteredProducts.map((imovel) {
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
                imovelAtual = NewImovel(
                    id: imovel.id,
                    detalhes: imovel.detalhes,
                    caracteristicas: imovel.caracteristicas,
                    localizacao: imovel.localizacao,
                    preco: imovel.preco,
                    link_imovel: imovel.link_imovel,
                    link_virtual_tour: imovel.link_imovel,
                    codigo_imobiliaria: imovel.codigo_imobiliaria,
                    data_cadastro: imovel.data_cadastro,
                    data: imovel.data,
                    imagens: imovel.imagens,
                    curtidas: imovel.curtidas,
                    finalidade: imovel.finalidade,
                    tipo: imovel.tipo,
                    atualizacoes: imovel.atualizacoes);
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

  void filtrarAluguel() {
    setState(() {
      imoveisFiltrados = [];
      imoveisFiltrados = loadedProducts.where((imovel) {
        final int finalidade = imovel.finalidade ?? 0;
        return finalidade == 1;
      }).toList();
    });
  }

  void filtrarCompra() {
    setState(() {
      imoveisFiltrados = [];
      imoveisFiltrados = loadedProducts.where((imovel) {
        final int finalidade = imovel.finalidade ?? 0;
        return finalidade == 0;
      }).toList();
    });
  }

  void filtrarTipo(int n) {
    print('object');
    setState(() {
      imoveisFiltrados = [];
      imoveisFiltrados = loadedProducts.where((imovel) {
        final int tipo = imovel.tipo ?? 0;
        return tipo == n;
      }).toList();
    });
    print(imoveisFiltrados);
  }

  void mostrarTodasEmbalagens() {
    setState(() {
      imoveisFiltrados = [];
      imoveisFiltrados = loadedProducts.where((imovel) {
        final int finalidade = imovel.finalidade ?? 0;
        return finalidade != null;
      }).toList();
    });
  }

  List<NewImovel> _filterProducts() {
    List<NewImovel> filteredProducts;
    if (_searchText.isNotEmpty) {
      filteredProducts = loadedProducts
          .where((imovel) =>
              imovel.id.toLowerCase().contains(loadedProducts as Pattern))
          .toList();
    } else {
      filteredProducts = showFiltradas ? imoveisFiltrados : loadedProducts;
    }
    print(filteredProducts);
    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
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
                        Text(
                          'Filtros',
                          style: TextStyle(
                            color: Color(0xFF6e58e9),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SingleChildScrollView(
                                            child: Container(
                                                child: Column(children: [
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              mostrarTodasEmbalagens();
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                'Mostrar todos os imoveis'),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10.0,
                                              backgroundColor:
                                                  Color(0xFF6e58e9),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 20.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              filtrarCompra();
                                              setState(() {
                                                showFiltradas = true;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child:
                                                Text('Mostrar imoveis a venda'),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10.0,
                                              backgroundColor:
                                                  Color(0xFF6e58e9),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 20.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              filtrarAluguel();
                                              setState(() {
                                                showFiltradas = true;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                'Mostrar imoveis para alugar'),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10.0,
                                              backgroundColor:
                                                  Color(0xFF6e58e9),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 20.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              filtrarTipo(0);
                                              setState(() {
                                                showFiltradas = true;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('Mostrar apartamentos'),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10.0,
                                              backgroundColor:
                                                  Color(0xFF6e58e9),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 20.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              filtrarTipo(1);
                                              setState(() {
                                                showFiltradas = true;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('Mostrar casas'),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10.0,
                                              backgroundColor:
                                                  Color(0xFF6e58e9),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 20.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              filtrarTipo(2);
                                              setState(() {
                                                showFiltradas = true;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('Mostrar terrenos'),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10.0,
                                              backgroundColor:
                                                  Color(0xFF6e58e9),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 20.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              filtrarTipo(3);
                                              setState(() {
                                                showFiltradas = true;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                'Mostrar imoveis comerciais'),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10.0,
                                              backgroundColor:
                                                  Color(0xFF6e58e9),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 20.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ])));
                                      });
                                },
                                child: Text("Filtros"),
                                style: ElevatedButton.styleFrom(
                                  elevation: 10.0,
                                  backgroundColor: Color(0xFF6e58e9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        FlutterMap(
                          options: MapOptions(
                              center: LatLng(
                                  -28.25977676240336, -52.45321612830699),
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
                                      isDarkMode,
                                      1,
                                      selectedCaracteristicas,
                                      imovelAtual,
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
                                              setState(() {
                                                _searchText = value;
                                              });
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
                                            controller: _scrollController,
                                            padding: const EdgeInsets.all(8),
                                            itemCount: _filterProducts().length,
                                            itemBuilder: (ctx, i) {
                                              return ChangeNotifierProvider
                                                  .value(
                                                value: _filterProducts()[i],
                                                child: ImovelListMap(
                                                    imovel:
                                                        _filterProducts()[i]),
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
      drawer: CustomMenu(),
    );
  }
}
