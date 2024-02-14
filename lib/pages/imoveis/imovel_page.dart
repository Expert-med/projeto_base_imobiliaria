import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_carrousel.dart';
import 'package:projeto_imobiliaria/models/imoveis/imovel.dart';
import 'package:provider/provider.dart';
import '../../components/imovel/imovel_grid.dart';
import '../../models/imoveis/imovelList.dart';

enum FilterOptions {
  favorite,
  all,
}


class ImovelPage extends StatefulWidget {
  @override
  State<ImovelPage> createState() => _ImovelPageState();
}

class _ImovelPageState extends State<ImovelPage> {
   bool _showFavoriteOnly = false;
   bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Imóveis'),
        
      ),
      body: ImovelGrid(isDarkMode, _showFavoriteOnly),

      drawer: CustomMenu(isDarkMode: false),
    );
  }
}
