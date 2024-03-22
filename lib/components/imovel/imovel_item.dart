import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:provider/provider.dart';

import '../../pages/imobiliaria/imovel_info_page.dart';
import '../../theme/appthemestate.dart';

class ImovelItem extends StatefulWidget {
  
  final int index;
  final int count;
  final int tipo_pagina;
  final Function(String) onFavoriteClicked;

  const ImovelItem( this.index, this.count, this.tipo_pagina,
      this.onFavoriteClicked,
      {Key? key})
      : super(key: key);

  @override
  _ImovelItemState createState() => _ImovelItemState();
}

class _ImovelItemState extends State<ImovelItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<NewImovel>(context, listen: false,);
  print("entrou em imovelItem");
    return AspectRatio(
      aspectRatio: 25 / 13,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: product.imagens.isNotEmpty && product.imagens[0] != null
              ? CachedNetworkImage(
                  imageUrl: product.imagens[0].toString() ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => _buildNoImageWidget(),
                )
              : _buildNoImageWidget(),
          footer: _buildFooter(product),
        ),
      ),
    );
  }

  Widget _buildNoImageWidget() {
    return Image.asset(
      'assets/images/no_availablle.jpg',
      fit: BoxFit.cover,
      // Ajuste a largura e a altura conforme necessário
      width: 100,
      height: 100,
    );
  }

  Widget _buildFooter(NewImovel product) {
     final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    Color containerColor =
        themeNotifier.isDarkModeEnabled ? Colors.black : Color.fromARGB(255, 238, 238, 238);

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
                Row(
                  children: [
                    Text(
                      '${product.preco['preco_original'] == "" ? 'Preço não informado' : product.preco['preco_original']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color:
                             themeNotifier.isDarkModeEnabled ? Colors.white : Colors.black54,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        List<String> imageUrls = [];
                        List<dynamic> rawImageUrls = product.imagens;
                        imageUrls
                            .addAll(rawImageUrls.map((url) => url.toString()));

                        imageUrls
                            .addAll(rawImageUrls.map((url) => url.toString()));

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
                              Vagasgaragem:
                                  product.detalhes['total_garagem'] ?? 0,
                              Totaldormitorios:
                                  product.detalhes['total_dormitorios'] ?? '',
                              Totalsuites:
                                  product.detalhes['total_suites'] ?? '',
                              latitude: product.localizacao['latitude'] ?? '',
                              longitude: product.localizacao['longitude'] ?? '',
                              tipo_pagina: widget.tipo_pagina,
                              caracteristicas: product.caracteristicas,
                              area_privativa:
                                  product.detalhes['total_dormitorios'] ?? '',
                              imovel: product,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.info),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
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
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.garage,
                          color:
                               themeNotifier.isDarkModeEnabled ? Colors.white : Colors.black54,
                        ),
                        SizedBox(width: 3), // Espaço entre o ícone e o texto
                        SelectableText(
                          '${product.detalhes['vagas_garagem']}',
                          style: TextStyle(
                            color:  themeNotifier.isDarkModeEnabled
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.area_chart,
                          color:
                               themeNotifier.isDarkModeEnabled ? Colors.white : Colors.black54,
                        ),
                        SizedBox(
                            width: 3), // Espaço entre o texto "m²" e o valor
                        SelectableText(
                          '${product.detalhes['area_total']}',
                          style: TextStyle(
                            color:  themeNotifier.isDarkModeEnabled
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.bed,
                            color:  themeNotifier.isDarkModeEnabled
                                ? Colors.white
                                : Colors.black54,
                          ),
                          SizedBox(
                              width: 4), // Add spacing between icon and text
                          Flexible(
                            child: SelectableText(
                              '${product.detalhes['total_dormitorios'] ?? "N/A"}',
                              style: TextStyle(
                                fontSize: 15,
                                color:  themeNotifier.isDarkModeEnabled
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.place,
                        color:
                             themeNotifier.isDarkModeEnabled ? Colors.white : Colors.black54,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: SelectableText(
                          _buildFooterLocation(product),
                          style: TextStyle(
                            color:  themeNotifier.isDarkModeEnabled
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
          product.localizacao['endereco']['cidade'];
    } else {
      return 'Localização não disponível';
    }
  }

  void _onFavoriteClicked(String codigo) {
    widget.onFavoriteClicked(codigo);
  }
}