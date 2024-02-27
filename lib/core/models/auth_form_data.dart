import 'dart:io';

enum AuthMode { signup, login, resetPass }

class AuthFormData {
  String name = '';
  String email = '';
  String password = '';
  String bairro = '';
  String cep = '';
  String cidade = '';
  String complemento = '';
  String estado = '';
  String logradouro = '';
  String numero = '';
  String num_identificacao = '';
  
  File? image;
  int tipoUsuario = 0;
  AuthMode _mode = AuthMode.login;

  bool get isLogin {
    return _mode == AuthMode.login;
  }

  bool get isSignup {
    return _mode == AuthMode.signup;
  }

  bool get isResetPass {
    return _mode == AuthMode.resetPass;
  }

  void toggleAuthMode() {
    _mode = isLogin ? AuthMode.signup : AuthMode.login;
  }
     void toggleResetMode() {
    _mode = AuthMode.resetPass;
  }
}
