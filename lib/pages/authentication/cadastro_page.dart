import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_imobiliaria/pages/drawer_page.dart';
import 'package:uuid/uuid.dart';

import '../../components/formularios/custom_action_buttons.dart';
import '../../components/formularios/custom_textformfield.dart';
import '../../core/services/firebase/auth/checkPage.dart';
import '../../main.dart';
import '../../models/cnpj_model.dart';
import '../../repositories/cnpj_repository.dart';
import '../../util/dark_color_util.dart';
import '../../util/funcoes/buscasCME.dart';
import 'cadastro_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isDarkMode = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _importarBaseDeDados = false;
  final _cnpjController = TextEditingController(text: "");
  var cnpjModel = CNPJModel();
  var cnpjRepository = CNPJRepository();
  String id = '';
  final _firebaseAuth = FirebaseAuth.instance;
  final buscasCME instanciaBuscasCME = buscasCME();
  late DocumentReference hospitalDoc;
  String hospitalDocumentId = '';

  Uuid uuid = Uuid();
  int importacao = 0;
  bool loading = false;

  cadastrar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        generateId();
        salvarDadosNoFirestore(user);
        criarColecao();
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Conta criada! Faça seu login"),
            backgroundColor: Colors.green,
          ),
        );
         await FirebaseAuth.instance.signOut();
      }
    Navigator.pop(context);
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Crie uma senha mais forte"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email já cadastrado"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        // Lidar com outras exceções se necessário
      }
    }
  }

  String generateId() {
    String uniqueId = uuid.v4();
    id = uniqueId
        .substring(0, 4)
        .toUpperCase(); // Extrair os primeiros 4 caracteres
    return id;
  }

  Future<void> salvarDadosNoFirestore(User user) async {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String cnpj = _cnpjController.text;
    String idUsuario = id;

    try {
      await db.collection("usuarios").doc(idUsuario).set({
        'id': idUsuario,
        'nome': nome,
        'email': email,
        'cnpj': cnpj,
        'uid': user.uid,
      });

      // Atualize o displayName do usuário com o nome fornecido
      if (user != null) {
        await user.updateDisplayName(nome);
      }
    } catch (e) {
      // Lida com qualquer erro que possa ocorrer ao salvar os dados
      print('Erro ao salvar os dados: $e');
    }
  }

  void criarColecao() async {
    try {
      String hospitalId = id;
      String parentCollection = 'usuarios';

      // Referência ao documento pai onde a subcoleção será criada.
      DocumentReference parentDocRef = FirebaseFirestore.instance
          .collection(parentCollection)
          .doc(hospitalId);

      // Criação da subcoleção dentro do documento pai.
      await parentDocRef.collection('material').doc('0').set({});
      await parentDocRef.collection('kits').doc('0').set({});

      print('Subcoleção criada com sucesso dentro do documento do hospital.');
    } catch (e) {
      print('Erro ao criar a subcoleção: $e');
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
              child: Text("Nome Completo"),
            ),
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20))),
            ),
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              keyboardType: TextInputType
                  .emailAddress, 
             
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text("CNPJ"),
            ),
            TextFormField(
              controller: _cnpjController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20))),
            ),
            Padding(
              padding: EdgeInsets.all(15),
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: ElevatedButton(
  onPressed: () {
    cadastrar();
  },
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 10.0,
    ),
    child: Text(
      "Cadastrar",
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
        ? darkenColor(Color(0xFF6e58e9), 0.5)
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
