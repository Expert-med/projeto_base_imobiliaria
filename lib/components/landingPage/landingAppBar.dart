import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> variaveis;
  final String nome;
  final bool showBackButton; 

  const CustomAppBar({
    Key? key,
    required this.variaveis,
    required this.nome,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int corInt = int.parse(variaveis["cores"]!["corPrincipal"]!);
    Color cor = Color(corInt);
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(left: 50.0), // Adiciona padding à esquerda
        child: Image.network(
          variaveis["appBar"]!["logo"]!,
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
      leading:
          showBackButton // Verifica se o botão de retorno deve ser mostrado
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.toNamed('/home');
                  },
                )
              : null,
      toolbarHeight: 200,
      backgroundColor: cor,
      actions: [
       
        if(variaveis["appBar"]!["link1"]! != 'link1')
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            // TextButton para a Solução
            onPressed: () {},
            child: Text(
              variaveis["appBar"]!["link1"]!,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        if(variaveis["appBar"]!["link2"]! != 'link2')
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            // TextButton para os Benefícios
            onPressed: () {
              // Navegar para os Benefícios
            },
            child: Text(
              variaveis["appBar"]!["link2"]!,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        if(variaveis["appBar"]!["link3"]! != 'link3')
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            // TextButton para as Perguntas
            onPressed: () {
              // Navegar para as Perguntas
            },
            child: Text(
              variaveis["appBar"]!["link3"]!,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        if(variaveis["appBar"]!["botao1"]! != 'botao 1')
        Padding(
          padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
          child: ElevatedButton(
            onPressed: () => {},
            style: ElevatedButton.styleFrom(
              shadowColor: Color.fromARGB(255, 255, 253, 253),
              fixedSize: Size(100, 5),
              elevation: 10.0,
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Text(
              variaveis["appBar"]!["botao1"]!,
            ),
          ),
        ),
        if(variaveis["appBar"]!["botao2"]! != 'botao 2')
        Padding(
          padding: EdgeInsets.only(right: 100.0, top: 8, bottom: 8),
          child: ElevatedButton(
            onPressed: () => {},
            style: ElevatedButton.styleFrom(
              shadowColor: Color.fromARGB(255, 255, 253, 253),
              fixedSize: Size(110, 10),
              elevation: 10.0,
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(color: Colors.black),
              ),
            ),
            child: Text(
              variaveis["appBar"]!["botao2"]!,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
         Padding(
          padding: EdgeInsets.only(right: 100.0, top: 8, bottom: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Color.fromARGB(255, 255, 253, 253),
              fixedSize: Size(110, 10),
              elevation: 10.0,
              backgroundColor: Color.fromARGB(255, 231, 231, 231),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(color: Colors.black),
              ),
            ),
            onPressed: () {
              Get.toNamed('/corretor/${nome}/imoveis');
            },
            child: Text(
              'Imóveis',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
