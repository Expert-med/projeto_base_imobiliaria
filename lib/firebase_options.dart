// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCTapD3PtCcnZjhBg-X_hE61aTIvz2RBSw',
    appId: '1:658927382203:web:73098f424423bdc527839e',
    messagingSenderId: '658927382203',
    projectId: 'projeto-base-flutter-d47ca',
    authDomain: 'projeto-base-flutter-d47ca.firebaseapp.com',
    storageBucket: 'projeto-base-flutter-d47ca.appspot.com',
    measurementId: 'G-THZW2JEL37',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCftdI1UxhwXc3K1yi2R_fEeMZ1G5gZY88',
    appId: '1:658927382203:android:a38ecca27dec1ef227839e',
    messagingSenderId: '658927382203',
    projectId: 'projeto-base-flutter-d47ca',
    storageBucket: 'projeto-base-flutter-d47ca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2WWbavIBekAyzQH3k8JUfAcuKeUu_WH0',
    appId: '1:658927382203:ios:ad966a951d3a865227839e',
    messagingSenderId: '658927382203',
    projectId: 'projeto-base-flutter-d47ca',
    storageBucket: 'projeto-base-flutter-d47ca.appspot.com',
    iosBundleId: 'com.example.projetoBaseFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB2WWbavIBekAyzQH3k8JUfAcuKeUu_WH0',
    appId: '1:658927382203:ios:ad966a951d3a865227839e',
    messagingSenderId: '658927382203',
    projectId: 'projeto-base-flutter-d47ca',
    storageBucket: 'projeto-base-flutter-d47ca.appspot.com',
    iosBundleId: 'com.example.projetoBaseFlutter',
  );
}