
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCpOoSujiAv84uQBmM0LTiOiNIVzZ4gbVQ',
    appId: '1:443472056529:web:1d2229c8320f3d4d90f5f0',
    messagingSenderId: '443472056529',
    projectId: 'inventory-app-yourname',
    authDomain: 'inventory-app-yourname.firebaseapp.com',
    storageBucket: 'inventory-app-yourname.firebasestorage.app',
    measurementId: 'G-RG3HWZVVR8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkI2gEB2DC_lVhoM7MyvKsEsZzCfKYJK8',
    appId: '1:443472056529:android:d2ec5a4a50606c0490f5f0',
    messagingSenderId: '443472056529',
    projectId: 'inventory-app-yourname',
    storageBucket: 'inventory-app-yourname.firebasestorage.app',
  );
}
