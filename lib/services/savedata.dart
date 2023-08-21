import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class CRUD {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> setUserData(String emailId, String title, String content) async {
    Map<String, dynamic> contentMap = {'Content': content};
    try {
      await firestore.collection(emailId).doc(title).set(contentMap);
      // if (snapshot.exists) {
      //   Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      //   // Use the userData
      // }
    } catch (e) {
      print("Error in Saving Data");
      // Handle Firestore errors
    }
  }
}
