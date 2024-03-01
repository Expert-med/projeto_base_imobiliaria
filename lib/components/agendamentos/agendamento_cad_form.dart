import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:provider/provider.dart';
import '../../core/data/user_repository.dart';
import '../../core/models/User_firebase_service.dart';
import '../../models/agendamento/agendamento_form_data.dart';
import '../../models/clientes/clientesList.dart';
import '../clientes/clientes_modal.dart';
import '../imovel/imoveis_modal.dart';

class CadAgendamentoForm extends StatefulWidget {
  final bool isDarkMode;
  final void Function(AgendamentoFormData) onSubmit;

  const CadAgendamentoForm({
    Key? key,
    required this.isDarkMode,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CadAgendamentoForm> createState() => _CadAgendamentoFormState();
}

class _CadAgendamentoFormState extends State<CadAgendamentoForm> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _formData = AgendamentoFormData();
  dynamic _user;
  TextEditingController nomeCorretor = TextEditingController();
  TextEditingController nomeCliente = TextEditingController();
  TextEditingController obsControlller = TextEditingController();
  final List<String> statusOptions = [
    "Não iniciado",
    "Em andamento",
    "Concluído"
  ];
  String? selectedStatus;
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
    final imoveisList = Provider.of<NewImovelList>(context);

    return SingleChildScrollView(
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
                    color: !widget.isDarkMode ? Colors.black : Colors.white,
                  ),
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
                        return ImoveisModal(
                          imoveisList: imoveisList,
                          onImovelAdicionado: (imovel) {
                            setState(() {
                              final imovel_item = {
                                "id_imovel": imovel.id,
                                "feedback": '',
                                "satisfacao": '',
                                "comentarios": '',
                              };
                              _formData.imoveis[(_formData.imoveis.length + 1)
                                  .toString()] = imovel_item;
                              print(_formData.imoveis);
                            });
                          },
                        );
                      },
                    );
                  },
                  readOnly: true, // Ensure user cannot edit the field directly
                  controller: TextEditingController(
                    text: _formData.imoveis.values
                        .map((item) => item['id_imovel'])
                        .toList()
                        .join(', '),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      5), // Reduzindo o padding para o campo "Código Imóvel"
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
                      color: !widget.isDarkMode ? Colors.black : Colors.white),
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
                  padding: EdgeInsets.all(15), //apply padding to all four sides
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
                Padding(
                  padding: EdgeInsets.all(15), //apply padding to all four sides
                  child: Text(
                    "Observações Gerais",
                    style: TextStyle(
                      color: Color(0xFF6e58e9),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  controller: obsControlller,
                  style: TextStyle(
                    color: !widget.isDarkMode ? Colors.black : Colors.white,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15), //apply padding to all four sides
                  child: Text(
                    "Status",
                    style: TextStyle(
                      color: Color(0xFF6e58e9),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  dropdownColor: widget.isDarkMode
                      ? Colors.black
                      : Colors.white, // Set dropdown background color to white
                  value: selectedStatus,
                  items: statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(
                        status,
                        style: TextStyle(
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState?.save();
                    print(_formData.imoveis);
                    widget.onSubmit(_formData);
                    Navigator.pop(context);
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
