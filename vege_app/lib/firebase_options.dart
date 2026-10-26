// File generated for vege_app Firebase integration
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
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5c18xIJ0Hcn-D5uzSBceeHGISz40TgDg',
    appId: '1:999493108787:android:6dc27bc33100a3c6dc8f46',
    messagingSenderId: '999493108787',
    projectId: 'vegetables-app-57f84',
    storageBucket: 'vegetables-app-57f84.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5c18xIJ0Hcn-D5uzSBceeHGISz40TgDg',
    appId: '1:999493108787:ios:6dc27bc33100a3c6dc8f46',
    messagingSenderId: '999493108787',
    projectId: 'vegetables-app-57f84',
    storageBucket: 'vegetables-app-57f84.firebasestorage.app',
    iosBundleId: 'com.example.vegeApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC5c18xIJ0Hcn-D5uzSBceeHGISz40TgDg',
    appId: '1:999493108787:web:6dc27bc33100a3c6dc8f46',
    messagingSenderId: '999493108787',
    projectId: 'vegetables-app-57f84',
    authDomain: 'vegetables-app-57f84.firebaseapp.com',
    storageBucket: 'vegetables-app-57f84.firebasestorage.app',
  );
}
