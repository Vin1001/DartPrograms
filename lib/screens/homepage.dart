//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/editnote.dart';
//import 'package:notes_app/cubit/noteshome_cubit.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:notes_app/cubit/noteshome_cubit.dart';
import 'package:notes_app/screens/editscreeen.dart';
//import 'package:notes_app/services/notemodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _future;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;

  Future<List<Map<String, dynamic>>> _getDocsList(
      {required String emailId}) async {
    List<Map<String, dynamic>> temp = [];
    var querysnapshot = await firestore.collection(emailId).get();
    for (var docSnapshot in querysnapshot.docs) {
      temp.add(docSnapshot.data());
      //print('${docSnapshot.id} => ${docSnapshot.data()}');
      //print(docSnapshot.data());
    }
    //this.snapshot = temp;
    print('FINAL SNAPSHOT: $temp');
    return temp;
    // .then(
    //   // (querySnapshot) {
    //   //   print("Successfully completed");
    //   //   // for (var docSnapshot in querySnapshot.docs) {
    //   //   //   snapshot.add(docSnapshot.data());
    //   //   //   //print('${docSnapshot.id} => ${docSnapshot.data()}');
    //   //   //   print(docSnapshot.data());
    //   //   // }
    //   //   //return notesList;
    //   // },
    //   onError: (e) => print("Error completing: $e"),
    // );
  }

  @override
  void initState() {
    super.initState();
    //print("BEFORE THE GETDOCSLIST CALL");
    _future = _getDocsList(emailId: user.email!);
    print("INIT STATE IS CALLED");
  }

  @override
  Widget build(BuildContext context) {
    //snapshot = NoteshomeData().notesList;
    //print("REBUILT! $snapshot");
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.folder,
                    color: Colors.yellow,
                  )),
              const SizedBox(width: 30),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.check_box_outlined,
                    color: Colors.grey,
                  )),
              const SizedBox(width: 80),
              IconButton(
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("LogOut Successful")));
                      //setState(() {});
                    } catch (e) {
                      var _ = e;
                    }
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.grey,
                  )),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const EditScreen()));
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("SOME ERROR: ${snapshot.error}"),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length > 1
                        ? snapshot.data!.length - 1
                        : 1,
                    itemBuilder: (context, index) {
                      // Map<String, dynamic> ele =
                      //     snapshot.data!.elementAt(index + 1);
                      //print('THIS IS THE DATA IN SNAPSHOT: ${snapshot.data!} ${snapshot.data!.length}');
                      if (snapshot.data!.length > 1) {
                        Map<String, dynamic> ele =
                            snapshot.data!.elementAt(index + 1);
                        //print('THIS IS THE DATA IN SNAPSHOT: ${snapshot.data}');
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EditNote(
                                          prevDate: ele['Date'],
                                          title: ele['Title'],
                                          content: ele['Content'])));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(width: 1.5)),
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              ele['Title'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25),
                                            child: Text(
                                              ele['Date'],
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        ele['Content'],
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 77, 77, 77),
                                            fontSize: 16),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        );
                      } else {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                "Haven't Added any Notes yet...",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 25),
                              ),
                            ),
                          ],
                        );
                      }
                    });
              }
              return const Placeholder();
            }),
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            _future = _getDocsList(emailId: user.email!);
            setState(() {});
          });
        },
      ),
    ));
  }
}

// import 'package:flutter/material.dart';

// class HOMEPAGE extends StatefulWidget {
//   const HOMEPAGE({super.key});

//   @override
//   State<HOMEPAGE> createState() => _HOMEPAGEState();
// }

// class _HOMEPAGEState extends State<HOMEPAGE> {

//   final TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           actions: [
//             Row(
//               children: [
//                 IconButton(onPressed: (){}, icon: Icon(Icons.folder,color: Colors.yellow,)),

//                 SizedBox(width:30),
                
//                 IconButton(onPressed: (){}, icon: Icon(Icons.check_box_outlined,color: Colors.grey,)),

//                 SizedBox(width: 80),

