// firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] usando suas credenciais
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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions não configurado para Linux',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não suportado para esta plataforma',
        );
    }
  }

  // Web
  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyAfxY0ttupMXO95V1QSNsD-YTdoaMYShn0",
      authDomain: "my-refuge-9d9f5.firebaseapp.com",
      projectId: "my-refuge-9d9f5",
      storageBucket: "my-refuge-9d9f5.firebasestorage.app",
      messagingSenderId: "250687761961",
      appId: "1:250687761961:web:0bc24946dce63e102b7638");

  // Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAfxY0ttupMXO95V1QSNsD-YTdoaMYShn0",
    appId: "1:250687761961:web:0bc24946dce63e102b7638",
    messagingSenderId: "250687761961",
    projectId: "my-refuge-9d9f5",
    storageBucket: "my-refuge-9d9f5.firebasestorage.app",
  );

  // iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAfxY0ttupMXO95V1QSNsD-YTdoaMYShn0",
    appId: "1:250687761961:web:0bc24946dce63e102b7638",
    messagingSenderId: "250687761961",
    projectId: "my-refuge-9d9f5",
    storageBucket: "my-refuge-9d9f5.firebasestorage.app",
    iosBundleId: "com.example.myRefuge",
  );

  // macOS
  static const FirebaseOptions macos = ios;

  // Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyAfxY0ttupMXO95V1QSNsD-YTdoaMYShn0",
    appId: "1:250687761961:web:0bc24946dce63e102b7638",
    messagingSenderId: "250687761961",
    projectId: "my-refuge-9d9f5",
    storageBucket: "my-refuge-9d9f5.firebasestorage.app",
  );
}
