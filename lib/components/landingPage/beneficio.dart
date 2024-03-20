import 'package:flutter/material.dart';

class Beneficio extends StatelessWidget {
  final int tipoPagina;
  final Map<String, Map<String, String>> variaveis;

  const Beneficio({
    Key? key,
    required this.tipoPagina,
    required this.variaveis
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.white,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: tipoPagina == 0
              ? _buildNormalLayout()
              : _buildInvertedLayout(),
        ),
      ),
    );
  }

  List<Widget> _buildNormalLayout() {
    return [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                variaveis["beneficio_0"]!["tag"]!,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              variaveis["beneficio_0"]!["titulo_beneficio_0"]!,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              variaveis["beneficio_0"]!["subtitulo_beneficio_0"]!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.check_box_outlined),
                    title: Text(variaveis["beneficio_0"]!["lista_beneficio_0_1"]!),
                  ),
                  ListTile(
                    leading: Icon(Icons.check_box_outlined),
                    title: Text(variaveis["beneficio_0"]!["lista_beneficio_0_2"]!),
                  ),
                  ListTile(
                    leading: Icon(Icons.check_box_outlined),
                    title: Text(variaveis["beneficio_0"]!["lista_beneficio_0_3"]!),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
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
              child: Text(variaveis["beneficio_0"]!["texto_botao"]!),
            ),
          ],
        ),
      ),
      SizedBox(width: 20),
      Container(
        width: 500,
        height: 450,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 201, 4, 4),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Image.network(
          variaveis["beneficio_0"]!["link_imagem"]!,
          fit: BoxFit.cover, // Adicionando BoxFit.cover para a imagem ocupar todo o espaço do container
        ),
      ),
    ];
  }

  List<Widget> _buildInvertedLayout() {
    return [
      Container(
        width: 500,
        height: 450,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 201, 4, 4),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Image.network(
          variaveis["beneficio_1"]!["link_imagem"]!,
          fit: BoxFit.cover, // Adicionando BoxFit.cover para a imagem ocupar todo o espaço do container
        ),
      ),
      SizedBox(width: 20),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
               variaveis["beneficio_1"]!["tag"]!,
               style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              variaveis["beneficio_1"]!["titulo_beneficio_1"]!,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              variaveis["beneficio_1"]!["subtitulo_beneficio_1"]!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.check_box_outlined),
                    title: Text(variaveis["beneficio_1"]!["lista_beneficio_0_1"]!,),
                  ),
                  ListTile(
                    leading: Icon(Icons.check_box_outlined),
                    title: Text(variaveis["beneficio_1"]!["lista_beneficio_0_2"]!,),
                  ),
                  ListTile(
                    leading: Icon(Icons.check_box_outlined),
                    title: Text(variaveis["beneficio_1"]!["lista_beneficio_0_3"]!,),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
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
              child: Text(variaveis["beneficio_1"]!["texto_botao"]!,),
            ),
          ],
        ),
      ),
    ];
  }
}
