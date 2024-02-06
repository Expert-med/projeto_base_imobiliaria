import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/houses/house.dart';

class HouseItem extends StatefulWidget {
  final bool isDarkMode;

  const HouseItem(this.isDarkMode, {Key? key}) : super(key: key);

  @override
  _HouseItemState createState() => _HouseItemState();
}

class _HouseItemState extends State<HouseItem> {
  Color containerColor = Color.fromARGB(255, 238, 238, 238);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    return AspectRatio(
      aspectRatio: 16 / 9, // Defina a proporção desejada
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            onTap: () {
              setState(() {
                containerColor = Colors.black; // Altera a cor de fundo do Container para preto
              });
            },
          ),
          footer: Container(
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
                        'R\$ ${product.price.toStringAsFixed(2)}',
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
                                '${product.id}',
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
                                '${product.id}',
                                style: TextStyle(
                                  color: widget.isDarkMode ? Colors.white : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          Spacer(), // Spacer para distribuir o espaço restante
                          Row(
                            children: [
                              Text(
                                'm²',
                                style: TextStyle(
                                  color: widget.isDarkMode ? Colors.white : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4), // Espaço entre o texto "m²" e o valor
                              Text(
                                '${product.id}',
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
                                '${product.endereco}',
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
          ),
        ),
      ),
    );
  }
}
