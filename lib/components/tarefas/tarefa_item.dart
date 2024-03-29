import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/tarefas/tarefas.dart';
import '../../models/tarefas/tarefasList.dart';
import '../../theme/appthemestate.dart';

class TarefaItem extends StatelessWidget {
  final TarefasCorretor tarefa;
  final bool isChecked;
  final ValueChanged<bool>? onTarefaStateChanged;

  const TarefaItem({
    required this.tarefa,
    required this.isChecked,
    this.onTarefaStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (newValue) {
              if (newValue != null) {
                onTarefaStateChanged
                    ?.call(newValue); // Chamada da função ajustada
              }
            },
            activeColor: Color(0xFF6e58e9),
            checkColor:
                themeNotifier.isDarkModeEnabled ? Colors.white : Colors.black,
            side: BorderSide(
              color: themeNotifier.isDarkModeEnabled
                  ? Colors.black
                  : Color(0xFF6e58e9),
            ),
          ),

          SizedBox(width: 10), // Espaçamento entre a checkbox e o texto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: IntrinsicHeight(
                  child: Text(
                    '${tarefa.titulo}',
                    style: TextStyle(
                      color: !themeNotifier.isDarkModeEnabled ? Colors.black : Colors.white,
                      fontSize: isSmallScreen ? 15 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: IntrinsicHeight(
                  child: Text(
                    '${tarefa.descricao}',
                    style: TextStyle(
                      fontSize: 14,
                      color: !themeNotifier.isDarkModeEnabled ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
