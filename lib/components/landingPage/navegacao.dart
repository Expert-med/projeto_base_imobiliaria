import 'package:flutter/material.dart';

class Navegacao extends StatelessWidget {
  final Map<String, dynamic> variaveis;
  const Navegacao({
    Key? key,
     required this.variaveis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int corInt = int.parse(variaveis["cores"]!["corPrincipal"]!);
    Color cor = Color(corInt);
    return Container(
      height: 300,
      color: cor,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Image.network(
                        variaveis["links"]!["logo"]!,
                        fit: BoxFit.cover, // Adicionando BoxFit.cover para a imagem ocupar todo o espaço do container
                      ), 
                      SizedBox(height: 100,)
                    ],
                  ),
                ),
                if(variaveis['links']!["link"] != 'Link')
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                    ],
                  ),
                ),
                if(variaveis['links']!["link"] != 'Link')
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                      
                    ],
                  ),
                ),
                if(variaveis['links']!["link"] != 'Link')
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(variaveis['links']!["link"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                    ],
                  ),
                ),
                SizedBox(width: 40,),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text('Subscreva a nossa Newsletter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Inscreva-se na nossa newsletter e fique a par dos nossos lançamentos.', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(labelText: "O seu email"),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              shadowColor: Color.fromARGB(255, 255, 253, 253),
                              elevation: 10.0,
                              minimumSize: Size(200, 60),
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Text("Botão"),
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
    );
  }
}
