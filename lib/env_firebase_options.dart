import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Build a [FirebaseOptions] from environment variables if present.
///
/// Priority: platform-specific env keys (e.g. FIREBASE_API_KEY_ANDROID) then
/// generic ones (FIREBASE_API_KEY). Returns null when required fields are
/// missing so callers can fall back to native config (e.g., google-services.json
/// or GoogleService-Info.plist) by calling `Firebase.initializeApp()` with no options.
FirebaseOptions? firebaseOptionsFromEnv() {
  String? env(String key) => dotenv.env[key];

  String? pick(List<String> keys) {
    for (final k in keys) {
      final v = env(k);
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  String platformSuffix;
  if (kIsWeb) {
    platformSuffix = 'WEB';
  } else {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        platformSuffix = 'ANDROID';
        break;
      case TargetPlatform.iOS:
        platformSuffix = 'IOS';
        break;
      case TargetPlatform.macOS:
        platformSuffix = 'MACOS';
        break;
      case TargetPlatform.windows:
        platformSuffix = 'WINDOWS';
        break;
      case TargetPlatform.linux:
        platformSuffix = 'LINUX';
        break;
      default:
        platformSuffix = '';
    }
  }

  final apiKey = pick([
    if (platformSuffix.isNotEmpty) 'FIREBASE_API_KEY_$platformSuffix',
    'FIREBASE_API_KEY',
  ]);
  final appId = pick([
    if (platformSuffix.isNotEmpty) 'FIREBASE_APP_ID_$platformSuffix',
    'FIREBASE_APP_ID',
  ]);
  final messagingSenderId = pick([
    if (platformSuffix.isNotEmpty) 'FIREBASE_MESSAGING_SENDER_ID_$platformSuffix',
    'FIREBASE_MESSAGING_SENDER_ID',
  ]);
  final projectId = pick([
    if (platformSuffix.isNotEmpty) 'FIREBASE_PROJECT_ID_$platformSuffix',
    'FIREBASE_PROJECT_ID',
  ]);
  final storageBucket = pick([
    if (platformSuffix.isNotEmpty) 'FIREBASE_STORAGE_BUCKET_$platformSuffix',
    'FIREBASE_STORAGE_BUCKET',
  ]);
  final authDomain = pick([
    if (platformSuffix.isNotEmpty) 'FIREBASE_AUTH_DOMAIN_$platformSuffix',
    'FIREBASE_AUTH_DOMAIN',
  ]);
  final iosBundleId = pick([
    'FIREBASE_IOS_BUNDLE_ID',
    'FIREBASE_IOS_BUNDLEID',
  ]);

  if (apiKey != null && appId != null && messagingSenderId != null && projectId != null) {
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket,
      authDomain: authDomain,
      iosBundleId: iosBundleId,
    );
  }

  return null;
}

