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
    apiKey: 'AIzaSyC27W_IpICgwpqOwGHd9rDSzNV9sceyM3o',
    appId: '1:438702627355:web:83c60d2d1745452567f6be',
    messagingSenderId: '438702627355',
    projectId: 'super-lista-ff6a6',
    authDomain: 'super-lista-ff6a6.firebaseapp.com',
    storageBucket: 'super-lista-ff6a6.appspot.com',
    measurementId: 'G-QQC3FTC0DP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8ZAVPl6i0ofCBw7J24emZCXv5m2dbrAQ',
    appId: '1:438702627355:android:8ca04b390ff2f74f67f6be',
    messagingSenderId: '438702627355',
    projectId: 'super-lista-ff6a6',
    storageBucket: 'super-lista-ff6a6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQ4-APJ0N2c26C0FaVcdOEVawatDdA-ss',
    appId: '1:438702627355:ios:f85e26eb9f411e9767f6be',
    messagingSenderId: '438702627355',
    projectId: 'super-lista-ff6a6',
    storageBucket: 'super-lista-ff6a6.appspot.com',
    iosBundleId: 'com.example.superLista',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQ4-APJ0N2c26C0FaVcdOEVawatDdA-ss',
    appId: '1:438702627355:ios:f85e26eb9f411e9767f6be',
    messagingSenderId: '438702627355',
    projectId: 'super-lista-ff6a6',
    storageBucket: 'super-lista-ff6a6.appspot.com',
    iosBundleId: 'com.example.superLista',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC27W_IpICgwpqOwGHd9rDSzNV9sceyM3o',
    appId: '1:438702627355:web:f8c8e4f6f5e6fd3a67f6be',
    messagingSenderId: '438702627355',
    projectId: 'super-lista-ff6a6',
    authDomain: 'super-lista-ff6a6.firebaseapp.com',
    storageBucket: 'super-lista-ff6a6.appspot.com',
    measurementId: 'G-YRFMPMX6RB',
  );
}