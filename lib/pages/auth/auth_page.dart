import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importe o pacote

import '../../components/auth_form.dart';
import '../../core/models/auth_form_data.dart';
import '../../core/services/firebase/auth/auth_service.dart';
import '../../main.dart';
import '../home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isDarkMode = false;
  bool _isLoading = false;

  Future<void> _handleSubmit(AuthFormData formData) async {
    try {
      if (!mounted) return;
      setState(() => _isLoading = true);

      if (formData.isLogin) {
        // Login
        await AuthService().login(
          formData.email,
          formData.password,
        );

        // Após o login, navegue para a HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyHomePage(), // Substitua HomePage() pela sua HomePage real
          ),
        );
      } else {
        await AuthService().signup(
          formData.name,
          formData.email,
          formData.password,
          formData.image,
          formData.tipoUsuario,
          formData.bairro,
          formData.cep,
          formData.cidade,
          formData.complemento,
          formData.estado,
          formData.logradouro,
          formData.numero,
          formData.num_identificacao,
        );

        // Após o cadastro ser um sucesso, navegue para a HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyHomePage(), // Substitua HomePage() pela sua HomePage real
          ),
        );
      }
    } catch (error) {
      // Mostre um alerta em caso de erro
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background da imagem com efeito de desfoque
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/fundo_claro_login.jpg'), // Substitua pelo caminho da sua imagem
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.8)
                    : Colors.black.withOpacity(0.5),
                child: Center(
                  child: SingleChildScrollView(
                    child: AuthForm(
                      onSubmit: _handleSubmit,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDarkMode = !isDarkMode; // Alterna o valor de isDarkMode
          });
        },
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
