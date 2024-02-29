import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import 'imovel_item.dart';
import 'imovel_item_sem_barra.dart';

class FavoriteImoveisGrid extends StatefulWidget {
  final bool isDarkMode;
  final bool showFavoriteOnly;
  final List<String> idsToShow; // Lista de IDs para exibir

  const FavoriteImoveisGrid(
      this.showFavoriteOnly, this.isDarkMode, this.idsToShow,
      {Key? key})
      : super(key: key);

  @override
  _FavoriteImoveisGridState createState() => _FavoriteImoveisGridState();
}

class _FavoriteImoveisGridState extends State<FavoriteImoveisGrid> {
  late ScrollController _scrollController;
  late List<NewImovel> _loadedProducts;
  int _numberOfItemsToShow = 50;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  void removeFromIdsToShow(String productCode) {
    setState(() {
      _loadedProducts = [];

      widget.idsToShow.remove(productCode);
      _loadMoreItems();
    });
  }

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
    print("widget: ${widget.idsToShow}");
  }

  List<NewImovel> _filterProducts() {
    if (_searchText.isEmpty) {
      return _loadedProducts
          .where((imovel) => widget.idsToShow.contains(imovel.id))
          .toList();
    } else {
      return _loadedProducts
          .where((imovel) =>
              imovel.id.toLowerCase().contains(_searchText.toLowerCase()) &&
              widget.idsToShow.contains(imovel.id))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(10),
            itemCount:
                _filterProducts().length, // Add 1 for the load more button
            itemBuilder: (ctx, i) {
              return ChangeNotifierProvider.value(
                value: _filterProducts()[i],
                child: ImovelItemSemBarra(
                  widget.isDarkMode,
                  i,
                  _filterProducts().length,
                  0,
                  (String productCode) {
                    setState(() {
                      // Remove o código do produto da lista idsToShow
                      removeFromIdsToShow(productCode);
                    });
                  },
                ),
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
    );
  }
}
