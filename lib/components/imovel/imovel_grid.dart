import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_item.dart';
import 'package:provider/provider.dart';

import '../../models/imoveis/imovel.dart';
import '../../models/imoveis/imovelList.dart';

class ImovelGrid extends StatefulWidget {
  final bool isDarkMode;
  final bool showFavoriteOnly;

  const ImovelGrid(this.showFavoriteOnly, this.isDarkMode, {Key? key})
      : super(key: key);

  @override
  _ImovelGridState createState() => _ImovelGridState();
}

class _ImovelGridState extends State<ImovelGrid> {
  late ScrollController _scrollController;
  late final ImovelList provider;
  late List<Imovel> _loadedProducts;
  int _numberOfItemsToShow = 50;
  String searchTerm = '';
  bool showFiltradas = false;

@override
void initState() {
  super.initState();
  _scrollController = ScrollController(); // Initialize here
  _scrollController.addListener(_scrollListener);
  provider = Provider.of<ImovelList>(context, listen: false);
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
    _loadedProducts ??= []; // Initialize _loadedProducts if it's null
    final List<Imovel> additionalProducts =
        provider.items.skip(_loadedProducts.length).take(50).toList();
    setState(() {
      _loadedProducts.addAll(additionalProducts);
    });
  }

  @override
Widget build(BuildContext context) {
 
  List<Imovel> displayedProducts = widget.showFavoriteOnly
      ? provider.favoriteItems
      : provider.items;

  // Filtragem com base no termo de pesquisa
  if (searchTerm.isNotEmpty) {
    displayedProducts = displayedProducts.where((imovel) {
      return imovel.infoList.any((info) =>
          info['localizacao'] != null &&
          info['localizacao']
              .toLowerCase()
              .contains(searchTerm.toLowerCase()));
    }).toList();
  }

  return Column(
    children: [
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: TextField(
      //     decoration: InputDecoration(
      //       hintText: 'Pesquisar imóveis...',
      //       prefixIcon: Icon(Icons.search),
      //       border: OutlineInputBorder(),
      //     ),
      //     onChanged: (query) {
      //       setState(() {
      //         searchTerm = query.toLowerCase();
      //       });
      //     },
      //   ),
      // ),
      Expanded(
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(10),
          itemCount: displayedProducts.length + 1,
          itemBuilder: (ctx, i) {
            if (i == displayedProducts.length) {
              return _buildLoadMoreButton();
            } else {
              return ChangeNotifierProvider.value(
                value: displayedProducts[i],
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
        ),
      ),
    ],
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
