import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/imoveis/imovel.dart';
import '../../models/imoveis/imovelList.dart';

class ImovelInfoComponent extends StatelessWidget {
  final String nome_imovel;
  final String terreno;
  final String location;
  final String originalPrice;
  final List<String> urlsImage;
  final String codigo;
  final String area_total;
  final String link;
  bool isDarkMode;

  ImovelInfoComponent(this.nome_imovel, this.terreno, this.location, this.originalPrice,
      this.urlsImage, this.isDarkMode, this.codigo,this.area_total,this.link);

  // Indice da imagem atual
  int _currentIndex = 0;

  // Controlador do CarouselSlider
  final CarouselController _carouselController = CarouselController();

 void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }
  
  @override
Widget build(BuildContext context) {
  Color backgroundColor = isDarkMode ? Colors.black87 : Colors.white;
Color textColor = !isDarkMode ? Colors.black87 : Colors.white;

  return Scaffold(
    
    body: Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Informações sobre ${nome_imovel}',
                  style: TextStyle(fontSize: 15, color:textColor),
                ),
                Text(
                  'Imóvel cód. ${codigo}',
                  style: TextStyle(fontSize: 15, color:textColor),
                ),
                SizedBox(height: 8,),
                Text(
                  'Terreno: ${terreno}',
                  style: TextStyle(fontSize: 13, color:textColor),
                ),
                Text(
                  'Área total: ${area_total}',
                  style: TextStyle(fontSize: 13, color:textColor),
                ),
                SizedBox(height: 8,),
                Text(
                  'Localização ${location}',
                  style: TextStyle(fontSize: 13, color:textColor),
                ),
                SizedBox(height: 8,),
                Text(
                  'Preço Original ${originalPrice}',
                  style: TextStyle(fontSize: 13, color:textColor),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple, // Cor de fundo roxo
                    borderRadius: BorderRadius.circular(10), // Borda arredondada
                  ),
                  padding: EdgeInsets.all(10), // Espaçamento interno
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Acesse o imóvel',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Cor do texto
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          _launchURL(link);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

}
