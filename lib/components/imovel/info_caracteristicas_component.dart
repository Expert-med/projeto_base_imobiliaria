import 'package:flutter/material.dart';

class ImovelCaracteristicasWidget extends StatelessWidget {
  final Map<String, dynamic> caracteristicas;

  final bool isDarkMode;

  const ImovelCaracteristicasWidget({
    Key? key,
    required this.caracteristicas,
   required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Color.fromARGB(255, 7, 0, 44);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (caracteristicas.isNotEmpty)
              Container(
                width: double.infinity, // Define a largura como o espaço disponível
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10), // Borda arredondada
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Características:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: caracteristicas.entries.map((entry) {
                          String valueString = entry.value is List
                              ? (entry.value as List).join(', ')
                              : entry.value.toString();
                          List<String> valuesList = valueString.split(', ');
                          List<Widget> valueWidgets = valuesList.map((value) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '-> $value',
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                            );
                          }).toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              ...valueWidgets,
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
