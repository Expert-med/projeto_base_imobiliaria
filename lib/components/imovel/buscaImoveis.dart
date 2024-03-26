import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projeto_imobiliaria/components/imovel/imovel_grid_landing.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import '../../theme/appthemestate.dart';
import 'imovel_item.dart';
import 'imovel_item_sem_barra.dart';

class BuscaImoveis extends StatefulWidget {
  final Function filtrarCompra;
  final Function filtrarAluguel;
  final Function filtrarTipo;
  const BuscaImoveis({
    required this.filtrarCompra,
    required this.filtrarAluguel,
    required this.filtrarTipo,
  Key? key}) : super(key: key);

  @override
  _BuscaImoveisState createState() => _BuscaImoveisState();
}

class _BuscaImoveisState extends State<BuscaImoveis> {
  late bool checkInFocused;
  late bool checkOutFocused;
  late bool guestsFocused;
  String selectedTipo = ''; 
  String selectedFin = '';

  @override
  void initState() {
    super.initState();
    checkInFocused = false;
    checkOutFocused = false;
    guestsFocused = false;
  }

 @override
    Widget build(BuildContext context) {
      return Center(
        child: Container(
          margin: EdgeInsets.all(40),
          height: 70,
          width: 1000,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 20,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildTipoTextField(),
              _buildExpandedTextField(
                hintText: 'Quantidade de quartos',
                isFocused: checkOutFocused,
                onTap: () {
                  setState(() {
                    checkInFocused = false;
                    checkOutFocused = true;
                    guestsFocused = false;
                  });
                },
              ),
              _buildFinalidadeTextField(),
              ClipOval(
                child: Material(
                  color: Color.fromARGB(255, 255, 0, 0),
                  child: InkWell(
                    onTap: () {
                        if (selectedFin == 'Compra') {
                          widget.filtrarCompra;
                        } else if (selectedFin == 'Aluguel') {
                          widget.filtrarAluguel;
    }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

  Widget _buildExpandedTextField({
    required String hintText,
    required bool isFocused,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: isFocused ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: TextField(
            onTap: onTap,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildTipoTextField() {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: checkInFocused ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: PopupMenuButton<String>(
          initialValue: selectedTipo,
          onSelected: (value) {
            setState(() {
              selectedTipo = value;
              checkInFocused = true;
              checkOutFocused = false;
              guestsFocused = false;
            });
          },
          offset: Offset(0, 70), // Ajuste o deslocamento vertical conforme necessário
          itemBuilder: (BuildContext context) {
            return ['Casa', 'Apartamento', 'Terreno', 'Comercial']
                .map<PopupMenuItem<String>>((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: SizedBox( // Defina um tamanho fixo para os itens do menu
                  width: 200, // Largura desejada para os itens do menu
                  child: Text(value),
                ),     
              );
            }).toList();
          },
          child: ListTile(
            title: Text(
              selectedTipo.isNotEmpty ? selectedTipo : 'Tipo de imóvel',
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ),
    ),
  );
}
 Widget _buildFinalidadeTextField() {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: checkInFocused ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: PopupMenuButton<String>(
          initialValue: selectedFin,
          onSelected: (value) {
            setState(() {
              selectedFin = value;
              checkInFocused = true;
              checkOutFocused = false;
              guestsFocused = false;
            });
          },
          offset: Offset(0, 70), // Ajuste o deslocamento vertical conforme necessário
          itemBuilder: (BuildContext context) {
            return ['Compra', 'Aluguel']
                .map<PopupMenuItem<String>>((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: SizedBox( // Defina um tamanho fixo para os itens do menu
                  width: 200, // Largura desejada para os itens do menu
                  child: Text(value),
                ),     
              );
            }).toList();
          },
          child: ListTile(
            title: Text(
              selectedFin.isNotEmpty ? selectedFin : 'Finalidade',
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ),
    ),
  );
}

}
