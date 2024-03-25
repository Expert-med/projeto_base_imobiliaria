import 'package:flutter/material.dart';

class Perguntas extends StatelessWidget {
  final Map<String, dynamic> variaveis;

  const Perguntas({
    Key? key,
     required this.variaveis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int corInt = int.parse(variaveis["cores"]!["corPrincipal"]!);
    Color cor = Color(corInt);
    return variaveis['perguntas']!["titulo_1"]! != 'Título perguntas' ? Container(
      height: 500,
      color: cor,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(40), // Adiciona margem em todos os lados dos childrens
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    variaveis['perguntas']!["titulo_1"]!,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    variaveis['perguntas']!["subtitulo_1"]!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  ExpansionTile(
                    title: Text(
                      variaveis['perguntas']!["pergunta1"]!,
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          variaveis['perguntas']!["resposta1"]!,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  ExpansionTile(
                    title: Text(
                      variaveis['perguntas']!["pergunta2"]!,
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          variaveis['perguntas']!["resposta2"]!,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  ExpansionTile(
                    title: Text(
                      variaveis['perguntas']!["pergunta3"]!,
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          variaveis['perguntas']!["resposta3"]!,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ) : Container();
  }
}
