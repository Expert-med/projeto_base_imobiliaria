import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/pages/corretores/landingCorretor.dart';
import '../../models/corretores/corretor.dart';



class CorretorItem extends StatelessWidget {
  final bool isDarkMode;
  final Corretor corretor;

  const CorretorItem(this.isDarkMode, this.corretor, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
  print('entrou em corretorItem');
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(corretor.logoUrl),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: IntrinsicHeight(
                  child: Text(
                    '${corretor.name}',
                    style: TextStyle(
                      color: !isDarkMode ? Colors.black :Colors.white,
                      fontSize: isSmallScreen ? 15 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: IntrinsicHeight(
                  child: Text(
                    '${corretor.email}',
                    style: TextStyle(
                      fontSize: 14,
                      color: !isDarkMode ? Colors.black :Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {
              _showOptionsDialog(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: !isDarkMode ? Colors.black :Colors.white,
              ),
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.info,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed('/corretor/${corretor.id}');

            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: !isDarkMode ? Colors.black :Colors.white,
              ),
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.info,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Escolha uma opção"),
          actions: [
            TextButton(
              onPressed: () {
                // Add your action for the first button here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Ir para landing page"),
            ),
            TextButton(
              onPressed: () {
                
              },
              child: Text("Editar landing page"),
            ),
          ],
        );
      },
    );
  }
}
