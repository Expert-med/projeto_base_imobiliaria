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
  late bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen ? CustomAppBar(subtitle: '', title: 'Cadastro de Imoveis',isDarkMode: isDarkMode,) : null,
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/fundo_add_imovel.png'), // Coloque o caminho da sua imagem aqui
                      fit: BoxFit.cover,
                    ),
                    
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CadImovelForm(isDarkMode: isDarkMode)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
     
      drawer: isSmallScreen ? CustomMenu(isDarkMode: isDarkMode) : null,
    );
  }
}