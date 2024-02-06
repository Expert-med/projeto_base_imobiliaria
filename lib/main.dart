import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projeto_imobiliaria/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'checkPage.dart';
import 'core/services/firebase/firebase_options.dart';
import 'models/houses/house_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool isDarkMode = false; // Adicione esta linha para definir o modo claro como padrão
  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode; // Adicione este parâmetro

  MyApp({required this.isDarkMode}); // Atualize o construtor

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> embalagens = [];

  MaterialColor myPrimaryColor = MaterialColor(
    0xFF6a66ff,
    <int, Color>{
      50: Color(0xFF3e88f3),
      100: Color(0xFF6e58e9),
      200: Color(0xFF3e88f3),
      300: Color(0xFF6e58e9),
      400: Color(0xFF3e88f3),
      500: Color(0xFF3e88f3),
      600: Color(0xFF6e58e9),
      700: Color(0xFF3e88f3),
      800: Color(0xFF6e58e9),
      900: Color(0xFF3e88f3),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
       ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
    ],
    child:GetMaterialApp(
      title: 'CME Projeto',
      theme: isDarkMode
          ? ThemeData(
              primarySwatch: myPrimaryColor,
              brightness: Brightness.dark,
            )
          : ThemeData(
              colorScheme: ThemeData().colorScheme.copyWith(
                primary:Color(0xFF6e58e9),
                secondary:Color(0xFF6e58e9),
              ),
              textTheme: TextTheme(
                bodyText2: TextStyle(
                  fontFamily: 'Montserrat',
                ),
                bodyText1: TextStyle(
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
      darkTheme: ThemeData(
        primarySwatch: myPrimaryColor,
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => checkPage(),
        ),
      ],
      home: checkPage(),
      debugShowCheckedModeBanner: false,
    ),);
  
}
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    MyHomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
