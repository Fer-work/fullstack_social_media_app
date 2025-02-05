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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDf2v3QMFGbnmQmKzYahxTMLaTaJj52GEM',
    appId: '1:267057274935:web:4123349d930145837a1fb2',
    messagingSenderId: '267057274935',
    projectId: 'socialapptutorial-177e2',
    authDomain: 'socialapptutorial-177e2.firebaseapp.com',
    storageBucket: 'socialapptutorial-177e2.firebasestorage.app',
    measurementId: 'G-4J68MY44GJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_06JlFnx7jYcmt9NP-r4bo1wihJ3eSw0',
    appId: '1:267057274935:android:4c9b32ee8d60c0ec7a1fb2',
    messagingSenderId: '267057274935',
    projectId: 'socialapptutorial-177e2',
    storageBucket: 'socialapptutorial-177e2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCp75o0Zay4e8Ta-Z6BCVnQNF8WLAKvBuk',
    appId: '1:267057274935:ios:b40ddacee2e654a07a1fb2',
    messagingSenderId: '267057274935',
    projectId: 'socialapptutorial-177e2',
    storageBucket: 'socialapptutorial-177e2.firebasestorage.app',
    iosBundleId: 'com.example.fullstackSocialMediaApp',
  );
}
