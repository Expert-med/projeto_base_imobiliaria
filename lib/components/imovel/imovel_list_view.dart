import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import 'imovel_item_list.dart';

class ImovelListView extends StatefulWidget {
  final bool isDarkMode;
  final bool showFavoriteOnly;

  const ImovelListView(this.showFavoriteOnly, this.isDarkMode, {Key? key})
      : super(key: key);

  @override
  _ImovelListViewState createState() => _ImovelListViewState();
}

class _ImovelListViewState extends State<ImovelListView> {
  late ScrollController _scrollController;
  late List<NewImovel> _loadedProducts;
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

  List<NewImovel> _filterProducts() {
    if (_searchText.isEmpty) {
      return _loadedProducts;
    } else {
      return _loadedProducts
          .where((imovel) =>
              imovel.id.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isDarkMode ? Colors.black : Colors.white,
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
                fillColor: widget.isDarkMode
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
          Expanded(
            child: ListView.builder(
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
                    child: ImovelItemList(
                        widget.isDarkMode, i, _filterProducts().length),
                  );
                }
              },
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
