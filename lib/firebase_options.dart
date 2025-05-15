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
    apiKey: 'AIzaSyDzpnckNHBMRurYWOAaop4JXRbZT9_xDyk',
    appId: '1:392400066599:web:38762fcecdfa5ebf8e9602',
    messagingSenderId: '392400066599',
    projectId: 'emanfyp-34a8d',
    authDomain: 'emanfyp-34a8d.firebaseapp.com',
    databaseURL: 'https://emanfyp-34a8d-default-rtdb.firebaseio.com',
    storageBucket: 'emanfyp-34a8d.firebasestorage.app',
    measurementId: 'G-5V5PE94CRS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVk5ku9RMXsGqka72Z3attst5uUE4li6U',
    appId: '1:392400066599:android:19fba4f9b0a012f78e9602',
    messagingSenderId: '392400066599',
    projectId: 'emanfyp-34a8d',
    databaseURL: 'https://emanfyp-34a8d-default-rtdb.firebaseio.com',
    storageBucket: 'emanfyp-34a8d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBykiV75rJV_FI6yxOfUrypbch1jrmNipw',
    appId: '1:392400066599:ios:df2f080a535250a38e9602',
    messagingSenderId: '392400066599',
    projectId: 'emanfyp-34a8d',
    databaseURL: 'https://emanfyp-34a8d-default-rtdb.firebaseio.com',
    storageBucket: 'emanfyp-34a8d.firebasestorage.app',
    iosBundleId: 'com.example.fyp',
  );
}