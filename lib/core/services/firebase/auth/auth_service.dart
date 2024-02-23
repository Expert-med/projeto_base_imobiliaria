import 'dart:io';
import '../../../models/UserProvider.dart';
import 'auth_firebase_service.dart';

abstract class AuthService {
  CurrentUser? get currentUser;

  Stream<CurrentUser?> get userChanges;

  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
    int tipoUsuario,
      String bairro,
  String cep,
  String cidade,
  String complemento,
  String estado,
  String logradouro,
  String numero,
  );

  Future<void> login(
    String email,
    String password,
  );

  Future<void> logout();

  factory AuthService() {
    return AuthFirebaseService();
  }
}
