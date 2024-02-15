import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../../../models/user.dart';
import 'auth_service.dart';
import 'package:flutter/foundation.dart'; // Importe o pacote
import 'dart:typed_data'; // Importe o pacote

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
      String name, String email, String password, File? image, int tipoUsuario) async {
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

      // 3. salvar usuário no banco de dados (opcional)
      _currentUser = _toChatUser(credential.user!, name, imageUrl,tipoUsuario);
      
        await _saveChatUser(_currentUser!, credential.user!.uid.toString());
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
    FirebaseAuth.instance.signOut();
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
    final imageBytes = await image.readAsBytes(); // Converta a imagem em bytes
    final uploadTask = ref.putData(imageBytes); // Use putData para enviar os bytes da imagem
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

  Future<void> _saveChatUser(ChatUser user, String vddUid) async {
    final store = FirebaseFirestore.instance;
      final uid = generateId();
      if(user.tipoUsuario == 0){
 final docRef = store.collection('clientes').doc(uid);

    return docRef.set({
      'id': uid,
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageUrl,
      'tipo_usuario': user.tipoUsuario,
      "uid":vddUid,
    });
      }else{
 final docRef = store.collection('corretores').doc(uid);

    return docRef.set({
      'id': uid,
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageUrl,
      'tipo_usuario': user.tipoUsuario
    });
      }
   
  }

  static ChatUser _toChatUser(User user, [String? name, String? imageUrl, int? tipoUsuario]) {
    return ChatUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
      tipoUsuario: tipoUsuario!,
    );
  }
}
