import 'package:flutter/material.dart';

class Solucao extends StatelessWidget {
  final Map<String, dynamic> variaveis;

  const Solucao({
    Key? key,
    required this.variaveis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  variaveis['solucao']!["titulo_1"] != 'Título Solução' ? Container(
      height: 300,
      color: Colors.white,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              variaveis['solucao']!["titulo_1"]!,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Icon(Icons.view_in_ar, size: 50,),
                      SizedBox(height: 10),
                      Text(variaveis['solucao']!["texto_icone_1"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Wrap(
                      children: [
                        Text(
                          variaveis['solucao']!["subtitulo_1"]!,
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Icon(Icons.view_in_ar, size: 50,),
                      SizedBox(height: 10),
                      Text(variaveis['solucao']!["texto_icone_2"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Wrap(
                      children: [
                        Text(
                          variaveis['solucao']!["subtitulo_2"]!,
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Icon(Icons.view_in_ar, size: 50,),
                      SizedBox(height: 10),
                      Text(variaveis['solucao']!["texto_icone_3"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Wrap(
                      children: [
                        Text(
                          variaveis['solucao']!["subtitulo_3"]!,
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ) : Container();
  }
}


