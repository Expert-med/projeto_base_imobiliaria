import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

import '../core/data/user_repository.dart';
import '../core/models/UserProvider.dart';
import '../core/models/User_firebase_service.dart';
import '../models/clientes/Clientes.dart';
import '../models/corretores/corretor.dart';

class UserConfig extends StatefulWidget {
  const UserConfig({Key? key}) : super(key: key);

  @override
  State<UserConfig> createState() => _UserConfigState();
}

class _UserConfigState extends State<UserConfig> {
  late TextEditingController _nameController;
  bool isDarkMode = true;
dynamic _user;

@override
void initState() {
  super.initState();
  _nameController = TextEditingController();
  Provider.of<UserProvider>(context, listen: false).initializeUser();
  UserRepository().loadCurrentUser().then((currentUser) {
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
        _nameController.text = _user!.name;
        print('o usuario atual é ${_user!.name}, com id=${_user!.id}');
      });
    } else {
      print('Nenhum usuário atual encontrado.');
    }
  }).catchError((error) {
    print('Erro ao carregar o usuário atual: $error');
  });
}


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
            _user!.logoUrl = downloadURL;
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

        if (_user!.tipoUsuario == 0) {
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('clientes')
              .where('uid', isEqualTo: user.uid)
              .get();
          snapshot.docs.forEach((doc) async {
            await doc.reference
                .update({'logoUrl': newImageUrl, 'name': newName});
          });
        } else {
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('corretores')
              .where('uid', isEqualTo: user.uid)
              .get();
          snapshot.docs.forEach((doc) async {
            await doc.reference
                .update({'logoUrl': newImageUrl, 'name': newName});
          });
        }
        setState(() {
          _user = CurrentUser(
            id: user.uid,
            name: newName,
            email: user.email ?? '',
            imageUrl: newImageUrl,
            tipoUsuario: _user!.tipoUsuario,
            contato: _user!.contato,
            preferencias: _user!.preferencias,
            historico: _user!.historico,
            historicoBusca: _user!.historicoBusca,
            imoveisFavoritos: _user!.imoveisFavoritos,
            UID: _user!.UID,
            num_identificacao: _user!.num_identificacao,
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white : Colors.black38,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: _user! != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(_user!.logoUrl),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pickAndUploadImage(_user!.id);
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
                                'Email: ${_user!.email}',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.black54
                                      : Colors.white,
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
                                'Tipo de conta: ${_user!.tipoUsuario == 1 ? "Corretor" : "Cliente"}',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.black54
                                      : Colors.white,
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
                                'Endereço:\n',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.black54
                                      : Colors.white,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bairro: ${_user!.contato['endereco']['bairro']}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  'CEP: ${_user!.contato['endereco']['cep']}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Cidade: ${_user!.contato['endereco']['cidade']}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Complemento: ${_user!.contato['endereco']['complemento']}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Estado: ${_user!.contato['endereco']['estado']}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Logradouro: ${_user!.contato['endereco']['logradouro']}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Número: ${_user!.contato['endereco']['numero']}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                       
                        // Row(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Text(
                        //         'Preferências: \nBairro: ${_user!.preferencias[0]['bairro']}\nCaracterísticas: ${_user!.preferencias[0]['caracteristicas']}\nFaixa de preço: ${_user!.preferencias[0]['faixa_preco']}\nTipo de imóvel: ${_user!.preferencias[0]['tipo_imovel']}',
                        //         style: TextStyle(
                        //           color: isDarkMode
                        //               ? Colors.black54
                        //               : Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
                                _nameController.text, _user!.logoUrl);
                          },
                          child: Text('Salvar Informações'),
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
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
