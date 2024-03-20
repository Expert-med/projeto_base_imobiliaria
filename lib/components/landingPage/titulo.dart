import 'package:flutter/material.dart';

class Titulo extends StatelessWidget {
  final Map<String, Map<String, String>> variaveis;

  const Titulo({
    Key? key,
    required this.variaveis,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.white,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(20), // Adiciona margem em todos os lados dos childrens
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    variaveis['titulo']!['titulo_1']!,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    variaveis['titulo']!['subtitulo_1']!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 15),
                  Flexible(
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 10.0,
                              minimumSize: Size(200, 60),
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                          ),
                          child: Text(variaveis['titulo']!['texto_botao_1']!)),
                        SizedBox(width: 10),
                        Flexible(child: Text(variaveis['titulo']!['texto_1']!))
                    ]),
                  )
                  
                ],
              ),
            ),
            SizedBox(width: 20), 
            Container(
              width: 500, // Define a largura da coluna da foto
              height: 450,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 201, 4, 4), // Cor de fundo da foto
                borderRadius: BorderRadius.circular(8.0), // Adiciona bordas arredondadas à foto
              ),
              child: Image.network(
              variaveis['titulo']!['link_imagem']!,
                fit: BoxFit.cover, // Adicionando BoxFit.cover para a imagem ocupar todo o espaço do container
              ),
            ),
          ],
        ),
      ),
    );
  }
}


