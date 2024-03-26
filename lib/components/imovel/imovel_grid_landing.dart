import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';
import '../../models/imoveis/newImovel.dart';
import '../../theme/appthemestate.dart';
import 'buscaImoveis.dart';
import 'imovel_item.dart';

class GridLanding extends StatefulWidget {
  final String nome;
  final bool showFavoriteOnly;
  

  const GridLanding({
    required this.nome,
    required this.showFavoriteOnly,
    Key? key,
  }) : super(key: key);

  @override
  _GridLandingState createState() => _GridLandingState();
}


class _GridLandingState extends State<GridLanding> {
  late ScrollController _scrollController;
  late List<NewImovel> _loadedProducts;
  late List<NewImovel> imoveisFiltrados;
  bool showFiltradas = false;
  int _numberOfItemsToShow = 50;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  late bool checkInFocused;
  late bool checkOutFocused;
  late bool guestsFocused;
  String selectedTipo = ''; 
  String selectedFin = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadedProducts = [];
    _loadMoreItems();
    _scrollController.addListener(_scrollListener);
    imoveisFiltrados = [];
    checkInFocused = false;
    checkOutFocused = false;
    guestsFocused = false;
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

 void _loadMoreItems() async {
  final provider = Provider.of<NewImovelList>(context, listen: false);
  final additionalProducts = await provider.buscarImoveisLanding(widget.nome); // Chame a função do provedor para carregar mais itens
  setState(() {
    _loadedProducts.addAll(additionalProducts);
  });
}


  void filtrarAluguel() {
  showFiltradas = true;
  setState(() {
    imoveisFiltrados = [];
    imoveisFiltrados = _loadedProducts.where((imovel) {
      final int finalidade = imovel.finalidade ?? 0;
      return finalidade == 1;
    }).toList();
  });
}

void filtrarCompra() {
  print('Filtrando imóveis para compra');
  setState(() {
    showFiltradas = true;
    imoveisFiltrados = [];
    imoveisFiltrados = _loadedProducts.where((imovel) {
      final int finalidade = imovel.finalidade ?? 0;
      return finalidade == 0;
    }).toList();
  });
}

void filtrarTipo(int n) {
  print('Filtrando imóveis pelo tipo $n');
  setState(() {
    showFiltradas = true;
    imoveisFiltrados.addAll(_loadedProducts.where((imovel) {
      final int tipo = imovel.tipo ?? 0;
      return tipo == n;
    }).toList());
  });
}

void mostrarTodasEmbalagens() {
  print('Mostrando todos os imóveis');
  setState(() {
    showFiltradas = false;
    imoveisFiltrados = [];
    imoveisFiltrados = _loadedProducts.where((imovel) {
      final int finalidade = imovel.finalidade ?? 0;
      return finalidade != null;
    }).toList();
  });
}

  List<NewImovel> _filterProducts() {
    List<NewImovel> filteredProducts = _loadedProducts;

    // Aplicar filtro por texto de busca
    if (_searchText.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((imovel) =>
              imovel.id.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }

    // Aplicar filtro por finalidade
    if (selectedFin != null) {
      final int finalidadeValue = selectedFin == 'Compra' ? 0 : 1;
      filteredProducts = filteredProducts
          .where((imovel) => imovel.finalidade == finalidadeValue)
          .toList();
    }

    // Aplicar filtro por tipo
    if (selectedTipo.isNotEmpty) {
      int tipoValue;
      switch (selectedTipo) {
        case 'Casa':
          tipoValue = 0;
          break;
        case 'Apartamento':
          tipoValue = 1;
          break;
        case 'Terreno':
          tipoValue = 2;
          break;
        case 'Comercial':
          tipoValue = 3;
          break;
        default:
          tipoValue = -1;
          break;
      }
      if (tipoValue != -1) {
        filteredProducts = filteredProducts
            .where((imovel) => imovel.tipo == tipoValue)
            .toList();
      }
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
          Center(
            child: Container(
              margin: EdgeInsets.all(40),
              height: 70,
              width: 1000,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 20,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildTipoTextField(),
                  _buildExpandedTextField(
                    hintText: 'Preço máximo',
                    isFocused: checkOutFocused,
                    onTap: () {
                      setState(() {
                        checkInFocused = false;
                        checkOutFocused = true;
                        guestsFocused = false;
                      });
                    },
                  ),
                  _buildFinalidadeTextField(),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: _filterProducts().length +
                  1, 
              itemBuilder: (ctx, i) {
                if (i == _filterProducts().length) {
                  return _buildLoadMoreButton();
                } else {
                  return ChangeNotifierProvider.value(
                    value: _filterProducts()[i],
                    child: ImovelItem(1, i,
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
   Widget _buildFilterButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          elevation: 10.0,
          backgroundColor: Color(0xFF6e58e9),
          padding: EdgeInsets.symmetric(horizontal: 20.0,   vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
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

  Widget _buildExpandedTextField({
    required String hintText,
    required bool isFocused,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: isFocused ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: TextField(
            onTap: onTap,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildTipoTextField() {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: checkInFocused ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: PopupMenuButton<String>(
          initialValue: selectedTipo,
          onSelected: (value) {
            setState(() {
              selectedTipo = value;
              checkInFocused = true;
              checkOutFocused = false;
              guestsFocused = false;
            });
          },
          offset: Offset(0, 70), // Ajuste o deslocamento vertical conforme necessário
          itemBuilder: (BuildContext context) {
            return ['Casa', 'Apartamento', 'Terreno', 'Comercial']
                .map<PopupMenuItem<String>>((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: SizedBox( // Defina um tamanho fixo para os itens do menu
                  width: 200, // Largura desejada para os itens do menu
                  child: Text(value),
                ),     
              );
            }).toList();
          },
          child: ListTile(
            title: Text(
              selectedTipo.isNotEmpty ? selectedTipo : 'Tipo de imóvel',
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ),
    ),
  );
}
 Widget _buildFinalidadeTextField() {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: checkInFocused ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: PopupMenuButton<String>(
          initialValue: selectedFin,
          onSelected: (value) {
            setState(() {
              selectedFin = value;
              checkInFocused = true;
              checkOutFocused = false;
              guestsFocused = false;
            });
          },
          offset: Offset(0, 70), // Ajuste o deslocamento vertical conforme necessário
          itemBuilder: (BuildContext context) {
            return ['Compra', 'Aluguel']
                .map<PopupMenuItem<String>>((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: SizedBox( // Defina um tamanho fixo para os itens do menu
                  width: 200, // Largura desejada para os itens do menu
                  child: Text(value),
                ),     
              );
            }).toList();
          },
          child: ListTile(
            title: Text(
              selectedFin.isNotEmpty ? selectedFin : 'Finalidade',
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ),
    ),
  );
}
}