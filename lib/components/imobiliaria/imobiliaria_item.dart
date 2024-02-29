import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/models/imobiliarias/imobiliaria.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ImobiliariaItem extends StatefulWidget {
  final bool isDarkMode;
  final int index;

  const ImobiliariaItem(this.isDarkMode, this.index, {Key? key})
      : super(key: key);

  @override
  _ImobiliariaItemState createState() => _ImobiliariaItemState();
}

class _ImobiliariaItemState extends State<ImobiliariaItem> {
  Color containerColor = Color.fromARGB(255, 238, 238, 238);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Imobiliaria>(context, listen: false);

    return AspectRatio(
      aspectRatio: 16 / 9, // Defina a proporção desejada
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: product.url_logo.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: product.url_logo[index],
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }

  Widget _buildFooter(Imobiliaria product) {
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
                  '${product.nome}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: widget.isDarkMode ? Colors.white : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _launchURL(product.url_base);
            },
            icon: const Icon(Icons.arrow_right_alt_outlined),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
