import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class CRUD {
  DateTime today = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  setUserData(
      {required String emailId,
      required String title,
      required String docname,
      required String content,
      bool isCreated = false}) async {
    Map<String, dynamic> contentMap = {
      'Title': title,
      'Date': '${today.day}-${today.month}-${today.year}',
      'Content': content,
    };
    var a = await firestore.collection(emailId).doc(docname).get();
    try {
      if (!a.exists) {
        //print("A EXISSTSSSS");
        await firestore.collection(emailId).doc(docname).set(contentMap);
        isCreated = false;
      } else {
        print("Is created is FALSE");
        //await firestore.collection(emailId).doc(docname).delete();
        await firestore.collection(emailId).doc(docname).update(contentMap);
      }
      // if (snapshot.exists) {
      //   Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      //   // Use the userData
      // }
    } catch (e) {
      //await firestore.collection(emailId).doc(docname).set(contentMap);
      //isCreated = false;
      print("Error in Saving Data $e");
      // Handle Firestore errors
    }
  }

  Future<bool> deleteUserData(
      {required String emailId, required String docname}) async {
    var a = await firestore.collection(emailId).doc(docname).get();
    if (a.exists) {
      print("A EXISSTSSSS $docname");
      await firestore.collection(emailId).doc(docname).delete();
      //isCreated = false;
      return true;
    } else {
      return false;
    }
  }
}
