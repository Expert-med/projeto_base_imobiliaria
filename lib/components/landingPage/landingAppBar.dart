import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> variaveis;
  const CustomAppBar({Key? key,  required this.variaveis,}) : super(key: key);

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
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){},
      ),
      toolbarHeight: 200,
      backgroundColor: cor,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton( // TextButton para a Solução
            onPressed: () {
              
            },
            child: Text(variaveis["appBar"]!["link1"]!,  style: TextStyle(color: Colors.black),),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton( // TextButton para os Benefícios
            onPressed: () {
              // Navegar para os Benefícios
            },
           child: Text(variaveis["appBar"]!["link2"]!,  style: TextStyle(color: Colors.black),),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton( // TextButton para as Perguntas
            onPressed: () {
              // Navegar para as Perguntas
            },
            child: Text(variaveis["appBar"]!["link3"]!,  style: TextStyle(color: Colors.black),),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton( // TextButton para o Porquê
            onPressed: () {
              // Navegar para o Porquê
            },
            child: Text(variaveis["appBar"]!["link4"]!,  style: TextStyle(color: Colors.black),),
          ),
        ),
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
          child: Text(variaveis["appBar"]!["botao1"]!,),
        ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 100.0, top: 8, bottom: 8),
          child: ElevatedButton(
          onPressed: () => {},
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
          child: Text(variaveis["appBar"]!["botao2"]!, style: TextStyle(color: Colors.black),),
        ),
        ),
        
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
