import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyBK9FvvcpWDjPVr1MLOaXn1qMhL5auJSQY',
      appId: '1:308541445974:android:6197e968d7c5621b1b28f7',
      messagingSenderId: '308541445974',  // fix here
      projectId: 'local-services-b0dfb',
      storageBucket: 'local-services-b0dfb.appspot.com', // fix format
    );
  }
}
