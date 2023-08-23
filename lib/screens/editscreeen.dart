import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:notes_app/cubit/noteshome_cubit.dart';
import 'package:notes_app/services/savedata.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  DateTime today = DateTime.now();
  User user = FirebaseAuth.instance.currentUser!;
  CRUD noteseditor = CRUD();
  late String _docname;
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentctrl = TextEditingController();
  bool isCreating = true;
  final FocusNode _focusNodetitle = FocusNode();
  final FocusNode _focusNodenotes = FocusNode();

  bool isTextFieldActive = false;

  @override
  void initState() {
    super.initState();
    _focusNodetitle.addListener(_onTitleFocusChange);
    _focusNodenotes.addListener(_onNodeFocusChange);
  }

  void _onTitleFocusChange() {
    setState(() {
      isTextFieldActive = _focusNodetitle.hasFocus;
    });
  }

  void _onNodeFocusChange() {
    setState(() {
      isTextFieldActive = _focusNodenotes.hasFocus;
    });
  }

  void _deactivateTextField() {
    _focusNodetitle.unfocus();
    _focusNodenotes.unfocus();
  }

  @override
  void dispose() {
    _focusNodetitle.dispose();
    _focusNodenotes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          actions: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  controller: _titlecontroller,
                  focusNode: _focusNodetitle,
                  decoration: const InputDecoration(
                      hintText: "Enter Title..",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )),
            isTextFieldActive
                ? IconButton(
                    onPressed: () async {
                      _deactivateTextField();
                      isTextFieldActive = !isTextFieldActive;
                      //_docname = '${user.email}${_titlecontroller.text}';
                      if (isCreating) {
                        //_docname = '${user.email}${_titlecontroller.text}';
                        print("THIS IS CALLED ");
                        await noteseditor.setUserData(
                            emailId: user.email!,
                            title: _titlecontroller.text,
                            docname: '${user.email}${_titlecontroller.text}',
                            content: _contentctrl.text,
                            isCreated: isCreating);
                        isCreating = false;
                        _docname = '${user.email}${_titlecontroller.text}';
                      } else {
                        await noteseditor.deleteUserData(
                            emailId: user.email!, docname: _docname);
                        await noteseditor.setUserData(
                            emailId: user.email!,
                            title: _titlecontroller.text,
                            docname: '${user.email}${_titlecontroller.text}',
                            content: _contentctrl.text,
                            isCreated: isCreating);

                        _docname = '${user.email}${_titlecontroller.text}';
                      }

                      //setState(() {});
                    },
                    icon: const Icon(Icons.check))
                : IconButton(
                    onPressed: () async {
                      _deactivateTextField();
                      bool isExists = await noteseditor.deleteUserData(
                          emailId: user.email!, docname: _docname);
                      if (!isExists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Document Already Deleted")));
                      }
                      //isTextFieldActive = !isTextFieldActive;
                      Navigator.pop(context);
                      //setState(() {});
                    },
                    icon: const Icon(Icons.delete))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '${today.day}-${today.month}-${today.year}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              TextField(
                focusNode: _focusNodenotes,
                controller: _contentctrl,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: "Whats on your Mind?", border: InputBorder.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
