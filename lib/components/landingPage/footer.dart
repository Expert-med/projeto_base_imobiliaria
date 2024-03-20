import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final Map<String, dynamic> variaveis;
  const Footer({
    Key? key,
    required this.variaveis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int corInt = int.parse(variaveis["cores"]!["corPrincipal"]!);
    Color cor = Color(corInt);
    return Container(
      height: 100,
      color: cor,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(color: Colors.black,),
            Row(
              children: [
                SizedBox(width: 20),
                Text('© 2024 . Todos os direitos reservados Expert Vision', style: TextStyle(fontSize: 16)),
                SizedBox(width: 20),
                Text(variaveis['footer']!["politica"]!, style: TextStyle(fontSize: 16)),
                SizedBox(width: 20),
                Text(variaveis['footer']!["cookies"]!, style: TextStyle(fontSize: 16)),
                SizedBox(width: 20),
                Text(variaveis['footer']!["termos"]!, style: TextStyle(fontSize: 16)),
              ],
            )    
          ],
        ),
      ),
    );
  }
}
