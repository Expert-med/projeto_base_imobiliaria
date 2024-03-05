import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../core/data/user_repository.dart';
import '../core/models/UserProvider.dart';
import '../core/models/User_firebase_service.dart';
import '../models/cep/via_cep_model.dart';
import '../models/clientes/Clientes.dart';
import '../models/corretores/corretor.dart';
import '../repositories/via_cep_repository.dart';

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

  Future<void> pickAndUploadLogoImage(String idConta) async {
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
             _updateUser(_user!.name, downloadURL);
          });
        } catch (e) {
          print('Erro ao fazer upload da imagem: $e');
        }
      }
    }
  }

  Future<void> pickAndUploadBannerImage(String idConta) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.isNotEmpty) {
      for (PlatformFile file in result.files) {
        Uint8List? fileBytes;
        String fileName;

        if (kIsWeb) {
          fileBytes = file.bytes!;
          fileName = 'banner-$idConta.jpeg';
        } else {
          fileBytes = file.bytes;
          fileName = 'banner-$idConta.jpeg';
        }

        try {
          await firebase_storage.FirebaseStorage.instance
              .ref('banners/$fileName')
              .putData(fileBytes!);

          String downloadURL = await firebase_storage.FirebaseStorage.instance
              .ref('banners/$fileName')
              .getDownloadURL();

          setState(() {
            _user!.infoBanner['image_url'] = downloadURL;
            _updateUser(_user!.name, _user!.logoUrl);
          });
        } catch (e) {
          print('Erro ao fazer upload da imagem: $e');
        }
      }
    }
  }

  Future<void> _updateUser(String newName, String newImageUrl) async {
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
            await doc.reference.update({
              'logoUrl': newImageUrl,
              'name': newName,
              'contato': _user!.contato,
              'email': _user!.email,
            });
          });
        } else {
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('corretores')
              .where('uid', isEqualTo: user.uid)
              .get();
          snapshot.docs.forEach((doc) async {
            await doc.reference.update({
              "id": user.uid,
              "name": newName,
              "email": user.email ?? '',
              "logoUrl": newImageUrl,
              "tipoUsuario": _user!.tipoUsuario,
              "contato": _user!.contato,
              'infoBanner': _user.infoBanner ?? {},
              'dados_profissionais': _user!.dadosProfissionais,
            });
          });
        }
        setState(() {
          // _user = CurrentUser(
          //   id: user.uid,
          //   name: newName,
          //   email: user.email ?? '',
          //   imageUrl: newImageUrl,
          //   tipoUsuario: _user!.tipoUsuario,
          //   contato: _user!.contato,
          //   preferencias: _user!.preferencias ?? [],
          //   historico: _user!.historico,
          //   historicoBusca: _user!.historicoBusca,
          //   imoveisFavoritos: _user!.imoveisFavoritos,
          //   UID: _user!.UID,
          //   num_identificacao: _user!.num_identificacao,
          // );
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

  void _showEditDialog(BuildContext context) {
   
    TextEditingController _textEditingController =
        TextEditingController(text: _user!.infoBanner['about_text']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Descrição'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Digite a nova descrição'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _user!.infoBanner['about_text'] = _textEditingController.text;
                });
                _updateUser(_user!.name, _user!.logoUrl);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditEmailContato(BuildContext context) {
    TextEditingController _textEditingController =
        TextEditingController(text: _user!.contato['email']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Email de contato'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Digite a nova descrição'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _user!.contato['email'] = _textEditingController.text;
                });
                _updateUser(_user!.name, _user!.logoUrl);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

    void _showEditContato(BuildContext context) {
    TextEditingController _textEditingController =
        TextEditingController(text: _user.contato['celular']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Informações de contato'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Digite o telefone'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _user.contato['celular'] = _textEditingController.text;
                });
                _updateUser(_user!.name, _user!.logoUrl);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }


  void _showEditEndereco(BuildContext context) {
    var viacepModel = ViaCepModel();
    var viaCepRepository = ViaCepRepository();
    TextEditingController _textNumero =
        TextEditingController(text: _user.contato['endereco']['numero']);
    TextEditingController _textCidade =
        TextEditingController(text: _user.contato['endereco']['cidade']);
    TextEditingController _textBairro =
        TextEditingController(text: _user.contato['endereco']['bairro']);
    TextEditingController _textLogradouro =
        TextEditingController(text: _user.contato['endereco']['logradouro']);
    TextEditingController _textEstado =
        TextEditingController(text: _user.contato['endereco']['estado']);
    TextEditingController _textCep =
        TextEditingController(text: _user.contato['endereco']['cep']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Endereço'),
          content: Column(
            children: [
              TextField(
                controller: _textCep,
                decoration:
                    InputDecoration(hintText: 'Digite o CEP'),
                onChanged: (String value) async {
                  var cep = value.replaceAll(new RegExp(r'[^0-9]'), '');
                  if (cep.length == 8) {
                    viacepModel = await viaCepRepository.consultarCep(cep);
                    setState(() {
                      _textLogradouro.text = viacepModel.logradouro ?? '';

                      _textBairro.text = viacepModel.bairro ?? '';

                      _textEstado.text = viacepModel.uf ?? '';

                      _textCep.text = viacepModel.cep ?? '';
                      _textCidade.text = viacepModel.localidade ?? '';

                      _textLogradouro.text =
                          viacepModel.logradouro.toString() ?? '';
                    });
                  }
                },
              ),
              TextField(
                controller: _textNumero,
                decoration: InputDecoration(
                  labelText: 'Número',
                  hintText: 'Digite o número do endereço',
                ),
              ),
              TextField(
                controller: _textCidade,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  hintText: 'Digite a cidade',
                ),
              ),
              TextField(
                controller: _textBairro,
                decoration: InputDecoration(
                  labelText: 'Bairro',
                  hintText: 'Digite o bairro',
                ),
              ),
              TextField(
                controller: _textLogradouro,
                decoration: InputDecoration(
                  labelText: 'Logradouro',
                  hintText: 'Digite o logradouro',
                ),
              ),
              TextField(
                controller: _textEstado,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  hintText: 'Digite o estado',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _user.contato['endereco']['numero'] = _textNumero.text;
                  _user.contato['endereco']['cidade'] = _textCep.text;
                  _user.contato['endereco']['bairro'] = _textBairro.text;
                  _user.contato['endereco']['logradouro'] =
                      _textLogradouro.text;
                  _user.contato['endereco']['estado'] = _textEstado.text;
                  _user.contato['endereco']['cep'] = _textCep.text;
                });
                _updateUser(_user!.name, _user!.logoUrl);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditEmailDadosProfissionais(BuildContext context) {
    TextEditingController _textEspecialidades = TextEditingController(
        text: _user!.dadosProfissionais['especialidades']);
    TextEditingController _textEditingRegiaoAtuacao = TextEditingController(
        text: _user!.dadosProfissionais['regiao_atuacao']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Dados Profissionais'),
          content: Column(
            children: [
              TextField(
                controller: _textEspecialidades,
                decoration:
                    InputDecoration(hintText: 'Digite a nova descrição'),
              ),
              TextField(
                controller: _textEditingRegiaoAtuacao,
                decoration:
                    InputDecoration(hintText: 'Digite a região de atuação'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _user!.dadosProfissionais['especialidades'] =
                      _textEspecialidades.text;
                  _user!.dadosProfissionais['regiao_atuacao'] =
                      _textEditingRegiaoAtuacao.text;
                });
                _updateUser(_user!.name, _user!.logoUrl);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditRedesSociais(BuildContext context) {
    TextEditingController _textFace = TextEditingController(
        text: _user!.contato['redes_sociais']['facebook']);
    TextEditingController _textLinkedin = TextEditingController(
        text: _user!.contato['redes_sociais']['linkedin']);
    TextEditingController _textInsta = TextEditingController(
        text: _user!.contato['redes_sociais']['instagram']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Redes Sociais'),
          content: Column(
            children: [
              TextField(
                controller: _textFace,
                decoration:
                    InputDecoration(hintText: 'Digite a url do Facebook'),
              ),
              TextField(
                controller: _textLinkedin,
                decoration:
                    InputDecoration(hintText: 'Digite a url do Linkedin'),
              ),
              TextField(
                controller: _textInsta,
                decoration:
                    InputDecoration(hintText: 'Digite a url do Instagram'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _user!.contato['redes_sociais']['facebook'] = _textFace.text;
                  _user!.contato['redes_sociais']['linkedin'] =
                      _textLinkedin.text;
                  _user!.contato['redes_sociais']['instagram'] =
                      _textInsta.text;
                });
                _updateUser(_user!.name, _user!.logoUrl);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações do Usuário'),
      ),
      backgroundColor:isDarkMode ? Colors.white : Colors.black87, 
      body: SingleChildScrollView(
        child: Container(
          
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
                            pickAndUploadLogoImage(_user!.id);
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
                            Text(
                              'Informações pessoais: ',
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.black54 : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5, top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Nome: ${_user.name} ',
                                              style: TextStyle(
                                                color: !isDarkMode
                                                    ? Colors.white
                                                    : Colors.black54,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Email: ${_user.contato['email'] != '' ? _user.contato['email'] : 'Não informado'} ',
                                              style: TextStyle(
                                                color: !isDarkMode
                                                    ? Colors.white
                                                    : Colors.black54,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Informações de contato',
                                              style: TextStyle(
                                                color: !isDarkMode
                                                    ? Colors.white
                                                    : Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                             SizedBox(width: 8),
                                            InkWell(
                                              onTap: () {
                                                _showEditContato(context);
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: !isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 2),
                                          child: Text(
                                            'Telefone: ${_user.contato['celular'] != '' ? _user.contato['celular'] : 'Não informado'} ',
                                            style: TextStyle(
                                              color: !isDarkMode
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          20), // Adicione um espaço entre as duas colunas
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Endereço:',
                                              style: TextStyle(
                                                color: !isDarkMode
                                                    ? Colors.white
                                                    : Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            InkWell(
                                              onTap: () {
                                                _showEditEndereco(context);
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: !isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Row(
                                            children: [
                                              Text(
                                                'CEP: ${_user.contato['endereco']['cep']} ',
                                                style: TextStyle(
                                                  color: !isDarkMode
                                                      ? Colors.white
                                                      : Colors.black54,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Spacer(flex: 1),
                                              Text(
                                                'Estado: ${_user.contato['endereco']['estado']} ',
                                                style: TextStyle(
                                                  color: !isDarkMode
                                                      ? Colors.white
                                                      : Colors.black54,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Spacer(flex: 1),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            'Endereço: ${_user.contato['endereco']['logradouro']} ',
                                            style: TextStyle(
                                              color: !isDarkMode
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            'Bairro: ${_user.contato['endereco']['bairro']} ',
                                            style: TextStyle(
                                              color: !isDarkMode
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            'Cidade: ${_user.contato['endereco']['cidade']} ',
                                            style: TextStyle(
                                              color: !isDarkMode
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            'Número: ${_user.contato['endereco']['numero']} ',
                                            style: TextStyle(
                                              color: !isDarkMode
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_user!.tipoUsuario == 1) ...[
                          Row(
                            children: [
                              Text(
                                'Informações públicas: ',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.black54
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Banner',
                                    style: TextStyle(
                                      color: !isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Image.network(
                                    _user!.infoBanner['image_url'].isNotEmpty
                                        ? _user!.infoBanner['image_url']
                                        : 'https://firebasestorage.googleapis.com/v0/b/imob-projeto-expmed.appspot.com/o/banners%2Fno_availablle.jpg?alt=media&token=6a2928bd-5eaa-45f2-919d-b7180bcd5e19',
                                    height: 200,
                                    width: 200,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      pickAndUploadBannerImage(_user!.id);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text('Alterar imagem'),
                                  ),
                                ],
                              ),
                             Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Descrição',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          _showEditDialog(context);
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _user!.infoBanner['about_text'].isNotEmpty
                                        ? _user!.infoBanner['about_text']
                                        : 'Não informado',
                                    style: TextStyle(
                                      color: !isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Redes Sociais: ',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          _showEditRedesSociais(context);
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _showEditDialog(context);
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.facebook,
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        _user!
                                                .contato['redes_sociais']
                                                    ['facebook']
                                                .isNotEmpty
                                            ? _user!.contato['redes_sociais']
                                                ['facebook']
                                            : 'Não informado',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _showEditDialog(context);
                                            },
                                            child: Icon(
                                              FontAwesomeIcons.linkedin,
                                              color: !isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            _user!
                                                    .contato['redes_sociais']
                                                        ['linkedin']
                                                    .isNotEmpty
                                                ? _user!.contato[
                                                    'redes_sociais']['linkedin']
                                                : 'Não informado',
                                            style: TextStyle(
                                              color: !isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _showEditDialog(context);
                                            },
                                            child: Icon(
                                              FontAwesomeIcons.instagram,
                                              color: !isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            _user!
                                                    .contato['redes_sociais']
                                                        ['instagram']
                                                    .isNotEmpty
                                                ? _user!.contato[
                                                        'redes_sociais']
                                                    ['instagram']
                                                : 'Não informado',
                                            style: TextStyle(
                                              color: !isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email de contato',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          _showEditEmailContato(context);
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _user!.contato['email'].isNotEmpty
                                            ? _user!.contato['email']
                                            : 'Não informado',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                               Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dados profissionais',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          _showEditEmailDadosProfissionais(
                                              context);
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Especialidades',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _user!
                                                .dadosProfissionais[
                                                    'especialidades']
                                                .isNotEmpty
                                            ? _user!.dadosProfissionais[
                                                'especialidades']
                                            : 'Não informado',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Região de atuação',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _user!
                                                .dadosProfissionais[
                                                    'regiao_atuacao']
                                                .isNotEmpty
                                            ? _user!.dadosProfissionais[
                                                'regiao_atuacao']
                                            : 'Não informado',
                                        style: TextStyle(
                                          color: !isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _updateUser(_nameController.text, _user!.logoUrl);
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
