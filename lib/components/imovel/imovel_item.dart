import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:provider/provider.dart';

import '../../pages/imobiliaria/imovel_info_page.dart';

class ImovelItem extends StatefulWidget {
  final bool isDarkMode;
  final int index;
  final int count;
  final int tipo_pagina;
  final Function(String) onFavoriteClicked;

  const ImovelItem(this.isDarkMode, this.index, this.count, this.tipo_pagina,
      this.onFavoriteClicked,
      {Key? key})
      : super(key: key);

  @override
  _ImovelItemState createState() => _ImovelItemState();
}

class _ImovelItemState extends State<ImovelItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<NewImovel>(context, listen: false);

    return AspectRatio(
      aspectRatio: 25 / 13,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: CachedNetworkImage(
            imageUrl:
                product.imagens.isNotEmpty ? product.imagens[0].toString() : '',
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          footer: _buildFooter(product),
        ),
      ),
    );
  }

  Widget _buildFooter(NewImovel product) {
    Color containerColor =
        widget.isDarkMode ? Colors.black : Color.fromARGB(255, 238, 238, 238);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: containerColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.preco['preco_original'] == [] ? 'Preço não informado' : product.preco['preco_original']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: widget.isDarkMode ? Colors.white : Colors.black54,
                  ),
                ),
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
                          '${product.detalhes['total_dormitorios'] ?? 0} suítes: ${product.detalhes['total_suites'] ?? 0}',
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
                          '${product.detalhes['vagas_garagem']}',
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
                          '${product.detalhes['area_total']}',
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
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.place,
                        color:
                            widget.isDarkMode ? Colors.white : Colors.black54,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: SelectableText(
                          _buildFooterLocation(product),
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black54,
                          ),
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
                  return Consumer<NewImovel>(
                    builder: (ctx, product, _) => IconButton(
                      onPressed: () {
                        setState(() {
                          product.toggleFavorite();
                        });
                        _onFavoriteClicked(product.id);
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
                  List<dynamic> rawImageUrls = product.imagens;
                  imageUrls.addAll(rawImageUrls.map((url) => url.toString()));

                    imageUrls.addAll(rawImageUrls.map((url) => url.toString()));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImoveisInfoPage(
                        nome_imovel: product.detalhes['nome_imovel'],
                        terreno: product.detalhes['terreno'],
                        originalPrice: '0',
                        location: product.localizacao['endereco']
                            ['bairro'],
                        urlsImage: imageUrls,
                        codigo: product.id,
                        area_total: product.detalhes['area_total'],
                        link: product.link_imovel,
                        Vagasgaragem: product.detalhes['total_garagem'] ?? 0,
                        Totaldormitorios:
                            product.detalhes['total_dormitorios'] ?? '',
                        Totalsuites: product.detalhes['total_suites'] ?? '',
                        latitude:
                            product.localizacao['latitude'] ?? '',
                        longitude: product.localizacao
                                ['longitude'] ??
                            '',
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

  String _buildDetailsText(Map<String, dynamic> detailsMap) {
    final String nomeImovel = detailsMap['nome_imovel'] ?? 'Nome não informado';
    final String areaTotal =
        detailsMap['area_total'] ?? 'Área total não informada';
    return '$nomeImovel - Área total: $areaTotal';
  }

  String _buildFooterLocation(NewImovel product) {
    if (product.localizacao != null &&
        widget.index >= 0 &&
        widget.index < product.localizacao.length &&
        product.localizacao != null &&
        product.localizacao['endereco'] != null &&
        product.localizacao['endereco']['bairro'] != null) {
      return product.localizacao['endereco']['logradouro'] +
          ', ' +
          product.localizacao['endereco']['bairro'] +
          ' - ' +
          product.localizacao['endereco']['cidade'] +
          ' / ' +
          product.localizacao['endereco']['estado'];
    } else {
      return 'Localização não disponível';
    }
  }

  void _onFavoriteClicked(String codigo) {
    widget.onFavoriteClicked(codigo);
  }
}
