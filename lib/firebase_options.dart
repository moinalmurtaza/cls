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
    apiKey: 'REPLACE_ME_API_KEY',
    appId: 'REPLACE_ME_APP_ID',
    messagingSenderId: 'REPLACE_ME_SENDER_ID',
    projectId: 'REPLACE_ME_PROJECT_ID',
    authDomain: 'REPLACE_ME_AUTH_DOMAIN',
    storageBucket: 'REPLACE_ME_STORAGE_BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME_API_KEY',
    appId: 'REPLACE_ME_APP_ID',
    messagingSenderId: 'REPLACE_ME_SENDER_ID',
    projectId: 'REPLACE_ME_PROJECT_ID',
    storageBucket: 'REPLACE_ME_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME_API_KEY',
    appId: 'REPLACE_ME_APP_ID',
    messagingSenderId: 'REPLACE_ME_SENDER_ID',
    projectId: 'REPLACE_ME_PROJECT_ID',
    storageBucket: 'REPLACE_ME_STORAGE_BUCKET',
    iosBundleId: 'REPLACE_ME_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_ME_API_KEY',
    appId: 'REPLACE_ME_APP_ID',
    messagingSenderId: 'REPLACE_ME_SENDER_ID',
    projectId: 'REPLACE_ME_PROJECT_ID',
    storageBucket: 'REPLACE_ME_STORAGE_BUCKET',
    iosBundleId: 'REPLACE_ME_BUNDLE_ID',
  );
}
