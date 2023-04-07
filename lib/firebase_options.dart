// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
// / import 'firebase_options.dart';
// / // ...
// / await Firebase.initializeApp(
// /   options: DefaultFirebaseOptions.currentPlatform,
// / );
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
    apiKey: 'AIzaSyDvjKXBtU1KJLurumaErcztMkNATJyysO0',
    appId: '1:1065956452855:web:6596dd703cae321c9566f2',
    messagingSenderId: '1065956452855',
    projectId: 'gfg-applebhe',
    authDomain: 'gfg-applebhe.firebaseapp.com',
    storageBucket: 'gfg-applebhe.appspot.com',
    measurementId: 'G-9PNBWG7DWJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVxgMiMMNIi9hqoklFbMszemsVWHFGURA',
    appId: '1:1065956452855:android:c205a3d64e66698b9566f2',
    messagingSenderId: '1065956452855',
    projectId: 'gfg-applebhe',
    storageBucket: 'gfg-applebhe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCltBzPwYCjZeXMgwviNXKMCq6cKjIhIUs',
    appId: '1:1065956452855:ios:0d7cb917784913119566f2',
    messagingSenderId: '1065956452855',
    projectId: 'gfg-applebhe',
    storageBucket: 'gfg-applebhe.appspot.com',
    iosClientId:
        '1065956452855-e9ptr3ki64m1l7401pg1t1hllsds05s8.apps.googleusercontent.com',
    iosBundleId: 'com.example.appleBhe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCltBzPwYCjZeXMgwviNXKMCq6cKjIhIUs',
    appId: '1:1065956452855:ios:0d7cb917784913119566f2',
    messagingSenderId: '1065956452855',
    projectId: 'gfg-applebhe',
    storageBucket: 'gfg-applebhe.appspot.com',
    iosClientId:
        '1065956452855-e9ptr3ki64m1l7401pg1t1hllsds05s8.apps.googleusercontent.com',
    iosBundleId: 'com.example.appleBhe',
  );
}
