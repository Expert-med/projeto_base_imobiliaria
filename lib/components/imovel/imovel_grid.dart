import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';
import '../../models/imoveis/newImovel.dart';
import '../../theme/appthemestate.dart';
import 'imovel_item.dart';

class ImovelGrid extends StatefulWidget {
  final bool showFavoriteOnly;

  const ImovelGrid(this.showFavoriteOnly, {Key? key}) : super(key: key);

  @override
  _ImovelGridState createState() => _ImovelGridState();
}

class _ImovelGridState extends State<ImovelGrid> {
  late ScrollController _scrollController;
  late List<NewImovel> _loadedProducts;
  late List<NewImovel> imoveisFiltrados;
  bool showFiltradas = false;
  int _numberOfItemsToShow = 50;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadedProducts = [];
    _loadMoreItems();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    final provider = Provider.of<NewImovelList>(context, listen: false);
    final List<NewImovel> additionalProducts =
        provider.items.skip(_loadedProducts.length).take(50).toList();
    setState(() {
      _loadedProducts.addAll(additionalProducts);
    });
  }

  void filtrarAluguel() {
    setState(() {
      imoveisFiltrados = [];
      imoveisFiltrados = _loadedProducts.where((imovel) {
        final int finalidade = imovel.finalidade ?? 0;
        return finalidade == 1;
      }).toList();
    });
  }

  void filtrarCompra() {
    setState(() {
      imoveisFiltrados = [];
      imoveisFiltrados = _loadedProducts.where((imovel) {
        final int finalidade = imovel.finalidade ?? 0;
        return finalidade == 0;
      }).toList();
    });
  }

  void filtrarTipo(int n) {
    setState(() {
      imoveisFiltrados = [];
      imoveisFiltrados = _loadedProducts.where((imovel) {
        final int tipo = imovel.tipo ?? 0;
        return tipo == n;
      }).toList();
    });
  }

  void mostrarTodasEmbalagens() {
    setState(() {
      imoveisFiltrados = [];
      imoveisFiltrados = _loadedProducts.where((imovel) {
        final int finalidade = imovel.finalidade ?? 0;
        return finalidade != null;
      }).toList();
    });
  }

  List<NewImovel> _filterProducts() {
    List<NewImovel> filteredProducts;
    if (_searchText.isNotEmpty) {
      filteredProducts = _loadedProducts
          .where((imovel) =>
              imovel.id.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    } else {
      filteredProducts = showFiltradas ? imoveisFiltrados : _loadedProducts;
    }
    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Procurar',
                labelStyle: TextStyle(
                  color: Color(0xFF6e58e9),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF6e58e9),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xFF6e58e9), // Cor do contorno ao clicar
                  ),
                ),
                fillColor: themeNotifier.isDarkModeEnabled
                    ? Colors.grey[800]
                    : Colors.grey[200], // Cor do fundo
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
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
                          child: Text('Mostrar todos os imoveis'),
                          style: ElevatedButton.styleFrom(
                            elevation: 10.0,
                            backgroundColor: Color(0xFF6e58e9),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                          child: Text('Mostrar imoveis a venda'),
                          style: ElevatedButton.styleFrom(
                            elevation: 10.0,
                            backgroundColor: Color(0xFF6e58e9),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                          child: Text('Mostrar imoveis para alugar'),
                          style: ElevatedButton.styleFrom(
                            elevation: 10.0,
                            backgroundColor: Color(0xFF6e58e9),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                            backgroundColor: Color(0xFF6e58e9),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                            backgroundColor: Color(0xFF6e58e9),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                            backgroundColor: Color(0xFF6e58e9),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                          child: Text('Mostrar imoveis comerciais'),
                          style: ElevatedButton.styleFrom(
                            elevation: 10.0,
                            backgroundColor: Color(0xFF6e58e9),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: _filterProducts().length +
                  1, // Add 1 for the load more button
              itemBuilder: (ctx, i) {
                if (i == _filterProducts().length) {
                  return _buildLoadMoreButton();
                } else {
                  return ChangeNotifierProvider.value(
                    value: _filterProducts()[i],
                    child: ImovelItem( i,
                        _filterProducts().length, 0, (String productCode) {}),
                  );
                }
              },

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isSmallScreen ? 1 : 4,
                childAspectRatio: isSmallScreen ? 3 / 2 : 3 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: _loadMoreItems,
        child: Text('Carregar Mais'),
      ),
    );
  }
}
