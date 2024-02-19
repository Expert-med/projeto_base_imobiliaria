import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/imoveis/imovel.dart';
import '../../models/imoveis/imovelList.dart';
import 'imovel_item.dart';

class FavoriteImoveisGrid extends StatefulWidget {
  final bool isDarkMode;
  final bool showFavoriteOnly;
  final List<String> idsToShow; // Lista de IDs para exibir

  const FavoriteImoveisGrid(this.showFavoriteOnly, this.isDarkMode, this.idsToShow, {Key? key})
      : super(key: key);

  @override
  _FavoriteImoveisGridState createState() => _FavoriteImoveisGridState();
}

class _FavoriteImoveisGridState extends State<FavoriteImoveisGrid> {
  late ScrollController _scrollController;
  late List<Imovel> _loadedProducts;
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
    final provider = Provider.of<ImovelList>(context, listen: false);
    final List<Imovel> additionalProducts =
        provider.items.skip(_loadedProducts.length).take(50).toList();
    setState(() {
      _loadedProducts.addAll(additionalProducts);
    });
  }

  List<Imovel> _filterProducts() {
    if (_searchText.isEmpty) {
      return _loadedProducts.where((imovel) => widget.idsToShow.contains(imovel.codigo)).toList();
    } else {
      return _loadedProducts
          .where((imovel) =>
              imovel.codigo.toLowerCase().contains(_searchText.toLowerCase()) && widget.idsToShow.contains(imovel.codigo))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(10),
            itemCount:
                _filterProducts().length
                , // Add 1 for the load more button
            itemBuilder: (ctx, i) {
             
                return ChangeNotifierProvider.value(
                  value: _filterProducts()[i],
                  child: ImovelItem(widget.isDarkMode, i),
                );
              
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          ),
        ),
      ],
    );
  }

 
}
