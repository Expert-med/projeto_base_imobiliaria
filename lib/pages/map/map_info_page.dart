
import 'package:flutter/material.dart';

import '../../models/houses/imovel.dart';

class InfoMapPage extends StatelessWidget {
  // final Imovel imovel;
  final String nome_imovel;

  InfoMapPage(this.nome_imovel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        backgroundColor: Color(0xFF466B50),
      ),
      body: Center(
        child: Text('Informações sobre ${nome_imovel}'), // Use as propriedades do Imovel
      ),
    );
  }
}
