import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../components/custom_menu.dart';
import '../components/house_grid.dart';
import '../components/search_row.dart';
import 'authentication/login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    bool isDarkMode = false;

  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false, // Remove todas as rotas até a raiz
      );
    } catch (e) {
      print('Erro ao sair da conta: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
     String getGreeting() {
      var hour = DateTime.now().hour;

      if (hour >= 6 && hour < 12) {
        return 'Bom dia, Nome!';
      } else if (hour >= 12 && hour < 19) {
        return 'Boa tarde, Nome!';
      } else {
        return 'Boa noite, Nome!';
      }
    }
    
    return Scaffold(
      body: Row(
        children: [
          CustomMenu(isDarkMode: isDarkMode), // CustomMenu no lado esquerdo
          Expanded(
            child: Container(
              color: isDarkMode ? Colors.black : Colors.white, // Define a cor de fundo com base em isDarkMode
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getGreeting(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                       color: isDarkMode ? Colors.white : Colors.black54,
                    ),
                  ),
                  Text(
                    'Descubra o valor da sua casa e o acompanhe!',
                    style: TextStyle(
                      fontSize: 18,
                       color: isDarkMode ? Colors.white : Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Encontre sua melhor residência!',
                    style: TextStyle(
                      fontSize: 18,
                       color: isDarkMode ? Colors.white : Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  SearchRow(isDarkMode: isDarkMode),
                  SizedBox(height: 20,),
                   HouseGrid(false, isDarkMode),
                  ElevatedButton(
                    onPressed: () {
                      logOut();
                    },
                    child: Text('logout'),
                  ),

                ],
              ),
            ),
          ),
         
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDarkMode = !isDarkMode; // Alterna o valor de isDarkMode
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}