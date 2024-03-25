import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import '../../theme/appthemestate.dart';
import 'buscaImoveis.dart';
import 'imovel_item.dart';
import 'imovel_item_sem_barra.dart';

class FavoriteImoveisGrid extends StatefulWidget {
  final bool showFavoriteOnly;
  final List<String> idsToShow; 

  const FavoriteImoveisGrid(this.showFavoriteOnly, this.idsToShow, {Key? key})
      : super(key: key);

  @override
  _FavoriteImoveisGridState createState() => _FavoriteImoveisGridState();
}

class _FavoriteImoveisGridState extends State<FavoriteImoveisGrid> {

  late List<NewImovel> _loadedProducts;
  late List<NewImovel> imoveisFiltrados;
  bool showFiltradas = false;
  int _numberOfItemsToShow = 50;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();

     _loadedProducts = Provider.of<NewImovelList>(context, listen: false)
        .items
        .where((imovel) => widget.idsToShow.contains(imovel.id))
        .toList();
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
  void dispose() {
    super.dispose();
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
          BuscaImoveis(),
          Expanded(
            child: GridView.builder(
           
              padding: const EdgeInsets.all(10),
              itemCount: _filterProducts().length +
                  1,
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
        onPressed:(){
          final currentRoute = Get.currentRoute; 
          Get.toNamed('$currentRoute/imoveis');
        },
        child: Text('Ver todos os imoveis'),
      ),
    );
  }
}
