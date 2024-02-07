import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/models/houses/imovel.dart';
import 'package:provider/provider.dart';


class ImovelItem extends StatefulWidget {
  final bool isDarkMode;
  final int index;
  
  const ImovelItem(this.isDarkMode, this.index, {Key? key}) : super(key: key);

  @override
  _ImovelItemState createState() => _ImovelItemState();
}

class _ImovelItemState extends State<ImovelItem> {
  Color containerColor = Color.fromARGB(255, 238, 238, 238);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Imovel>(context, listen: false);

    return AspectRatio(
      aspectRatio: 16 / 9, // Defina a proporção desejada
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: product.infoList[widget.index]['image_urls'].length,
            itemBuilder: (context, index) {
              return Image.network(
                product.infoList[widget.index]['image_urls'][index],
                fit: BoxFit.cover,
              );
            },
          ),
          footer: _buildFooter(product),
        ),
      ),
    );
  }

  Widget _buildFooter(Imovel product) {
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
                  '${product.infoList[widget.index]['preco_original']}',
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
                                color: widget.isDarkMode ? Colors.white : Colors.black54,
                              ),
                              SizedBox(width: 4), // Espaço entre o ícone e o texto
                              Text(
                                '${product.infoList[widget.index]['total_dormitorios'] + ' suítes:' + product.infoList[widget.index]['total_suites'] }',
                                style: TextStyle(
                                  color: widget.isDarkMode ? Colors.white : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          Spacer(), // Spacer para distribuir o espaço restante
                          Row(
                            children: [
                              Icon(
                                Icons.garage,
                                color: widget.isDarkMode ? Colors.white : Colors.black54,
                              ),
                              SizedBox(width: 4), // Espaço entre o ícone e o texto
                              Text(
                                '${product.infoList[widget.index]['vagas_garagem'] }',
                                style: TextStyle(
                                  color: widget.isDarkMode ? Colors.white : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          Spacer(), // Spacer para distribuir o espaço restante
                          Row(
                            children: [
                               Icon(
                                Icons.area_chart,
                                color: widget.isDarkMode ? Colors.white : Colors.black54,
                              ),
                              SizedBox(width: 4), // Espaço entre o texto "m²" e o valor
                              Text(
                                '${product.infoList[widget.index]['area_total'] }',
                                style: TextStyle(
                                  color: widget.isDarkMode ? Colors.white : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity, // Define a largura do container como o máximo possível
                        child: Row(
                          children: [
                            Icon(
                              Icons.pin_drop_outlined,
                              color: widget.isDarkMode ? Colors.white : Colors.black54,
                            ),
                            SizedBox(width: 4), // Espaço entre o ícone e o texto
                            Flexible(
                              child: Text(
                                '${product.infoList[widget.index]['localizacao'] }',
                                style: TextStyle(
                                  color: widget.isDarkMode ? Colors.white : Colors.black54,
                                ),
                                softWrap: true, // Permite que o texto quebre de linha quando necessário
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        
          IconButton(
            onPressed: () {
              // Adicione a lógica do carrinho de compras aqui
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
