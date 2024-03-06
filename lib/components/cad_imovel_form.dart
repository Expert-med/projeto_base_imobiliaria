import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';

import '../core/data/user_repository.dart';
import '../core/models/User_firebase_service.dart';
import '../core/models/imovel_form_data.dart';
import '../models/cep/via_cep_model.dart';
import '../repositories/via_cep_repository.dart';

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
  bool loading = false;
  var viacepModel = ViaCepModel();
  var viaCepRepository = ViaCepRepository();
  final _formKey = GlobalKey<FormState>();
  final _formData = ImovelFormData();
  String codigo_imovel = '';
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: !widget.isDarkMode ? Colors.white : Colors.black38,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  5), // Reduzindo o padding para o campo "Código Imóvel"
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
                                  5), // Reduzindo o padding para o campo "Código Imóvel"
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
                    ],
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.all(5), //apply padding to all four sides
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
                        5), // Reduzindo o padding para o campo "Código Imóvel"
                    child: Text(
                      "${_user.name} - Cód. ${_user.id}",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Link Imobiliaria",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.link = value ?? '',
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Valor do imóvel",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.precoOriginal = value ?? '',
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(
                                  5), // Reduzindo o padding para o campo "Código Imóvel"
                              child: Text(
                                "CEP",
                                style: TextStyle(
                                  color: Color(0xFF6e58e9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              style: TextStyle(
                                  color: !widget.isDarkMode
                                      ? Colors.black
                                      : Colors.white),
                              controller: cepController,
                              maxLength: 8,
                              keyboardType: TextInputType.number,
                              onChanged: (String value) async {
                                var cep =
                                    value.replaceAll(new RegExp(r'[^0-9]'), '');
                                if (cep.length == 8) {
                                  setState(() {
                                    loading = true;
                                  });
                                  viacepModel =
                                      await viaCepRepository.consultarCep(cep);
                                  setState(() {
                                    loading = false;
                                    logradouroController.text =
                                        viacepModel.logradouro ?? '';

                                    bairroController.text =
                                        viacepModel.bairro ?? '';
                                    localidadeController.text =
                                        viacepModel.localidade ?? '';
                                    ufController.text = viacepModel.uf ?? '';
                                    _formData.localizacao =
                                        "${viacepModel.logradouro}, ${viacepModel.bairro} - ${viacepModel.localidade} / ${viacepModel.uf}";
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Endereço",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    controller: logradouroController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.areaPrivativa = value,
                  ),
                  Row(
                    children: [
                      Flexible(
                        // Adicionando Flexible para garantir que os Column se ajustem ao tamanho disponível
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  5), // Reduzindo o padding para o campo "Código Imóvel"
                              child: Text(
                                "Bairro",
                                style: TextStyle(
                                  color: Color(0xFF6e58e9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: bairroController,
                              style: TextStyle(
                                  color: !widget.isDarkMode
                                      ? Colors.black
                                      : Colors.white),
                              decoration: InputDecoration(
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
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  15), //apply padding to all four sides
                              child: Text(
                                "Cidade",
                                style: TextStyle(
                                  color: Color(0xFF6e58e9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: localidadeController,
                              style: TextStyle(
                                  color: !widget.isDarkMode
                                      ? Colors.black
                                      : Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onSaved: (value) => _formData.name = value ?? '',
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  15), //apply padding to all four sides
                              child: Text(
                                "Estado",
                                style: TextStyle(
                                  color: Color(0xFF6e58e9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: ufController,
                              style: TextStyle(
                                  color: !widget.isDarkMode
                                      ? Colors.black
                                      : Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onSaved: (value) => _formData.name = value ?? '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Detalhes do imóvel",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Área privativa",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.areaPrivativa = value,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Área Privativa Casa",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.areaPrivativaCasa = value,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Área Total",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.areaTotal = value,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Mobilia",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.mobilia = value,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Nome do imóvel ",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.nomeImovel = value,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Perfil",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.perfil = value,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Terreno",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.terreno = value,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Total de dormitórios",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.mobilia = value,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Vagas garagem",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSaved: (value) => _formData.totalGaragem = value,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      NewImovelList()
                          .cadastrarImovel(_user, _formData, codigo_imovel);
                    },
                    child: Text('Salvar'),
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
          ),
        ),
      ),
    );
  }
}
