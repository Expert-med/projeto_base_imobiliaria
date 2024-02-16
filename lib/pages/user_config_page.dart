import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../core/models/user.dart';

class UserConfig extends StatefulWidget {
  const UserConfig({Key? key}) : super(key: key);

  @override
  State<UserConfig> createState() => _UserConfigState();
}

class _UserConfigState extends State<UserConfig> {
  late ChatUser _user;
  late TextEditingController _nameController;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _initializeData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Set the user information to the state
        setState(() {
          _user = ChatUser(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            imageUrl: user.photoURL ?? '',
            tipoUsuario: 0, // Define the user type as needed
          );
          _nameController.text = _user.name;
          print(_user.imageUrl);
        });
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> pickAndUploadImage(String idConta) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.isNotEmpty) {
      for (PlatformFile file in result.files) {
        Uint8List? fileBytes;
        String fileName;

        if (kIsWeb) {
          fileBytes = file.bytes!;
          fileName = 'logo-$idConta.jpeg';
        } else {
          fileBytes = file.bytes;
          fileName = 'logo-$idConta.jpeg';
        }

        try {
          await firebase_storage.FirebaseStorage.instance
              .ref('logos/$fileName')
              .putData(fileBytes!);

          String downloadURL = await firebase_storage.FirebaseStorage.instance
              .ref('logos/$fileName')
              .getDownloadURL();

          setState(() {
            _user.imageUrl = downloadURL;
          });
        } catch (e) {
          print('Erro ao fazer upload da imagem: $e');
        }
      }
    }
  }

  Future<void> _updateUserNameAndImageUrl(
      String newName, String newImageUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        await user.updatePhotoURL(newImageUrl);

        if (_user.tipoUsuario == 0) {
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('clientes')
              .where('uid', isEqualTo: user.uid)
              .get();
          snapshot.docs.forEach((doc) async {
            await doc.reference
                .update({'imageUrl': newImageUrl, 'name': newName});
          });
        } else {
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('corretores')
              .where('uid', isEqualTo: user.uid)
              .get();
          snapshot.docs.forEach((doc) async {
            await doc.reference
                .update({'imageUrl': newImageUrl, 'name': newName});
          });
        }
        setState(() {
          _user = ChatUser(
            id: user.uid,
            name: newName,
            email: user.email ?? '',
            imageUrl: newImageUrl,
            tipoUsuario: _user.tipoUsuario,
          );
          _nameController.text = newName;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nome e imagem atualizados com sucesso')),
        );
      }
    } catch (e) {
      print('Erro ao atualizar nome e imagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar nome e imagem')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações do Usuário'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white : Colors.black38,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: _user != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(_user.imageUrl),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pickAndUploadImage(_user.id);
                        },
                        child: Text(
                          "Alterar Imagem",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 10.0,
                          backgroundColor: Color(0xFF6e58e9),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Email: ${_user.email}',
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.black54 : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                       Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Tipo de conta: ${_user.tipoUsuario == 1 ? "Corretor" : "Cliente"}',
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.black54 : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            15), //apply padding to all four sides
                        child: Text(
                          "Nome",
                          style: TextStyle(
                            color: Color(0xFF6e58e9),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black12,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white),
                        validator: (localEmail) {
                          final email = localEmail ?? '';
                          if (!email.contains('@')) {
                            return 'E-mail nformado não é válido.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _updateUserNameAndImageUrl(
                              _nameController.text, _user.imageUrl);
                        },
                        child: Text('Salvar Informações'),
                      ),
                      
                    ],
                  )
                : CircularProgressIndicator(),
          ),
        ),
      ),
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
