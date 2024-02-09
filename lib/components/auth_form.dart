import 'dart:io';

import 'package:flutter/material.dart';

import '../core/models/auth_form_data.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;
  final bool isDarkMode;

  const AuthForm({
    Key? key,
    required this.onSubmit,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isClientSelected = false;
  bool isBrokerSelected = false;
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_formData.isSignup && !isClientSelected && !isBrokerSelected) {
      return _showError('Selecione se você é cliente ou corretor.');
    }

   

    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 1200;

    return Card(
      
      margin: isSmallScreen ? const EdgeInsets.all(10) : const EdgeInsets.only(left:500, right: 500, top: 10, bottom: 10) ,
      child: Container(
        decoration: BoxDecoration(
          color: !widget.isDarkMode ? Colors.white : Colors.black38,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_formData.isSignup)
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Nome",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                if (_formData.isSignup)
                  TextFormField(
  key: const ValueKey('name'),
  initialValue: _formData.name,
  onChanged: (name) => _formData.name = name,
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.black12,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
    
  ),
   style: TextStyle(color: !widget.isDarkMode ? Colors.black : Colors.white), 
  validator: (localName) {
    final name = localName ?? '';
    if (name.trim().length < 5) {
      return 'Nome deve ter no mínimo 5 caracteres.';
    }
    return null;
  },
),

                Padding(
                  padding: EdgeInsets.all(15), //apply padding to all four sides
                  child: Text(
                    "Email",
                    style: TextStyle(
                      color: Color(0xFF6e58e9),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  key: const ValueKey('email'),
                  initialValue: _formData.email,
                  onChanged: (email) => _formData.email = email,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                     
              
                  ),
                     style: TextStyle(color: !widget.isDarkMode ? Colors.black : Colors.white), 
                  validator: (localEmail) {
                    final email = localEmail ?? '';
                    if (!email.contains('@')) {
                      return 'E-mail nformado não é válido.';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(15), //apply padding to all four sides
                  child: Text(
                    "Senha",
                    style: TextStyle(
                      color: Color(0xFF6e58e9),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  initialValue: _formData.password,
                  onChanged: (password) => _formData.password = password,
                  obscureText: true,
                     style: TextStyle(color: !widget.isDarkMode ? Colors.black : Colors.white), 
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),

                  ),
                  validator: (localPassword) {
                    final password = localPassword ?? '';
                    if (password.length < 6) {
                      return 'Nome deve ter no mínimo 6 caracteres.';
                    }
                    return null;
                  },
                ),
                if (_formData.isSignup)
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Tipo de conta",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                if (_formData.isSignup)
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text(
                              "Cliente",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: !widget.isDarkMode
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Checkbox(
                              value: isClientSelected,
                              activeColor:Color(0xFF6e58e9),
                              checkColor: !widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  isClientSelected = value ?? false;
                                  if (isClientSelected) {
                                    isBrokerSelected = false;
                                    _formData.tipoUsuario = 0;
                                  }
                                });
                              },
                              side: BorderSide(
                                color: !widget.isDarkMode
                                    ? Colors.black
                                    : Color(0xFF6e58e9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text(
                              "Corretor",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: !widget.isDarkMode
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Checkbox(
                              value: isBrokerSelected,
                              activeColor:Color(0xFF6e58e9),
                              checkColor: !widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              side: BorderSide(
                                color: !widget.isDarkMode
                                    ? Colors.black
                                    : Color(0xFF6e58e9),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  isBrokerSelected = value ?? false;
                                  if (isBrokerSelected) {
                                    isClientSelected = false;
                                    _formData.tipoUsuario = 1;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_formData.isLogin ? 'Entrar' : 'Cadastrar'),
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
                TextButton(
                  onPressed: () {
                    setState(() {
                      _formData.toggleAuthMode();
                    });
                  },
                  child: Text(
                    _formData.isLogin
                        ? 'Criar uma nova conta?'
                        : 'Já possui conta?',
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
