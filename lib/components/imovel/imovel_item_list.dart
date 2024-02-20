import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/models/imoveis/imovel.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../pages/imobiliaria/imovel_info_page.dart';
import 'imovel_info_component.dart';

class ImovelItemList extends StatefulWidget {
  final bool isDarkMode;
  final int index;
  final int count;

  const ImovelItemList(this.isDarkMode, this.index, this.count, {Key? key})
      : super(key: key);

  @override
  _ImovelItemListState createState() => _ImovelItemListState();
}

class _ImovelItemListState extends State<ImovelItemList> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Imovel>(context, listen: false);
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color:
                  widget.isDarkMode ? Colors.white : Colors.black38, // Cor da borda
              width: 1, // Largura da borda
            ),
            borderRadius: BorderRadius.circular(10), // Raio da borda
          ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             Container(
        alignment: Alignment.topCenter,
        child: IntrinsicHeight(
        child: Text(
          '${product.infoList['preco_original'] == 'N/A' ? 'Preço não informado' : product.infoList['preco_original']}',
          style: TextStyle(
            color: !widget.isDarkMode ? Colors.black : Colors.white,
            fontSize: isSmallScreen ? 15 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ),
      ),
      
                SizedBox(height: 5,),
                 Container(
              alignment: Alignment.topCenter,
              child: IntrinsicHeight(
                child: Text(
                  '${product.infoList['localizacao']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: !widget.isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
              ],
            ),
           
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Consumer<Imovel>(
                          builder: (ctx, product, _) => IconButton(
                            onPressed: () {
                              product.toggleFavorite();
                            },
                            icon: Icon(product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    
                    IconButton(
                      onPressed: () {
                        List<String> imageUrls = [];
                        // Converter explicitamente para List<String>
                        List<dynamic> rawImageUrls = product.infoList['image_urls'];
                        imageUrls.addAll(rawImageUrls.map((url) => url.toString()));
      
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImoveisInfoPage(
                              nome_imovel: product.infoList['nome_imovel'],
                              terreno: product.infoList['terreno'],
                              originalPrice: product.infoList['preco_original'],
                              location: product.infoList['localizacao'],
                              urlsImage: imageUrls,
                              codigo: product.codigo,
                              area_total: product.infoList['area_total'],
                              link: product.link,
                              Vagasgaragem: product.infoList['total_garagem'] ?? 0,
                              Totaldormitorios:
                                  product.infoList['total_dormitorios'] ?? '',
                              Totalsuites: product.infoList['total_suites'] ?? '',
                              latitude: product.infoList['latitude'] ?? '',
                              longitude: product.infoList['longitude'] ?? '',tipo_pagina: 0,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.info),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
