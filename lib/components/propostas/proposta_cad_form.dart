import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/user_repository.dart';
import '../../core/models/User_firebase_service.dart';
import '../../models/clientes/clientesList.dart';
import '../../models/negociacao/negociacao_form_data.dart';
import '../clientes/clientes_modal.dart';

class CadPropostaForm extends StatefulWidget {
  final bool isDarkMode;
  final void Function(NegociacaoFormData) onSubmit;

  const CadPropostaForm({
    Key? key,
    required this.isDarkMode,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CadPropostaForm> createState() => _CadPropostaFormState();
}

class _CadPropostaFormState extends State<CadPropostaForm> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _formData = NegociacaoFormData();
  dynamic _user;
  TextEditingController nomeCorretor = TextEditingController();
  TextEditingController nomeCliente = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<UserProvider>(context, listen: false).initializeUser();
    UserRepository().loadCurrentUser().then((currentUser) {
      if (currentUser != null) {
        setState(() {
          _user = currentUser;
          _formData.corretor = _user.id;
          nomeCorretor.text = _user.name;
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
  Widget build(BuildContext context) {
    final clientesList = Provider.of<ClientesList>(context);

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
                    onSaved: (value) => _formData.imovel = value ?? '',
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Cliente",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: nomeCliente,
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
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return ClientesModal(
                            clientesList: clientesList,
                            parametro_clientes_do_corretor: 1,
                            onClienteAdicionado: (cliente) {
                              print('nome');
                              print(cliente.name);
                              setState(() {
                                nomeCliente.text = cliente.name;
                                _formData.cliente = cliente.id;
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Corretor",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: nomeCorretor,
                    style: TextStyle(
                      color: !widget.isDarkMode ? Colors.black : Colors.white,
                    ),
                    enabled: false, // Isso tornará o campo somente leitura
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      print(_formData.cliente);
                      widget.onSubmit(_formData);
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
