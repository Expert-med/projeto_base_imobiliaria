import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';

import '../components/custom_menu.dart';
import '../components/imovel/imovel_carrousel.dart';
import '../components/search_row.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isDarkMode;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    isDarkMode = false;
    getCurrentUser();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    String getGreeting() {
      var hour = DateTime.now().hour;

      if (hour >= 6 && hour < 12) {
        return 'Bom dia, ${currentUser?.displayName?.toString()}!';
      } else if (hour >= 12 && hour < 19) {
        return 'Boa tarde, ${currentUser?.displayName?.toString()}!';
      } else {
        return 'Boa noite, ${currentUser?.displayName?.toString()}!';
      }
    }

    return Scaffold(
      appBar: isSmallScreen ? CustomAppBar(subtitle: '', title: 'Home',isDarkMode: isDarkMode,) : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if(!isSmallScreen)
              CustomMenu(isDarkMode: isDarkMode),
              Expanded(
                child: Container(
                  color: isDarkMode ? Colors.black : Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'LarHub',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          Icon(Icons.home_outlined,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              size: 40)
                        ],
                      ),
                      Text(
                        getGreeting(),
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black54,
                        ),
                      ),
                      Text(
                        'Descubra sua residência ideal e a acompanhe!',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode ? Colors.white : Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Encontre sua melhor residência!',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode ? Colors.white : Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SearchRow(isDarkMode: isDarkMode),
                      SizedBox(
                        height: 10,
                      ),
                      ImovelCarousel(false, isDarkMode),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: isSmallScreen ? CustomMenu(isDarkMode: isDarkMode) : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
