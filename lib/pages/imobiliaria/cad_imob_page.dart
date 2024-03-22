import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/core/models/imobiliaria_form_data.dart';
import 'package:projeto_imobiliaria/core/services/cadastros/cadastros_service.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';

import '../../components/cad_imovel_form.dart';
import '../../components/custom_menu.dart';
import '../../components/imobiliaria/cad_imobiliaria_form.dart';
import '../../main.dart';
import '../home_page.dart';

class CadastroImobiliaria extends StatefulWidget {
  const CadastroImobiliaria({Key? key});

  @override
  State<CadastroImobiliaria> createState() => _CadastroImobiliariaState();
}

class _CadastroImobiliariaState extends State<CadastroImobiliaria> {
  late bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;


Future<void> _handleSubmit(ImobiliariaFormData formData) async {
    try {
      if (!mounted) return;

        await CadastroService().cadastroImobiliaria(
          formData.nome, formData.url_base, formData.url_logo
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyHomePage(), 
          ),
        );
      
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text('Ocorreu um erro ao cadastrar: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      if (!mounted) return;
    }
  }
  
    return Scaffold(
      backgroundColor: Colors.white, // Definindo o plano de fundo como branco
      appBar: isSmallScreen ? CustomAppBar(subtitle: '', title: 'Cadastro de Imoveis',isDarkMode: isDarkMode,) : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (!isSmallScreen)
                SizedBox(
                  width: 250, // Largura mínima do CustomMenu
                  child: CustomMenu(),
                ),
              Expanded(
                child: Container(
                  color: isDarkMode ? Colors.black : Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView( // Adicionando SingleChildScrollView aqui
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CadImobiliariaForm(isDarkMode: isDarkMode,onSubmit: _handleSubmit,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        child: Icon(Icons.lightbulb),
      ),
      drawer: isSmallScreen ? CustomMenu() : null,
    );
  }
}
