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
    apiKey: 'AIzaSyDq2s87XqixZ-hqN0tk489FxRqWLoFHyCg',
    appId: '1:558890387840:web:63f5a66708315c53d65965',
    messagingSenderId: '558890387840',
    projectId: 'todo-app-e000a',
    authDomain: 'todo-app-e000a.firebaseapp.com',
    storageBucket: 'todo-app-e000a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlmoD8UlrVmtlptUYwVuZLQJn-dYtYNUE',
    appId: '1:558890387840:android:b833fb68f8b1acb3d65965',
    messagingSenderId: '558890387840',
    projectId: 'todo-app-e000a',
    storageBucket: 'todo-app-e000a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBoPBjejhvs25E-pbZCmnITdM0EMJ97t68',
    appId: '1:558890387840:ios:f8d861de8c0f3b8dd65965',
    messagingSenderId: '558890387840',
    projectId: 'todo-app-e000a',
    storageBucket: 'todo-app-e000a.appspot.com',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBoPBjejhvs25E-pbZCmnITdM0EMJ97t68',
    appId: '1:558890387840:ios:2139b826fa96ad66d65965',
    messagingSenderId: '558890387840',
    projectId: 'todo-app-e000a',
    storageBucket: 'todo-app-e000a.appspot.com',
    iosBundleId: 'com.example.todoApp.RunnerTests',
  );
}
