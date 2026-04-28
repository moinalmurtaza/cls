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
    apiKey: 'AIzaSyDU921K4JZbdpcbg0x8BIkxraY2Kkc_l1E1',
    appId: '1:781348051032:web:fb87b01dac58b737ea522d',
    messagingSenderId: '781348051032',
    projectId: 'faceattendanceapp-50e7ee3d',
    authDomain: 'faceattendanceapp-50e7ee3d.firebaseapp.com',
    storageBucket: 'faceattendanceapp-50e7ee3d.firebasestorage.app',
    databaseURL: 'https://faceattendanceapp-50e7ee3d-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME_ANDROID_API_KEY',
    appId: 'REPLACE_ME_ANDROID_APP_ID',
    messagingSenderId: '781348051032',
    projectId: 'faceattendanceapp-50e7ee3d',
    storageBucket: 'faceattendanceapp-50e7ee3d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME_IOS_API_KEY',
    appId: 'REPLACE_ME_IOS_APP_ID',
    messagingSenderId: '781348051032',
    projectId: 'faceattendanceapp-50e7ee3d',
    storageBucket: 'faceattendanceapp-50e7ee3d.firebasestorage.app',
    iosBundleId: 'REPLACE_ME_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_ME_IOS_API_KEY',
    appId: 'REPLACE_ME_IOS_APP_ID',
    messagingSenderId: '781348051032',
    projectId: 'faceattendanceapp-50e7ee3d',
    storageBucket: 'faceattendanceapp-50e7ee3d.firebasestorage.app',
    iosBundleId: 'REPLACE_ME_BUNDLE_ID',
  );
}
