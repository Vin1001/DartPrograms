import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class UserAuth {
  FirebaseAuth fAuth = FirebaseAuth.instance;
  FirebaseFirestore userDatabase = FirebaseFirestore.instance;
  createNewUser(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String regEmail,
      required String regPassword}) async {
    print(
        "this is the email and pass $regEmail and $regPassword and $firstName and $lastName, $phoneNumber");
    try {
      UserCredential userCred = await fAuth.createUserWithEmailAndPassword(
          email: regEmail, password: regPassword);
      storeUserDetails(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          regPassword: regPassword,
          regEmail: regEmail);
      print("REG SUCCESS ${userCred.user!.email}");
    } catch (error) {
      print("Some error $error");
    }

    //     .whenComplete(() {
    //   print("Registration Success");
    // }).catchError((error) {
    //   print("SOme error $error");
    // });
  }

  storeUserDetails(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String regEmail,
      required String regPassword}) async {
    Map<String, dynamic> userMap = {
      "first name": firstName,
      "last Name": lastName,
      "phone number": phoneNumber,
      "email id": regEmail,
      "pass": regPassword
    };
    try {
      userDatabase.collection(regEmail).doc('Details').set(userMap);
    } catch (error) {
      print("Some err in data storing $error ");
    }
  }

  loginUser({required String logEmail, required String logPassword}) async {
    try {
      print("I am herer");
      await fAuth.signInWithEmailAndPassword(
          email: logEmail, password: logPassword);
      //return true;
      print("LOGIN SUCCCESSS");
    } catch (error) {
      print("Some errro while login $error");
    }
  }

  // googleSignIN() async {
  //   GoogleSignInAccount? gAccount = await GoogleSignIn().signIn();
  //   AuthCredential cred = GoogleAuthProvider.credential(
  //       accessToken: gAccount!.serverAuthCode, idToken: gAccount.id);
  //   UserCredential googleUserCreds = await fAuth.signInWithCredential(cred);
  // }
}
