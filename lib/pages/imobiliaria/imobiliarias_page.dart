import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/models/imobiliarias/imobiliariasList.dart';
import 'package:provider/provider.dart';
import '../../components/imobiliaria/imobiliaria_grid.dart';
import '../../models/imoveis/imovelList.dart';

class ImobiliariasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Imobiliarias'),
      ),
      body: FutureBuilder(
        future: Provider.of<ImobiliariaList>(context, listen: false).lerImobiliarias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os imóveis'),
            );
          } else {
            final imoveis = Provider.of<ImovelList>(context).items;

            if (imoveis.isEmpty) {
              return Center(
                child: Text('Nenhum imóvel encontrado'),
              );
            } else {
              return    ImobiliariaGrid(false, false);
            }
          }
        },
      ),
      drawer: CustomMenu(isDarkMode: false),
    );
  }
}
