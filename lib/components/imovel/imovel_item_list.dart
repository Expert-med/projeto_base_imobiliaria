import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:projeto_imobiliaria/models/imoveis/imovel.dart';
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
  bool _isImageExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Imovel>(context, listen: false);
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isDarkMode ? Colors.white : Colors.black38,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isImageExpanded = !_isImageExpanded;
                  });
                },
                child: AnimatedContainer(
                  width: _isImageExpanded ? 300 : 150,
                  height: _isImageExpanded ? 200 : 100,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: CachedNetworkImage(
                    imageUrl: product.infoList['image_urls'][0],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
  '${(product.infoList['total_dormitorios'] != 'N/A' && product.infoList['total_suites'] != 'N/A') ? (int.parse(product.infoList['total_dormitorios']) + int.parse(product.infoList['total_suites'])) : '0 dormitórios informados'}',
  style: TextStyle(
    color: !widget.isDarkMode ? Colors.black : Colors.white,
    fontSize: isSmallScreen ? 15 : 18,
    fontWeight: FontWeight.bold,
  ),
),

                      SizedBox(
                        width: 20,
                      ),
                      IntrinsicHeight(
                        child: Text(
                          '${product.infoList['preco_original'] == 'N/A' ? 'N/A' : product.infoList['preco_original']}',
                          style: TextStyle(
                            color: !widget.isDarkMode
                                ? Colors.black
                                : Colors.white,
                            fontSize: isSmallScreen ? 15 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: IntrinsicHeight(
                          child: Flexible(
                            child: Text(
                              '${product.infoList['localizacao']}',
                              style: TextStyle(
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: IntrinsicHeight(
                          child: Flexible(
                            child: Text(
                              '${product.infoList['area_total']}',
                              style: TextStyle(
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                          List<dynamic> rawImageUrls =
                              product.infoList['image_urls'];
                          imageUrls.addAll(
                              rawImageUrls.map((url) => url.toString()));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImoveisInfoPage(
                                nome_imovel: product.infoList['nome_imovel'],
                                terreno: product.infoList['terreno'],
                                originalPrice:
                                    product.infoList['preco_original'],
                                location: product.infoList['localizacao'],
                                urlsImage: imageUrls,
                                codigo: product.codigo,
                                area_total: product.infoList['area_total'],
                                link: product.link,
                                Vagasgaragem:
                                    product.infoList['total_garagem'] ?? 0,
                                Totaldormitorios:
                                    product.infoList['total_dormitorios'] ?? '',
                                Totalsuites:
                                    product.infoList['total_suites'] ?? '',
                                latitude: product.infoList['latitude'] ?? '',
                                longitude: product.infoList['longitude'] ?? '',
                                tipo_pagina: 0,
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
            ],
          ),
        ),
      ),
    );
  }
}
