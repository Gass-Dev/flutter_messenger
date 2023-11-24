import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: currentPlatform,
    );
  }

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
    apiKey: 'AIzaSyCb3Kl_eOBDT832g46QtUQZzK2n1CDS-BY',
    appId: '1:462066059212:web:cf3c6eef4ac1fa342fbf69',
    messagingSenderId: '462066059212',
    projectId: 'ipssi-b40d9',
    authDomain: 'ipssi-b40d9.firebaseapp.com',
    storageBucket: 'ipssi-b40d9.appspot.com',
    measurementId: 'G-XR4CDFJH33',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCl6yqUB_vIzqRVauB-45fBGSMaAq_DYLo',
    appId: '1:462066059212:android:7a8e1b7479e3902d2fbf69',
    messagingSenderId: '462066059212',
    projectId: 'ipssi-b40d9',
    storageBucket: 'ipssi-b40d9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCR6lzpIiIKWVIBg99c9kjA_0Gfo0MLuEQ',
    appId: '1:462066059212:ios:6529a4ff447f39da2fbf69',
    messagingSenderId: '462066059212',
    projectId: 'ipssi-b40d9',
    storageBucket: 'ipssi-b40d9.appspot.com',
    iosBundleId: 'com.example.ipssiFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCR6lzpIiIKWVIBg99c9kjA_0Gfo0MLuEQ',
    appId: '1:462066059212:ios:1a52662c877ced0c2fbf69',
    messagingSenderId: '462066059212',
    projectId: 'ipssi-b40d9',
    storageBucket: 'ipssi-b40d9.appspot.com',
    iosBundleId: 'com.example.ipssiFlutter.RunnerTests',
  );
}
