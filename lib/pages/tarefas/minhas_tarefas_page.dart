import 'package:flutter/material.dart';

import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:provider/provider.dart';
import '../../components/custom_menu.dart';
import '../../components/propostas/proposta_cad_form.dart';
import '../../components/tarefas/tarefa_add_modal.dart';
import '../../theme/appthemestate.dart';
import 'tarefas_list_view_page.dart';

class MinhasTarefas extends StatefulWidget {
  const MinhasTarefas({super.key});

  @override
  State<MinhasTarefas> createState() => _MinhasTarefasState();
}

class _MinhasTarefasState extends State<MinhasTarefas> {

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
      final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
      
    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              subtitle: '',
              title: 'Criar nova proposta',
              isDarkMode: false,
            )
          : null,
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
                child: TarefasListView(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
        onPressed: () {
          setState(() {
            themeNotifier.enableDarkMode(!themeNotifier.isDarkModeEnabled);
          });
        },
        child: Icon(Icons.lightbulb),
      ),
          SizedBox(height: 16), // Espaçamento entre os botões
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return AddTarefaModal();
                },
              );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      drawer: isSmallScreen ? CustomMenu() : null,
    );
  }
}
