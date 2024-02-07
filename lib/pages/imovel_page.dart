import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_grid.dart';
import 'package:provider/provider.dart';
import '../models/houses/imovelList.dart';

class ImovelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Imóveis'),
      ),
      body: FutureBuilder(
        future: Provider.of<ImovelList>(context, listen: false).lerImobiliarias(),
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
              return    ImovelGrid(false, false);
            }
          }
        },
      ),
    );
  }
}
