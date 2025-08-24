
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
    apiKey: 'AIzaSyDh6FH-FAf1Nv15t5PKm1Qzm4n78L68QM8',
    appId: '1:308541445974:web:380fa64bd3ea3f9b1b28f7',
    messagingSenderId: '308541445974',
    projectId: 'local-services-b0dfb',
    authDomain: 'local-services-b0dfb.firebaseapp.com',
    storageBucket: 'local-services-b0dfb.firebasestorage.app',
    measurementId: 'G-M2NVKQCSGW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBK9FvvcpWDjPVr1MLOaXn1qMhL5auJSQY',
    appId: '1:308541445974:android:6197e968d7c5621b1b28f7',
    messagingSenderId: '308541445974',
    projectId: 'local-services-b0dfb',
    storageBucket: 'local-services-b0dfb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuDj9hK4fQ0Q0PeDoX5VDIvMQYSP3eloU',
    appId: '1:308541445974:ios:69c9ff814a54e8211b28f7',
    messagingSenderId: '308541445974',
    projectId: 'local-services-b0dfb',
    storageBucket: 'local-services-b0dfb.firebasestorage.app',
    iosBundleId: 'com.example.myFinalProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuDj9hK4fQ0Q0PeDoX5VDIvMQYSP3eloU',
    appId: '1:308541445974:ios:69c9ff814a54e8211b28f7',
    messagingSenderId: '308541445974',
    projectId: 'local-services-b0dfb',
    storageBucket: 'local-services-b0dfb.firebasestorage.app',
    iosBundleId: 'com.example.myFinalProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDh6FH-FAf1Nv15t5PKm1Qzm4n78L68QM8',
    appId: '1:308541445974:web:f4d86fb9007333a81b28f7',
    messagingSenderId: '308541445974',
    projectId: 'local-services-b0dfb',
    authDomain: 'local-services-b0dfb.firebaseapp.com',
    storageBucket: 'local-services-b0dfb.firebasestorage.app',
    measurementId: 'G-RLQHWCBPCQ',
  );

}