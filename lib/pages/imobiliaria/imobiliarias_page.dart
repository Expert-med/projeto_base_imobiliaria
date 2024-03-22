import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/models/imobiliarias/imobiliariasList.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';
import '../../components/imobiliaria/imobiliaria_grid.dart';

class ImobiliariasPage extends StatelessWidget {
    final bool isDarkMode;

  ImobiliariasPage({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen ? AppBar(
        title: Text('Lista de Imobiliarias'),
      ) : null,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (!isSmallScreen) CustomMenu(),
            Expanded(child: FutureBuilder(
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
            final imoveis = Provider.of<NewImovelList>(context).items;

            if (imoveis.isEmpty) {
              return Center(
                child: Text('Nenhum imóvel encontrado'),
              );
            } else {
              return    Row(
                children: [
                  
                  Expanded(child: ImobiliariaGrid(false, false)),
                ],
              );
            }
          }
        },
      ),)
          ],
        );
      }),
      drawer: CustomMenu(),
    );
  }
}
