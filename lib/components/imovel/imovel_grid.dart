import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_item.dart';
import 'package:provider/provider.dart';

import '../../models/imoveis/imovel.dart';
import '../../models/imoveis/imovelList.dart';

class ImovelGrid extends StatefulWidget {
  final bool isDarkMode;
  final bool showFavoriteOnly;

  const ImovelGrid(this.showFavoriteOnly, this.isDarkMode, {Key? key}) : super(key: key);

  @override
  _ImovelGridState createState() => _ImovelGridState();
}

class _ImovelGridState extends State<ImovelGrid> {
  late ScrollController _scrollController;
  late List<Imovel> _loadedProducts;
  int _numberOfItemsToShow = 50;

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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    final provider = Provider.of<ImovelList>(context, listen: false);
    final List<Imovel> additionalProducts = provider.items.skip(_loadedProducts.length).take(50).toList();
    setState(() {
      _loadedProducts.addAll(additionalProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: _loadedProducts.length + 1, // Add 1 for the load more button
      itemBuilder: (ctx, i) {
        if (i == _loadedProducts.length) {
          return _buildLoadMoreButton();
        } else {
          return ChangeNotifierProvider.value(
            value: _loadedProducts[i],
            child: ImovelItem(widget.isDarkMode, i),
          );
        }
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
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