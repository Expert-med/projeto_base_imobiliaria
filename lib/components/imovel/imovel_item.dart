import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/models/imoveis/imovel.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../pages/imobiliaria/imovel_info_page.dart';
import 'imovel_info_component.dart';

class ImovelItem extends StatefulWidget {
  final bool isDarkMode;
  final int index;
  final int count;
  final int tipo_pagina;
final Function(String) onFavoriteClicked; // Callback para o código do produto

  const ImovelItem(
    this.isDarkMode,
    this.index,
    this.count,
    this.tipo_pagina,
    this.onFavoriteClicked, // Adiciona o callback como parâmetro
    {Key? key}
  ) : super(key: key);

  @override
  _ImovelItemState createState() => _ImovelItemState();
}

class _ImovelItemState extends State<ImovelItem> {
   void _onFavoriteClicked(String codigo) {
    // Chama o callback com o código do produto
    widget.onFavoriteClicked(codigo);
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Imovel>(context, listen: false);
 
    return AspectRatio(
      aspectRatio: 25 / 13, // Defina a proporção desejada
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.count,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: product.infoList['image_urls'][0],
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            },
          ),
          footer: _buildFooter(product),
        ),
      ),
    );
  }

  Widget _buildFooter(Imovel product) {
    Color containerColor =
        widget.isDarkMode ? Colors.black : Color.fromARGB(255, 238, 238, 238);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: containerColor, // Utiliza a cor de fundo controlada pelo estado
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.infoList['preco_original'] == 'N/A' ? 'Preço não informado' : product.infoList['preco_original']} ()',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: widget.isDarkMode ? Colors.white : Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.bed,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black54,
                        ),
                        SizedBox(width: 4), // Espaço entre o ícone e o texto
                        SelectableText(
                          '${product.infoList['total_dormitorios'] ?? 0} suítes: ${product.infoList['total_suites'] ?? 0}',
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Spacer(), // Spacer para distribuir o espaço restante
                    Row(
                      children: [
                        Icon(
                          Icons.garage,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black54,
                        ),
                        SizedBox(width: 4), // Espaço entre o ícone e o texto
                        SelectableText(
                          '${product.infoList['vagas_garagem']}',
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Spacer(), // Spacer para distribuir o espaço restante
                    Row(
                      children: [
                        Icon(
                          Icons.area_chart,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black54,
                        ),
                        SizedBox(
                            width: 4), // Espaço entre o texto "m²" e o valor
                        SelectableText(
                          '${product.infoList['area_total']}',
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: double
                      .infinity, // Define a largura do container como o máximo possível
                  child: Row(
                    children: [
                      Icon(
                        Icons.place,
                        color:
                            widget.isDarkMode ? Colors.white : Colors.black54,
                      ),
                      SizedBox(width: 4), // Espaço entre o ícone e o texto
                      Flexible(
                        child: SelectableText(
                          '${product.infoList['localizacao']}',
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black54,
                          ),
                          // softWrap: true, // Permitrmite que o texto quebre de linha quando necessário
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Consumer<Imovel>(
                    builder: (ctx, product, _) => IconButton(
                      onPressed: () {
                        setState(() {
                          product.toggleFavorite();
                        });
                        _onFavoriteClicked(product.codigo);
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
                        longitude: product.infoList['longitude'] ?? '',
                        tipo_pagina: widget.tipo_pagina,
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
    );
  }
}
