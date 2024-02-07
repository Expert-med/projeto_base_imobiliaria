import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../models/houses/imovel.dart';
import '../../models/houses/imovelList.dart';

class InfoMapPage extends StatelessWidget {
  final String nome_imovel;
  final String terreno;
  final String location;
  final String originalPrice;
  final List<String> urlsImage;
  bool isDarkMode;

  InfoMapPage(this.nome_imovel, this.terreno, this.location, this.originalPrice,
      this.urlsImage, this.isDarkMode);

  // Indice da imagem atual
  int _currentIndex = 0;

  // Controlador do CarouselSlider
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        backgroundColor: Color(0xFF466B50),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Informações sobre ${nome_imovel}',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 8,),
                Text(
                  'Terreno: ${terreno}',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 8,),
                Text(
                  'Localização ${location}',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 8,),
                Text(
                  'Preço Original ${originalPrice}',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 8,),
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      _currentIndex = index;
                    },
                  ),
                  items: urlsImage.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        if (_currentIndex > 0) {
                          _carouselController.previousPage();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (_currentIndex < urlsImage.length - 1) {
                          _carouselController.nextPage();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
