import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/pages/drawer_page.dart';


import '../../main.dart';
import '../../util/dark_color_util.dart';
import '../home_page.dart';
import 'cadastro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isDarkMode = false;
    final TextEditingController senhaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late DocumentReference hospitalDoc;
  int hospitalValue = 0;
  String uid = '';
  bool _isMounted = false; 


login()async{
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text,
        );
        if(userCredential != null){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
         
          
        }
      }on FirebaseAuthException catch(e){
        if(e.code == 'user-not-found'){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuario não encontrado"),
            backgroundColor: Colors.redAccent,
            ),
          );
        }else if(e.code == "wrong-password"){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Senha incorreta"),
            backgroundColor: Colors.redAccent,
            ),
          );
        };
      }
  }
  
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        //appBar: CustomAppBar(subtitle: '', title: 'Titulo'),
       body: ListView(
        padding: EdgeInsets.all(12),
        children: [
           Padding(
              padding: EdgeInsets.all(15), //apply padding to all four sides
              child: Text("Email"),
            ),
          TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20))),
            ),
              Padding(
              padding: EdgeInsets.all(15), //apply padding to all four sides
              child: Text("Senha"),
            ),
            TextFormField(
              controller: _passwordController,
               obscureText: true,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 16.0),
           Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 10.0,
                     backgroundColor: isDarkMode
        ?   darkenColor(Color(0xFF6e58e9), 0.5)
        : Color(0xFF6e58e9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  TextButton(
                     onPressed: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => RegistrationPage(),
                         ),
                       );
                     },
                     child: Text(
                       "Criar conta",
                       style: TextStyle(
                         color:  isDarkMode
        ? Colors.white
        : Color(0xFF6e58e9),
                         fontSize: 15,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                ],
              ),
            ),
        ],
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isDarkMode = !isDarkMode;
            });
          },
          child: Icon(Icons.lightbulb),
        ),
      ),
    );
  }
}
