import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'botomnav.dart'; // Make sure this file name is correct (bottomnav.dart?)
import 'forms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDvW8qb1kCkZEp6csHcf0aDj7Ekl3UAtwE",
        authDomain: "quizapi-9080f.firebaseapp.com",
        projectId: "quizapi-9080f",
        storageBucket: "quizapi-9080f.firebasestorage.app",
        messagingSenderId: "1000718628364",
        appId: "1:1000718628364:web:5f23e54f8cb65518dfa029",
        measurementId: "G-GTQ5RVVCWL",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Authentication(),
      routes: {
        '/home': (context) => const BottomNav(),
      },
    );
  }
}
