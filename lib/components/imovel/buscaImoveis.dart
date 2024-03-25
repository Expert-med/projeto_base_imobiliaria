import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovel.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import '../../theme/appthemestate.dart';
import 'imovel_item.dart';
import 'imovel_item_sem_barra.dart';

class BuscaImoveis extends StatefulWidget {


  const BuscaImoveis({Key? key})
      : super(key: key);

  @override
  _BuscaImoveisState createState() => _BuscaImoveisState();
}

class _BuscaImoveisState extends State<BuscaImoveis> {


  @override
  void initState() {
    super.initState();

  }
  bool checkInFocused = false;
  bool checkOutFocused = false;
  bool guestsFocused = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(40),
        height: 70,
        width: 1000,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color:Color.fromARGB(255, 238, 238, 238)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildExpandedTextField(
              hintText: 'Check-in Insira as datas',
              isFocused: checkInFocused,
              onTap: () {
                setState(() {
                  checkInFocused = true;
                  checkOutFocused = false;
                  guestsFocused = false;
                });
              },
            ),
            VerticalDivider(
                  color: Colors.grey, // Cor do divisor
                  thickness: 1, // Espessura do divisor
                  width: 20, // Largura do divisor
                  indent: 10, // Espaçamento superior do divisor
                  endIndent: 10, // Espaçamento inferior do divisor
                ),
            _buildExpandedTextField(
              hintText: 'Checkout Insira as datas',
              isFocused: checkOutFocused,
              onTap: () {
                setState(() {
                  checkInFocused = false;
                  checkOutFocused = true;
                  guestsFocused = false;
                });
              },
            ),
            VerticalDivider(
                  color: Colors.grey, // Cor do divisor
                  thickness: 1, // Espessura do divisor
                  width: 20, // Largura do divisor
                  indent: 10, // Espaçamento superior do divisor
                  endIndent: 10, // Espaçamento inferior do divisor
                ),
            _buildExpandedTextField(
              hintText: 'Quem Hóspedes?',
              isFocused: guestsFocused,
              onTap: () {
                setState(() {
                  checkInFocused = false;
                  checkOutFocused = false;
                  guestsFocused = true;
                });
              },
            ),
            ClipOval(
              child: Material(
                color: Color.fromARGB(255, 255, 255, 255),
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 255, 0, 0),
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
}
