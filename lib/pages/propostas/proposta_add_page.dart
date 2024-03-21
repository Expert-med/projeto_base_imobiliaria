import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacaoList.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import '../../components/custom_menu.dart';
import '../../components/propostas/proposta_cad_form.dart';
import '../../main.dart';
import '../../models/negociacao/negociacao_form_data.dart';
import '../home_page.dart';

class CadastroProposta extends StatefulWidget {
  const CadastroProposta({Key? key});

  @override
  State<CadastroProposta> createState() => _CadastroPropostaState();
}

class _CadastroPropostaState extends State<CadastroProposta> {
  late bool isDarkMode = false;
  Future<void> _handleSubmit(NegociacaoFormData formData) async {
    try {
      // Login
      await NegociacaoList().adicionarNegociacao(
        formData.imovel,
        formData.cliente,
        formData.corretor
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

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              subtitle: '',
              title: 'Criar nova proposta',
              isDarkMode: isDarkMode,
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (!isSmallScreen)
                SizedBox(
                  width: 250, // Largura mínima do CustomMenu
                  child: CustomMenu(isDarkMode: isDarkMode),
                ),
              Expanded(
                child: Container(
                  color: isDarkMode ? Colors.black : Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    // Adicionando SingleChildScrollView aqui
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CadPropostaForm(
                          onSubmit: _handleSubmit,
                          isDarkMode: isDarkMode,
                        )
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
      drawer: isSmallScreen ? CustomMenu(isDarkMode: isDarkMode) : null,
    );
  }
}
