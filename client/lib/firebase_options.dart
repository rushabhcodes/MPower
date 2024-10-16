// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDU7zTcN4lvvCiHGlW4GVsHDhGpQjki_eM',
    appId: '1:613987729944:web:6ac03bf7cd4708a5eef96d',
    messagingSenderId: '613987729944',
    projectId: 'mpower-81bb7',
    authDomain: 'mpower-81bb7.firebaseapp.com',
    storageBucket: 'mpower-81bb7.appspot.com',
    measurementId: 'G-6RG61ME5ZC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCI5ypBOZgsuCrXQDGk-ys5iDyQlu6dxqQ',
    appId: '1:613987729944:android:177a345c70bb0396eef96d',
    messagingSenderId: '613987729944',
    projectId: 'mpower-81bb7',
    storageBucket: 'mpower-81bb7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD08-CnvJwXmXVZIirZiGw5KV7A4ymjvNI',
    appId: '1:613987729944:ios:2a363991fbfc134eeef96d',
    messagingSenderId: '613987729944',
    projectId: 'mpower-81bb7',
    storageBucket: 'mpower-81bb7.appspot.com',
    iosBundleId: 'com.example.client',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD08-CnvJwXmXVZIirZiGw5KV7A4ymjvNI',
    appId: '1:613987729944:ios:2a363991fbfc134eeef96d',
    messagingSenderId: '613987729944',
    projectId: 'mpower-81bb7',
    storageBucket: 'mpower-81bb7.appspot.com',
    iosBundleId: 'com.example.client',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDU7zTcN4lvvCiHGlW4GVsHDhGpQjki_eM',
    appId: '1:613987729944:web:117a80d87c392e85eef96d',
    messagingSenderId: '613987729944',
    projectId: 'mpower-81bb7',
    authDomain: 'mpower-81bb7.firebaseapp.com',
    storageBucket: 'mpower-81bb7.appspot.com',
    measurementId: 'G-LGWLHNC8H5',
  );
}