//                 IconButton(onPressed: (){}, icon: Icon(Icons.settings,color: Colors.grey,)),
//               ],
//             )
//           ],
//         ),



//         body: Column(
//           children: [
//             SizedBox(height: 20),


//             SizedBox(
//               height: 45,
//               width:375 ,
//               child: TextFormField(
                
//                               controller: searchController,
//                               style: const TextStyle(color: Colors.white),
//                               decoration: InputDecoration(
//                                   prefixIcon: const Icon(
//                                     Icons.search,
//                                     color: Colors.grey,
//                                   ),
//                                   suffixIcon: GestureDetector(
//                                     onTap: () {
//                                       searchController.clear();
                                      
//                                       setState(() {});
//                                     },
//                                     child: const Icon(
//                                       Icons.clear,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   fillColor: Color.fromARGB(255, 234, 231, 231),
//                                   filled: true,
//                                   hintText: "Search notes",
//                                   hintStyle: const TextStyle(
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.bold),
//                                   border: const OutlineInputBorder(
//                                       borderSide: BorderSide.none,
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(60)))),
                              
//                             ),
//             ),


//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              
//               children: [
//                 Chip(label: Text("All"),backgroundColor: Color.fromARGB(255, 207, 203, 203),),

//                 Chip(label: Text("Call Notes"),backgroundColor: Color(0xFFF3F1F1),),

//                 Chip(label: Text("Call Notes"),backgroundColor: Color(0xFFF3F1F1),),

//                 Chip(label: Icon(Icons.folder_copy_outlined),backgroundColor: Color(0xFFF3F1F1),)
//               ],
//             ),

//             Container(
//               height: 620,
//               width: 375,
//               color: Color.fromARGB(255, 224, 221, 221),
//               child: ListView(
                
//                 // child: Container(
//                 //   height: 620,
//                 //   width: 380,
//                 //   color: Colors.amber,
                
//                   //  child: Column(
//                     children: [
              
//                       Row(
//                         children: [
                
//                           Container(
//                             height: 260,
//                             width: 372,
//                             child: GestureDetector(
//                               onTap: () {
                                
//                               },
//                               child: Card(
//                                 color: Colors.white,
                                
//                               ),
//                             ),
//                           ),
                
//                           // Container(
//                           //   height: 260,
//                           //   width: 186,
//                           //   child: Card(
                              
//                           //   ),
//                           // ),
                
//                         ],
//                       ),
              
              
//                       Row(
//                         children: [
                
//                           Container(
//                             height: 260,
//                             width: 372,
//                             child: GestureDetector(
//                               onTap: () {
                                
//                               },
//                               child: Card(
                                
//                               ),
//                             ),
//                           ),
                
//                           // Container(
//                           //   height: 260,
//                           //   width: 186,
//                           //   child: Card(
                              
//                           //   ),
//                           // ),
                
//                         ],
//                       ),
              
//                       Row(
//                         children: [
                
//                           Container(
//                             height: 260,
//                             width: 372,
//                             child: GestureDetector(
//                               onTap: () {
                                
//                               },
//                               child: Card(
                                
//                               ),
//                             ),
//                           ),
                
//                           // Container(
//                           //   height: 260,
//                           //   width: 186,
//                           //   child: Card(
                              
//                           //   ),
//                           // ),
                
//                         ],
//                       ),


//                       Row(
//                         children: [
                
//                           Container(
//                             height: 260,
//                             width: 372,
//                             child: GestureDetector(
//                               onTap: () {
                                
//                               },
//                               child: Card(
                                
//                               ),
//                             ),
//                           ),
                
//                           // Container(
//                           //   height: 260,
//                           //   width: 186,
//                           //   child: Card(
                              
//                           //   ),
//                           // ),
                
//                         ],
//                       ),
              
                      
//                     ],
//                   // ),
//                 // ),
//               ),
//             )
//           ],
//         ),

//         floatingActionButton:FloatingActionButton(
          
//           onPressed: (){},
//           child: Icon(Icons.add),
//           backgroundColor: Colors.amber,
//           ),
          
        
//       ));
//   }
// }