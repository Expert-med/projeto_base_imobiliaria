import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import '../../theme/appthemestate.dart';
import 'imovel_item.dart';
import 'imovel_item_sem_barra.dart';

class FavoriteImoveisCarousel extends StatefulWidget {
  final bool showFavoriteOnly;
  final List<String> favoriteIds; // Lista de IDs dos imóveis favoritos

  const FavoriteImoveisCarousel(this.showFavoriteOnly, this.favoriteIds, {Key? key})
      : super(key: key);

  @override
  _FavoriteImoveisCarouselState createState() => _FavoriteImoveisCarouselState();
}

class _FavoriteImoveisCarouselState extends State<FavoriteImoveisCarousel> {
  late List<NewImovel> _loadedProducts = []; // Inicialize com uma lista vazia

  @override
  void initState() {
    super.initState();
print(' widget.favoriteIds ${ widget.favoriteIds}');
     _loadedProducts = Provider.of<NewImovelList>(context, listen: false)
        .items
        .where((imovel) => widget.favoriteIds.contains(imovel.id))
        .toList();
        print('_loadedProducts $_loadedProducts');
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
     return _loadedProducts.isEmpty
      ? Container() // ou outro widget de fallback
      : CarouselSlider.builder(
          itemCount: _loadedProducts.length,
          options: CarouselOptions(
             height: 250, // Define a altura do carousel
        aspectRatio: 16 / 9, // Proporção da imagem
        viewportFraction: !isSmallScreen ? 1 / 3 : 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5), // Intervalo entre cada slide
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal, // Direção do carousel
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return ImovelItem( index,_loadedProducts.length,0, (String productCode) {});
          },
        );

  }
}
