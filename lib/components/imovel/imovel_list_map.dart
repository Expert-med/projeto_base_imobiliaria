import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import '../../pages/imobiliaria/imovel_info_page.dart';
import 'imovel_info_component.dart';

class ImovelListMap extends StatelessWidget {
  final NewImovel imovel;
  final bool isDarkMode;

  const ImovelListMap({
    required this.imovel,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  imovel.imagens.isNotEmpty ? imovel.imagens[0] : '',
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  imovel.detalhes['nome_imovel'] ?? '',
                  style: TextStyle(
                    color: Color(0xFF6e58e9),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: isDarkMode ? Colors.white : Colors.black54,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          imovel.localizacao['endereco']["cidade"] ?? "N/A",
                          style: TextStyle(
                            color: Color(0xFF6e58e9),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      Icon(
                        Icons.bed,
                        color: isDarkMode ? Colors.white : Colors.black54,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            imovel.detalhes['total_dormitorios'] ?? 'N/A', 
                            style: TextStyle(
                              color: Color(0xFF6e58e9),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    imovel.preco['preco_original'] != "N/A"
                        ? imovel.preco['preco_original']
                        : "Sem preço informado",
                    style: TextStyle(
                      color: Color.fromARGB(207, 0, 0, 0),
                      fontSize: imovel.preco['preco_original'] != "N/A" ? 20 : 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(/*
            builder: (context) => ImovelInfoComponent(
              isDarkMode,
              1,
              imovel.caracteristicas,
              imovel,
            ),*/
            builder: (context) => ImoveisInfoPage(
                        nome_imovel: imovel.detalhes['nome_imovel'],
                        terreno: imovel.detalhes['terreno'],
                        originalPrice: '0',
                        location: imovel.localizacao['endereco']
                            ['bairro'],
                        urlsImage: imovel.imagens,
                        codigo: imovel.id,
                        area_total: imovel.detalhes['area_total'],
                        link: imovel.link_imovel,
                        Vagasgaragem: imovel.detalhes['total_garagem'] ?? 0,
                        Totaldormitorios:
                            imovel.detalhes['total_dormitorios'] ?? '',
                        Totalsuites: imovel.detalhes['total_suites'] ?? '',
                        latitude:
                            imovel.localizacao['latitude'] ?? '',
                        longitude: imovel.localizacao
                                ['longitude'] ??
                            '',
                        tipo_pagina: 0,
                        caracteristicas: imovel.caracteristicas,
                        area_privativa: imovel.detalhes['total_dormitorios'] ?? '',
                        imovel: imovel,
                      ),
          ),
        );
      },
      tileColor: Colors.grey,
      selectedTileColor: Color(0xFF6e58e9),
    );
  }
}
