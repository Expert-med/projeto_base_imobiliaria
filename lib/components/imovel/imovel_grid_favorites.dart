import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import '../../theme/appthemestate.dart';
import 'imovel_item.dart';
import 'imovel_item_sem_barra.dart';

class FavoriteImoveisGrid extends StatefulWidget {
  final bool showFavoriteOnly;
  final List<String> idsToShow; // Lista de IDs para exibir

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
          Expanded(
            child: GridView.builder(
           
              padding: const EdgeInsets.all(10),
              itemCount: _loadedProducts.length,
              itemBuilder: (ctx, i) {
                return ChangeNotifierProvider.value(
                  value: _loadedProducts[i],
                  child: ImovelItem(
                      i, _loadedProducts.length, 0, (String productCode) {}),
                );
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
}
