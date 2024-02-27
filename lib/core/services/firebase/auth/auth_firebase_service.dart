import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../models/UserProvider.dart';
import 'auth_service.dart';
import 'package:flutter/foundation.dart'; // Importe o pacote
import 'dart:typed_data'; // Importe o pacote

class AuthFirebaseService implements AuthService {
  static CurrentUser? _currentUser;

  static final _userStream = Stream<CurrentUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toCurrentUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  CurrentUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<CurrentUser?> get userChanges {
    return _userStream;
  }

  @override
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
    String num_identificacao,
  ) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      // 1. Upload da foto do usuário
      final imageName = '${credential.user!.uid}.jpg';
      final imageUrl = '';
      await credential.user?.updateDisplayName(name);
      await credential.user?.updatePhotoURL(imageUrl);
      await login(email, password);

      // 2. Adicionar informações do endereço à lista de contato
      Map<String, dynamic> endereco = {
        'logradouro': logradouro,
        'numero': numero,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
      };
      print('info do endereço $endereco');
      Map<String, dynamic> contato = {
        'email': email,
        'telefone_fixo': '', // Adicione outros campos conforme necessário
        'celular': '',
        'endereco': endereco,
        'redes_sociais': {
          'facebook': '',
          'instagram': '',
          'linkedin': '',
        },
      };

      // 3. Criar o objeto CurrentUser
      _currentUser = _toCurrentUser(
          credential.user!, name, imageUrl, tipoUsuario, contato,num_identificacao);

      // 4. Salvar o usuário no banco de dados (opcional)
      await _saveCurrentUser(_currentUser!, credential.user!.uid.toString());
    }

    await signup.delete();
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Erro ao sair da conta: $e');
    }
    ;
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('user_images').child(imageName);

    if (!kIsWeb) {
      // Se não estiver na web (dispositivo móvel)
      await ref.putFile(image);
    } else {
      // Se estiver na web
      final imageBytes =
          await image.readAsBytes(); // Converta a imagem em bytes
      final uploadTask =
          ref.putData(imageBytes); // Use putData para enviar os bytes da imagem
      await uploadTask.then((snapshot) {
        // Executar ações após o upload ser concluído
      });
    }

    // Obtenha a URL de download da imagem e retorne
    return await ref.getDownloadURL();
  }

  Uuid uuid = Uuid();

  String generateId() {
    String uniqueId = uuid.v4();
    String id = uniqueId
        .substring(0, 4)
        .toUpperCase(); // Extrair os primeiros 4 caracteres
    return id;
  }

  Future<void> _saveCurrentUser(CurrentUser user, String vddUid) async {
    DateTime now = DateTime.now();

    String data_atual_formatada = DateFormat('yyyy-MM-dd').format(now);
    final store = FirebaseFirestore.instance;
    final uid = generateId();
    if (user.tipoUsuario == 0) {
      final docRef = store.collection('clientes').doc(uid);

      await docRef.set({
        'id': uid,
        'name': user.name ?? '',
        'email': user.email ?? '',
        'imageUrl': user.imageUrl ?? '',
        'tipo_usuario': user.tipoUsuario ?? 0,
        'uid': vddUid ?? '',
        'data_cadastro': data_atual_formatada,
        'contato': {
          'email': user.email ?? '',
          'telefone_fixo': user.contato['telefone_fixo'] ?? '',
          'celular': user.contato['celular'] ?? '',
          'endereco': {
            'logradouro': user.contato['endereco']['logradouro'] ?? '',
            'numero': user.contato['endereco']['numero'] ?? '',
            'complemento': user.contato['endereco']['complemento'] ?? '',
            'bairro': user.contato['endereco']['bairro'] ?? '',
            'cidade': user.contato['endereco']['cidade'] ?? '',
            'estado': user.contato['endereco']['estado'] ?? '',
            'cep': user.contato['endereco']['cep'] ?? '',
          },
          'redes_sociais': {
            'facebook': '',
            'instagram': '',
            'linkedin': '',
          },
        },
        "negociacoes": [],
        'preferencias': {},
        'historico_corretor': [],
        'historico_busca': [],
        'imoveis_favoritos': [],
      });
    } else {
      final docRef = store.collection('corretores').doc(uid);

      await docRef.set({
        'id': uid,
        'name': user.name ?? '',
        'email': user.email ?? '',
        'logoUrl': user.imageUrl ?? '',
        'tipo_usuario': user.tipoUsuario ?? 1,
        'uid': vddUid ?? '',
        'permissoes': '',
        'imoveis_cadastrados': [],
        'data_cadastro': data_atual_formatada,
        'contato': {
          'email': user.email ?? '',
          'telefone_fixo': user.contato['telefone_fixo'] ?? '',
          'celular': user.contato['celular'] ?? '',
          'endereco': {
             'logradouro': user.contato['endereco']['logradouro'] ?? '',
            'numero': user.contato['endereco']['numero'] ?? '',
            'complemento': user.contato['endereco']['complemento'] ?? '',
            'bairro': user.contato['endereco']['bairro'] ?? '',
            'cidade': user.contato['endereco']['cidade'] ?? '',
            'estado': user.contato['endereco']['estado'] ?? '',
            'cep': user.contato['endereco']['cep'] ?? '',
          },
          'redes_sociais': {
            'facebook': '',
            'instagram': '',
            'linkedin': '',
          },
        },
        'dados_profissionais': {
          'registro': '',
          'especialidades': [],
          'regiao_atuacao': [],
        },
        'metas': {
          'mensal': {
            'vendas': 0,
            'aluguel': 0,
          },
          'anual': {
            'vendas': 0,
            'aluguel': 0,
          },
        },
        'desempenho_atual': {
          'mensal': {
            'vendas': 0,
            'aluguel': 0,
          },
          'anual': {
            'vendas': 0,
            'aluguel': 0,
          },
        },
        'visitas': [],
        "negociacoes": [],
        "info_banner": {
          "image_url": '',
          "about_text": '',
        }
      });
    }
  }

  static CurrentUser _toCurrentUser(User user,
      [String? name,
      String? imageUrl,
      int? tipoUsuario,
      Map<String, dynamic>? contato,
      String? num_identificacao,
      List<Map<String, dynamic>>? preferencias,
      List<String>? historico,
      List<String>? historicoBusca,
      List<String>? imoveisFavoritos,
      String? UID,
      ]) {
    return CurrentUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
      tipoUsuario: tipoUsuario!,
      contato: contato ?? {},
      preferencias: preferencias ?? [],
      historico: historico ?? [],
      historicoBusca: historicoBusca ?? [],
      imoveisFavoritos: imoveisFavoritos ?? [],
      UID: UID ?? '',
      num_identificacao: num_identificacao ??'',
    );
  }
}
