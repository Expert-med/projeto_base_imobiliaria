import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../pages/imobiliaria/imovel_info_page.dart';
import 'imovel_info_component.dart';

class ImovelItemSemBarra extends StatefulWidget {
  final bool isDarkMode;
  final int index;
  final int count;
  final int tipo_pagina;
  final Function(String) onFavoriteClicked; // Callback para o código do produto

  const ImovelItemSemBarra(
      this.isDarkMode,
      this.index,
      this.count,
      this.tipo_pagina,
      this.onFavoriteClicked, // Adiciona o callback como parâmetro
      {Key? key})
      : super(key: key);

  @override
  _ImovelItemSemBarraState createState() => _ImovelItemSemBarraState();
}

class _ImovelItemSemBarraState extends State<ImovelItemSemBarra> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<NewImovel>(context, listen: false);

    return AspectRatio(
      aspectRatio: 25 / 13, // Defina a proporção desejada
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            // Navegue para a página de informações do imóvel ao ser clicado
            _navigateToImovelInfoPage(context, product);
          },
          child: GridTile(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        product.imagens
                            [0], // Usa a primeira imagem da lista
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent, // Cor inicial (transparente)
                          Colors.black.withOpacity(
                              0.99), // Cor final (com transparência)
                        ],
                      ),
                    ),
                    child: Column(
                      
                      children: [
                        Row(
                          children: [
                            Text(
                              'Último valor de venda',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              product.detalhes != null &&
                                      product.detalhes['preco_original'] != null
                                  ? product.detalhes['preco_original']
                                  : 'Não informado',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                product.localizacao['endereco']['logradouro'] + ', '+ product.localizacao['endereco']['logradouro'] + ' - '+ product.localizacao['endereco']['cidade']+'/'+product.localizacao['endereco']['uf'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Spacer(),
                            Flexible(
                              child: Text(
                                ' ${product.detalhes['total_dormitorios']} \ndorm.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                ' ${product.detalhes['total_suites']} \nsuites',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                ' ${product.detalhes['vagas_garagem']} \ndorm.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFavoriteClicked(String codigo) {
    widget.onFavoriteClicked(codigo);
  }

  void _navigateToImovelInfoPage(BuildContext context, NewImovel product) {
    List<String> imageUrls = [];
    // Converter explicitamente para List<String>
    List<dynamic> rawImageUrls = product.imagens;
    imageUrls.addAll(rawImageUrls.map((url) => url.toString()));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImoveisInfoPage(
          nome_imovel: product.detalhes['nome_imovel'],
          terreno: product.detalhes['terreno'],
          originalPrice: product.detalhes['preco_original'],
          location:  product.localizacao['endereco']['logradouro'] + ', '+ product.localizacao['endereco']['logradouro'] + ' - '+ product.localizacao['endereco']['cidade']+'/'+product.localizacao['endereco']['uf'],
          urlsImage: imageUrls,
          codigo: product.id,
          area_total: product.detalhes['area_total'],
          link: product.link_imovel,
          Vagasgaragem: product.detalhes['total_garagem'] ?? 0,
          Totaldormitorios: product.detalhes['total_dormitorios'] ?? '',
          Totalsuites: product.detalhes['total_suites'] ?? '',
          latitude: product.localizacao['latitude'] ?? '',
          longitude: product.localizacao['longitude'] ?? '',
          tipo_pagina: widget.tipo_pagina,
          caracteristicas: product.caracteristicas,
          area_privativa: product.detalhes['total_dormitorios'] ?? '',
          imovel: product,

        ),
      ),
    );
  }
}
