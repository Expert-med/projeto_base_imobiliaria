import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

import '../core/models/UserProvider.dart';
import '../core/models/User_firebase_service.dart';

class UserConfig extends StatefulWidget {
  const UserConfig({Key? key}) : super(key: key);

  @override
  State<UserConfig> createState() => _UserConfigState();
}

class _UserConfigState extends State<UserConfig> {
  late CurrentUser _user = CurrentUser(
    id: '',
    name: '',
    email: '',
    imageUrl: '',
    tipoUsuario: 50,
    contato: {},
    preferencias: [],
    historico: [],
    historicoBusca: [],
    imoveisFavoritos: [],
    UID: '',
  );
  late TextEditingController _nameController;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    Provider.of<UserProvider>(context, listen: false).initializeUser();
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
        QuerySnapshot<Map<String, dynamic>> clientesSnapshot =
            await FirebaseFirestore.instance
                .collection('clientes')
                .where('uid', isEqualTo: user.uid)
                .get();

        QuerySnapshot<Map<String, dynamic>> corretoresSnapshot =
            await FirebaseFirestore.instance
                .collection('corretores')
                .where('uid', isEqualTo: user.uid)
                .get();

        QuerySnapshot<Map<String, dynamic>> querySnapshot;
        if (clientesSnapshot.docs.isNotEmpty) {
          querySnapshot = clientesSnapshot;
        } else if (corretoresSnapshot.docs.isNotEmpty) {
          querySnapshot = corretoresSnapshot;
        } else {
          print('Usuário não encontrado nas coleções clientes e corretores');
          return;
        }

        Map<String, dynamic> data = querySnapshot.docs.first.data();
        print(data);
        dynamic preferenciasData = data['preferencias'];
        List<Map<String, dynamic>> preferencias = [];

        if (preferenciasData != null) {
          if (preferenciasData is Map) {
            // Convertendo o mapa dinâmico para um mapa de string
            Map<String, dynamic> preferenciasMap = {};
            preferenciasData.forEach((key, value) {
              preferenciasMap[key.toString()] = value;
            });

            // Adicionando o mapa convertido à lista de preferencias
            preferencias.add(preferenciasMap);
          } else {
            // Handle other data types or unexpected data format
            print('Erro: formato inesperado para preferencias');
          }
        }

        List<String> historico = [];
        if (data['historico'] != null) {
          if (data['historico'] is List) {
            historico = List<String>.from(data['historico']);
          } else {
            print('Erro: historico não é uma lista');
          }
        }

        List<String> imoveisFavoritos = [];

        dynamic imoveisFavoritosData = data['imoveis_favoritos'];
        if (imoveisFavoritosData != null) {
          if (imoveisFavoritosData is List) {
            // Verificar se todos os elementos na lista são strings
            if (imoveisFavoritosData.every((element) => element is String)) {
              imoveisFavoritos = List<String>.from(imoveisFavoritosData);
            } else {
              print(
                  'Erro: imoveis_favoritos contém elementos que não são strings');
            }
          } else {
            print('Erro: imoveis_favoritos não é uma lista');
          }
        }
        List<String> historicoBusca = [];
        if (data['historico_busca'] != null) {
          if (data['historico_busca'] is List) {
            historicoBusca = List<String>.from(data['historico_busca']);
          } else {
            print('Erro: historico_busca não é uma lista');
          }
        }

        print("esses são os imóveis favoritos: $imoveisFavoritos");

        setState(() {
          _user = CurrentUser(
            id: user.uid,
            name: data['name'] ?? '',
            email: data['email'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
            tipoUsuario: data['tipo_usuario'] ?? 0,
            contato: data['contato'] ?? {},
            preferencias: preferencias,
            historico: historico,
            historicoBusca: historicoBusca,
            imoveisFavoritos: imoveisFavoritos, // Corrigido aqui
            UID: data['UID'] ?? '',
          );
          _nameController.text = _user.name;
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
          _user = CurrentUser(
            id: user.uid,
            name: newName,
            email: user.email ?? '',
            imageUrl: newImageUrl,
            tipoUsuario: _user.tipoUsuario,
            contato: _user.contato,
            preferencias: _user.preferencias,
            historico: _user.historico,
            historicoBusca: _user.historicoBusca,
            imoveisFavoritos: _user.imoveisFavoritos,
            UID: _user.UID,
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
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Endereço:\n',
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.black54 : Colors.white,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bairro: ${_user.contato['endereco']['bairro']}',
                                  style: TextStyle(
                                    color:
                                        isDarkMode ? Colors.black : Colors.white,
                                  ),
                                ),
                                Text(
                                  'CEP: ${_user.contato['endereco']['cep']}',
                                  style: TextStyle(
                                    color:
                                        isDarkMode ? Colors.black : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Cidade: ${_user.contato['endereco']['cidade']}',
                                  style: TextStyle(
                                    color:
                                        isDarkMode ? Colors.black : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Complemento: ${_user.contato['endereco']['complemento']}',
                                  style: TextStyle(
                                    color:
                                        isDarkMode ? Colors.black : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Estado: ${_user.contato['endereco']['estado']}',
                                  style: TextStyle(
                                    color:
                                        isDarkMode ? Colors.black : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Logradouro: ${_user.contato['endereco']['logradouro']}',
                                  style: TextStyle(
                                    color:
                                        isDarkMode ? Colors.black : Colors.white,
                                  ),
                                ),
                                Text(
                                  'Número: ${_user.contato['endereco']['numero']}',
                                  style: TextStyle(
                                    color:
                                        isDarkMode ? Colors.black : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'IDS IMÓVEIS FAVORITOS: ${_user.imoveisFavoritos}',
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
                                'Preferências: \nBairro: ${_user.preferencias[0]['bairro']}\nCaracterísticas: ${_user.preferencias[0]['caracteristicas']}\nFaixa de preço: ${_user.preferencias[0]['faixa_preco']}\nTipo de imóvel: ${_user.preferencias[0]['tipo_imovel']}',
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
