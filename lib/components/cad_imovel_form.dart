import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import '../core/data/user_repository.dart';
import '../core/models/User_firebase_service.dart';
import '../core/models/imovel_form_data.dart';
import '../models/cep/via_cep_model.dart';
import '../pages/home_page.dart';
import '../repositories/via_cep_repository.dart';
import '../util/drop_down_button.dart';

class CadImovelForm extends StatefulWidget {
  final bool isDarkMode;

  const CadImovelForm({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<CadImovelForm> createState() => _CadImovelFormState();
}

class _CadImovelFormState extends State<CadImovelForm> {
  final TextEditingController cepController = TextEditingController();
  final TextEditingController logradouroController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController ufController = TextEditingController();
  dynamic _user;
  int currentImageIndex = 0;
  List<String> _imagePaths = [];
  bool loading = false;
  var viacepModel = ViaCepModel();
  var viaCepRepository = ViaCepRepository();
  final _formKey = GlobalKey<FormState>();
  final _formData = ImovelFormData();
  String codigo_imovel = '';
  String? selectedPerfil;
  String? selectedMobilia;
  void initState() {
    super.initState();

    Provider.of<UserProvider>(context, listen: false).initializeUser();
    UserRepository().loadCurrentUser().then((currentUser) {
      if (currentUser != null) {
        String uid = UserRepository().generateUID();
        setState(() {
          _user = currentUser;
          codigo_imovel = 'V' + _user.id + uid;
        });
      } else {
        print('Nenhum usuário atual encontrado.');
      }
    }).catchError((error) {
      print('Erro ao carregar o usuário atual: $error');
    });
  }

  Future<void> pickAndUploadImage(String instrumentalId) async {
    print('instid $instrumentalId');
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.isNotEmpty) {
      for (PlatformFile file in result.files) {
        Uint8List? fileBytes;
        String fileName;

        if (kIsWeb) {
          fileBytes = file.bytes!;
          fileName = 'img-$instrumentalId-${currentImageIndex + 1}.jpeg';
        } else {
          fileBytes = file.bytes;
          fileName = 'img-$instrumentalId-${currentImageIndex + 1}.jpeg';
        }

        bool isDuplicate = _imagePaths.any((existingImagePath) {
          String existingBase64 = existingImagePath.split(',').last;
          try {
            Uint8List existingBytes = base64Decode(existingBase64);
            return listEquals(existingBytes, fileBytes!);
          } catch (e) {
            print('Error decoding existing base64: $e');
            return false;
          }
        });

        print(isDuplicate);

        if (!isDuplicate) {
          try {
            Reference ref = FirebaseStorage.instance
                .ref('imoveis/$instrumentalId')
                .child(fileName);
            UploadTask uploadTask = ref.putData(fileBytes!);

            TaskSnapshot snapshot = await uploadTask;
            String imagePath = await snapshot.ref.getDownloadURL();

            setState(() {
              _imagePaths.add(imagePath);
              _formData.imageUrls = _imagePaths;
            });

            print('Image added: $imagePath');
            print('Updated _imagePaths: $_imagePaths');

            currentImageIndex++;
            print(currentImageIndex);
          } catch (e) {
            print('Erro ao buscar imagem: $e');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: !widget.isDarkMode ? Colors.white : Colors.black38,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(
                          20), // Reduzindo o padding para o campo "Código Imóvel"
                      child: Column(
                        children: [
                          Text(
                            "Cadastro de imóveis",
                            style: TextStyle(
                              color: Color(0xFF6e58e9),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(
                              color: !widget.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Valor do Imóvel',
                              labelStyle: TextStyle(
                                color: Color(0xFF6e58e9),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              filled: true,
                              fillColor: Colors.black12,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onSaved: (value) =>
                                _formData.precoOriginal = value ?? '',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(
                                color: !widget.isDarkMode
                                    ? Colors.black
                                    : Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Nome do imóvel',
                              labelStyle: TextStyle(
                                color: Color(0xFF6e58e9),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              filled: true,
                              fillColor: Colors.black12,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onSaved: (value) => _formData.nomeImovel =
                                value?.isEmpty ?? true ? "N/A" : value!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: !widget.isDarkMode ? Colors.white : Colors.black38,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                      5,
                                    ),
                                    child: Text(
                                      "Código Imóvel",
                                      style: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                      5,
                                    ),
                                    child: Text(
                                      "${codigo_imovel}",
                                      style: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                      5,
                                    ),
                                    child: Text(
                                      "Imobiliária/Corretor",
                                      style: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                      5,
                                    ),
                                    child: Text(
                                      "${_user.name} - Cód. ${_user.id}",
                                      style: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: !widget.isDarkMode ? Colors.white : Colors.black38,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      
                      children: [
                        Text(
                          "Endereço do Imóvel",
                          style: TextStyle(
                            color: Color(0xFF6e58e9),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: cepController,
                                    style: TextStyle(
                                      color: !widget.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'CEP',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onChanged: (String value) async {
                                      var cep = value.replaceAll(
                                          new RegExp(r'[^0-9]'), '');
                                      if (cep.length == 8) {
                                        setState(() {
                                          loading = true;
                                        });
                                        viacepModel = await viaCepRepository
                                            .consultarCep(cep);
                                        setState(() {
                                          loading = false;
                                          logradouroController.text =
                                              viacepModel.logradouro ?? '';
                                          bairroController.text =
                                              viacepModel.bairro ?? '';
                                          localidadeController.text =
                                              viacepModel.localidade ?? '';
                                          ufController.text =
                                              viacepModel.uf ?? '';
                                          _formData.localizacao =
                                              "${viacepModel.logradouro}, ${viacepModel.bairro} - ${viacepModel.localidade} / ${viacepModel.uf} + ${cep}";
                                          _formData.latitude = viacepModel.lat;
                                          _formData.longitude = viacepModel.lng;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: bairroController,
                                    style: TextStyle(
                                      color: !widget.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Bairro',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onSaved: (value) =>
                                        _formData.codigo = value ?? '',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: localidadeController,
                                    style: TextStyle(
                                      color: !widget.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Cidade',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onSaved: (value) =>
                                        _formData.name = value ?? '',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: ufController,
                                    style: TextStyle(
                                      color: !widget.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Estado',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onSaved: (value) =>
                                        _formData.name = value ?? '',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: !widget.isDarkMode
                                ? Colors.black
                                : Colors.white,
                          ),
                          controller: logradouroController,
                          decoration: InputDecoration(
                            labelText: 'Endereço',
                            labelStyle: TextStyle(
                              color: Color(0xFF6e58e9),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.black12,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onSaved: (value) => _formData.areaPrivativa =
                              value?.isEmpty ?? true ? "N/A" : value!,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  color: !widget.isDarkMode ? Colors.white : Colors.black38,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      
                      children: [
                        Text(
                          "Detalhes do Imóvel",
                          style: TextStyle(
                            color: Color(0xFF6e58e9),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    style: TextStyle(
                                        color: !widget.isDarkMode
                                            ? Colors.black
                                            : Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Área privativa (m²)',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly // Permitir apenas dígitos
                                    ],
                                    onSaved: (value) => _formData
                                            .areaPrivativa =
                                        value?.isEmpty ?? true ? "N/A" : value!,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      style: TextStyle(
                                          color: !widget.isDarkMode
                                              ? Colors.black
                                              : Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Área Privativa Casa (m²)',
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6e58e9),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        filled: true,
                                        fillColor: Colors.black12,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter
                                            .digitsOnly // Permitir apenas dígitos
                                      ],
                                      onSaved: (value) =>
                                          _formData.areaPrivativaCasa =
                                              value?.isEmpty ?? true
                                                  ? "N/A"
                                                  : value!,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      style: TextStyle(
                                          color: !widget.isDarkMode
                                              ? Colors.black
                                              : Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Área Total (m²)',
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6e58e9),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        filled: true,
                                        fillColor: Colors.black12,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter
                                            .digitsOnly // Permitir apenas dígitos
                                      ],
                                      onSaved: (value) => _formData.areaTotal =
                                          value?.isEmpty ?? true
                                              ? "N/A"
                                              : value!,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StatusDropdown(
                          labeltext: "Mobilia",
                          statusOptions: [
                            "Mobiliado",
                            "Semi-mobiliado",
                            "Não mobiliado",
                          ],
                          selectedStatus: selectedMobilia,
                          onChanged: (String? value) {
                            setState(() {
                              selectedMobilia = value;
                              _formData.mobilia = value.toString() ?? 'N/A';
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StatusDropdown(
                          labeltext: 'Perfil',
                          statusOptions: [
                            "Usado",
                            "Novo",
                            "Semi-novo",
                            "Lançamento",
                            "Pré-Lançamento",
                            "Em construção"
                          ],
                          selectedStatus: selectedPerfil,
                          onChanged: (String? value) {
                            setState(() {
                              selectedPerfil = value;
                              _formData.perfil = value.toString();
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(
                                      color: !widget.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Total de dormitórios',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Permitir apenas dígitos
                                    ],
                                    onSaved: (value) => _formData
                                            .totalDormitorios =
                                        value?.isEmpty ?? true ? "N/A" : value!,
                                  ),
                                  
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(
                                        color: !widget.isDarkMode
                                            ? Colors.black
                                            : Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Vagas Garagem',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly // Permitir apenas dígitos
                                    ],
                                    onSaved: (value) => _formData.totalGaragem =
                                        value?.isEmpty ?? true ? "N/A" : value!,
                                  ),
                                 
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(
                                        color: !widget.isDarkMode
                                            ? Colors.black
                                            : Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Terreno',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6e58e9),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly // Permitir apenas dígitos
                                    ],
                                    onSaved: (value) => _formData.terreno =
                                        value?.isEmpty ?? true ? "N/A" : value!,
                                  ),
                                 
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  color: !widget.isDarkMode ? Colors.white : Colors.black38,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Imagens do imóvel",
                                style: TextStyle(
                                  color: Color(0xFF6e58e9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  pickAndUploadImage(codigo_imovel);
                                },
                                child: Text(
                                  'Adicionar imagens',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 10.0,
                                  backgroundColor: Color(0xFF6e58e9),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.only(top: 10),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _formData.imageUrls != null
                                  ? _formData.imageUrls!.length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: _formData.imageUrls != null &&
                                          _formData.imageUrls!.isNotEmpty
                                      ? Image.network(
                                          _formData.imageUrls![index])
                                      : const Text('Informe a Url'),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState?.save();
                    Provider.of<NewImovelList>(context, listen: false)
                        .cadastrarImovel(_user, _formData, codigo_imovel);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    elevation: 10.0,
                    backgroundColor: Color(0xFF6e58e9),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
