import 'package:flutter/material.dart';

class Porque extends StatelessWidget {
  final Map<String, dynamic> variaveis;

  const Porque({
    Key? key,
    required this.variaveis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int corInt = int.parse(variaveis["cores"]!["corPrincipal"]!);
    Color cor = Color(corInt);
    return Container(
      height: 300,
      color: Color.fromARGB(255, 134, 133, 133),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              variaveis['porque']!["titulo_1"]!,
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              variaveis['porque']!["subtitulo_1"]!,
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
              onPressed: () => {},
              style: ElevatedButton.styleFrom(
                shadowColor: Color.fromARGB(255, 253, 253, 253),
                elevation: 10.0,
                minimumSize: Size(200, 60),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Text(variaveis['porque']!["texto_botao_1"]!,),
            ),
          ],
        ),
      ),
    );
  }
}
