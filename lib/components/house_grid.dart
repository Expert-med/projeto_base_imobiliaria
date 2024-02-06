import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../models/houses/house.dart';
import '../models/houses/house_list.dart';
import 'house_item.dart';

class HouseGrid extends StatelessWidget {
  final bool isDarkMode;
  final bool showFavoriteOnly;

  const HouseGrid(this.showFavoriteOnly, this.isDarkMode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;

    return CarouselSlider.builder(
      itemCount: loadedProducts.length,
      options: CarouselOptions(
        height: 250, // Define a altura do carousel
        aspectRatio: 16 / 9, // Proporção da imagem
       viewportFraction: 1 / 3,
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
        return ChangeNotifierProvider.value(
          value: loadedProducts[index],
          child: HouseItem(isDarkMode),
        );
      },
    );
  }
}
