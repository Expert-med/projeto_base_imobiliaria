import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/negociacao/negociacaoList.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:provider/provider.dart';
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
      await Provider.of<NegociacaoList>(context, listen:false).adicionarNegociacao(
        formData.imovel,
        formData.cliente,
        formData.corretor
      );
Navigator.of(context).pop();
    
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
  
    return Scaffold(
     
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
             
              Expanded(
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
            ],
          );
        },
      ),
      
    );
  }
}
