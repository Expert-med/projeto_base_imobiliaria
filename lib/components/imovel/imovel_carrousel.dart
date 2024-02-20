import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projeto_imobiliaria/models/imoveis/imovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/imovelList.dart';
import 'package:provider/provider.dart';
import 'imovel_item.dart';


class ImovelCarousel extends StatelessWidget {
  final bool isDarkMode;
  final bool showFavoriteOnly;

  const ImovelCarousel(this.showFavoriteOnly, this.isDarkMode, {Key? key}) : super(key: key);

  Widget build(BuildContext context) {
  final provider = Provider.of<ImovelList>(context);
  final List<Imovel> loadedProducts = provider.items.take(50).toList();
bool isSmallScreen = MediaQuery.of(context).size.width < 900;

  return loadedProducts.isEmpty
      ? Container() // ou outro widget de fallback
      : CarouselSlider.builder(
          itemCount: loadedProducts.length,
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
            return ChangeNotifierProvider.value(
              value: loadedProducts[index],
              child: ImovelItem(isDarkMode, index,loadedProducts.length,0, (String productCode) {}),
            );
          },
        );
}

}
