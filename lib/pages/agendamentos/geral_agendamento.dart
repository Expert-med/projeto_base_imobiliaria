import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/models/agendamento/agendamento.dart';
import 'package:projeto_imobiliaria/models/agendamento/agendamentoList.dart';
import 'package:projeto_imobiliaria/pages/user_config_page.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import '../../components/agendamentos/agendamento_cad_form.dart';
import '../../components/agendamentos/agendamento_item.dart';
import '../../components/custom_menu.dart';
import '../../core/data/user_repository.dart';
import '../../core/models/UserProvider.dart';
import '../../core/models/User_firebase_service.dart';
import '../../models/agendamento/agendamento_form_data.dart';
import '../../theme/appthemestate.dart';

class GeralAgendamento extends StatefulWidget {
  GeralAgendamento();

  @override
  State<GeralAgendamento> createState() => _GeralAgendamentoState();
}

class _GeralAgendamentoState extends State<GeralAgendamento> {
  dynamic _user;
  late bool isDarkMode;
  late User? currentUser;
  List<Agendamento> _agendamentos = [];

  TextEditingController _searchController = TextEditingController();
  @override
  @override
  void initState() {
    super.initState();
    isDarkMode = false;
    ;
    _initializeData();
    Provider.of<UserProvider>(context, listen: false).initializeUser();
    UserRepository().loadCurrentUser().then((currentUser) {
      if (currentUser != null) {
        setState(() {
          _user = currentUser;
          print('o usuario atual é ${_user!.name}, com id=${_user!.id}');
        });
      } else {
        print('Nenhum usuário atual encontrado.');
      }
    }).catchError((error) {
      print('Erro ao carregar o usuário atual: $error');
    });
  }

  Future<void> _initializeData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final agendamentoList = Provider.of<AgendamentoList>(context);
    final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              subtitle: '',
              title: 'Home',
              isDarkMode: isDarkMode,
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (!isSmallScreen) Container(child: CustomMenu()),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              children: [
                                Text(
                                  'Nova visita',
                                  style: TextStyle(fontSize: 30),
                                ),
                                Spacer(),
                                InkWell(
                                  child: Icon(
                                    Icons.add,
                                    color: themeNotifier.isDarkModeEnabled
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CadAgendamentoForm(
                                          onSubmit: _handleSubmit,
                                        );
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Minhas visitas',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FutureBuilder<List<Agendamento>>(
                                        future: agendamentoList
                                            .buscarAgendamentosDoCorretorAtual(
                                                _user.id),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                  'Erro ao carregar as visitas'),
                                            );
                                          } else {
                                            _agendamentos = snapshot.data ?? [];
                                            if (_agendamentos.isEmpty) {
                                              return Center(
                                                child: Text(
                                                    'Nenhuma visita adicionada'),
                                              );
                                            } else {
                                              List<Agendamento>
                                                  corretoresFiltrados =
                                                  _agendamentos
                                                      .where((agendamento) {
                                                String searchTerm =
                                                    _searchController.text
                                                        .toLowerCase();
                                                return agendamento.id
                                                    .toLowerCase()
                                                    .contains(searchTerm);
                                              }).toList();

                                              return ListView.builder(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                itemCount:
                                                    corretoresFiltrados.length,
                                                itemBuilder: (ctx, i) {
                                                  final corretor =
                                                      corretoresFiltrados[i];
                                                  return AgendamentoItem(
                                                      corretor);
                                                },
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(width: 10),
                            // Expanded(
                            //   child: Container(
                            //     color: Colors.grey,
                            //     child: Center(child: Text('Agenda')),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: isSmallScreen ? CustomMenu() : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            themeNotifier.enableDarkMode(!themeNotifier.isDarkModeEnabled);
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }

  Future<void> _handleSubmit(AgendamentoFormData formData) async {
    try {
      // Login
      await Provider.of<AgendamentoList>(context, listen: false)
          .adicionarAgendamento(
        formData.cliente,
        formData.corretor,
        formData.observacoes_gerais,
        formData.imoveis,
        formData.status,
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text('Ocorreu um erro ao cadastrar: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      if (!mounted) return;
    }
  }
}
