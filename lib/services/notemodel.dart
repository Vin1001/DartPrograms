import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteshomeData {
  User user = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>> notesList = [];
  late String emailId;

  NoteshomeData() {
    //notesList = _getDocsList(emailId: user.email!);
  }

  _getDocsList({required String emailId}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection(emailId).get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          notesList.add(docSnapshot.data());
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
          print(docSnapshot.data());
        }
        //return notesList;
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
}
