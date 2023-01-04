// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyDlXG7G1TYERPmjy2RvJb0RL6iRL_q55Ik',
    appId: '1:528787543418:web:46fcc9c60f46081838b2c3',
    messagingSenderId: '528787543418',
    projectId: 'uni-test-3dfe0',
    authDomain: 'uni-test-3dfe0.firebaseapp.com',
    storageBucket: 'uni-test-3dfe0.appspot.com',
    measurementId: 'G-5Z830MEFCF',
  );

  static   FirebaseOptions android = const FirebaseOptions(
    apiKey: 'AIzaSyAquxnfh4PgZg6xLKW1XvnsjX5LpADRHjM',
    appId: '1:528787543418:android:3fbf28029341a89738b2c3',
    messagingSenderId: '528787543418',
    projectId: 'uni-test-3dfe0',
    storageBucket: 'uni-test-3dfe0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGPpK-aHLqgny2A3zF0cVOQ8ewjX77wCg',
    appId: '1:528787543418:ios:059bcdba0d0113ca38b2c3',
    messagingSenderId: '528787543418',
    projectId: 'uni-test-3dfe0',
    storageBucket: 'uni-test-3dfe0.appspot.com',
    iosClientId: '528787543418-0833h2j9kcqqcvmkub2hg5ud729n8e2m.apps.googleusercontent.com',
    iosBundleId: 'com.example.userSide',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGPpK-aHLqgny2A3zF0cVOQ8ewjX77wCg',
    appId: '1:528787543418:ios:059bcdba0d0113ca38b2c3',
    messagingSenderId: '528787543418',
    projectId: 'uni-test-3dfe0',
    storageBucket: 'uni-test-3dfe0.appspot.com',
    iosClientId: '528787543418-0833h2j9kcqqcvmkub2hg5ud729n8e2m.apps.googleusercontent.com',
    iosBundleId: 'com.example.userSide',
  );
}
