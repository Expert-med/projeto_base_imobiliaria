import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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

  bool loading = false;
  var viacepModel = ViaCepModel();
  var viaCepRepository = ViaCepRepository();
  final _formKey = GlobalKey<FormState>();
  final _formData = ImovelFormData();

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
                        // Adicionando Flexible para garantir que os Column se ajustem ao tamanho disponível
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
                            TextFormField(
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
                        // Adicionando Flexible para garantir que os Column se ajustem ao tamanho disponível
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                      "Imobiliária",
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
                    onSaved: (value) => _formData.imobiliaria = value ?? '',
                  ),
                  Padding(
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
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            Padding(
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
                      Flexible(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  5), // Reduzindo o padding para o campo "Código Imóvel"
                              child: Text(
                                "Número",
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
                    onSaved: (value) => _formData.numero_residencia = value,
                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
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
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      // Aqui você pode chamar o método addInfo e passar os valores inseridos nos TextFormField
                      // _formData.addInfo(areaPrivativa: 'valor', areaTotal: 'valor', ...)
                      // Você pode obter os valores dos TextFormField usando _formData.codigo, _formData.name, etc.
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
