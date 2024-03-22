import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:provider/provider.dart';

import '../../components/cad_imovel_form.dart';
import '../../components/custom_menu.dart';
import '../../core/models/imovel_form_data.dart';
class CadastroImovel extends StatefulWidget {
  const CadastroImovel({Key? key});

  @override
  State<CadastroImovel> createState() => _CadastroImovelState();
}

class _CadastroImovelState extends State<CadastroImovel> {


  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen ? CustomAppBar(subtitle: '', title: 'Cadastro de Imoveis',isDarkMode: false,) : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // if (!isSmallScreen)
              //   SizedBox(
              //     width: 250, // Largura mínima do CustomMenu
              //     child: CustomMenu(isDarkMode: isDarkMode),
              //   ),
              Expanded(
                child: Container(
                  
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CadImovelForm()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
     
      drawer: isSmallScreen ? CustomMenu() : null,
    );
  }
}