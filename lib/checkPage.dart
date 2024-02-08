import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_imobiliaria/pages/auth/auth_page.dart';
import 'package:projeto_imobiliaria/pages/home_page.dart';

class checkPage extends StatefulWidget {
  const checkPage({super.key});
  


  @override
  State<checkPage> createState() => _checkPageState();
}

class _checkPageState extends State<checkPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late DocumentReference hospitalDoc;
  int hospitalValue = 0;
  StreamSubscription? streamSubscription;
  late int valida = 0;
  late String idTemp = '';
  late DocumentReference clienteDoc;
  String idCliente = '';
  bool _isMounted = false; 


  @override
  initState() {
    super.initState();
    streamSubscription = FirebaseAuth.instance .authStateChanges()
      .listen((User? user) async {
        if (user == null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        }
      });
    
    _isMounted = true;
  }
  
  @override
  void dispose(){
    streamSubscription!.cancel();
    super.dispose();
  }


  
  

  bool isUserAuthorized(String userUid) {
    const String allowedUid = 'j5ePhUCxE3cPhzyHFejApn4aFnb2';
    return userUid == allowedUid;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}