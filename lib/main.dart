//import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/firebase_options.dart';
import 'package:notes_app/screens/editscreeen.dart';
import 'package:notes_app/screens/homepage.dart';
import 'package:notes_app/screens/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //print("THIS IS THE USER DATA: ${FirebaseAuth.instance.currentUser}");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      routes: {
        '/Auth': (context) => const AuthScreen(),
        '/home': (context) => const HomePage(),
        '/editing': (context) => const EditScreen()
      },
      home: FirebaseAuth.instance.currentUser != null
          ? const HomePage()
          : const AuthScreen()));
}
