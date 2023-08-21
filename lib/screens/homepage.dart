import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/editscreeen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("NOTES APP"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const EditScreen()));
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: const Text("LOG OUT"),
        ),
      ),
    ));
  }
}
