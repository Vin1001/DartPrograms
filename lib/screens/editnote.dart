//import 'package:notes_app/screens/editscreeen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/savedata.dart';

class EditNote extends StatefulWidget {
  final String prevDate;
  final String title;
  final String content;
  const EditNote(
      {super.key,
      required this.prevDate,
      required this.title,
      required this.content});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  DateTime today = DateTime.now();
  User user = FirebaseAuth.instance.currentUser!;
  CRUD noteseditor = CRUD();
  late String _docname;
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentctrl = TextEditingController();
  bool isCreating = false;
  bool isDocnameinit = false;
  final FocusNode _focusNodetitle = FocusNode();
  final FocusNode _focusNodenotes = FocusNode();

  bool isTextFieldActive = false;

  @override
  void initState() {
    super.initState();
    _focusNodetitle.addListener(_onTitleFocusChange);
    _focusNodenotes.addListener(_onNodeFocusChange);
    _titlecontroller.text = widget.title;
    _contentctrl.text = widget.content;
    _docname = '${user.email}${_titlecontroller.text}';
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
    //_docname = '${user.email}${_titlecontroller.text}';
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
                  readOnly: false,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  controller: _titlecontroller,
                  focusNode: _focusNodetitle,
                  decoration: const InputDecoration(border: InputBorder.none
                      // hintText: "Enter Title..",
                      // hintStyle: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold)
                      ),
                )),
            isTextFieldActive
                ? IconButton(
                    onPressed: () async {
                      _deactivateTextField();
                      isTextFieldActive = !isTextFieldActive;
                      // if (!isDocnameinit) {
                      //   _docname = '${user.email}${_titlecontroller.text}';
                      //   isDocnameinit = true;
                      // }
                      //print("THIS IS THE DOC NME:$_docname");
                      if (isCreating) {
                        //print("THIS IS CALLED");
                        noteseditor.setUserData(
                            emailId: user.email!,
                            title: _titlecontroller.text,
                            docname: _docname,
                            content: _contentctrl.text,
                            isCreated: isCreating);
                      } else {
                        //_docname = '${user.email}${_titlecontroller.text}';
                        print("THIS IS THE DOC NAME: $_docname");
                        await noteseditor.deleteUserData(
                            emailId: user.email!, docname: _docname);
                        await noteseditor.setUserData(
                            emailId: user.email!,
                            title: _titlecontroller.text,
                            docname: '${user.email}${_titlecontroller.text}',
                            content: _contentctrl.text,
                            isCreated: true);

                        _docname = '${user.email}${_titlecontroller.text}';
                      }

                      isCreating = false;
                      //setState(() {});
                    },
                    icon: const Icon(Icons.check))
                : IconButton(
                    onPressed: () async {
                      _deactivateTextField();
                      // if (!isDocnameinit) {
                      //   _docname = '${user.email}${_titlecontroller.text}';
                      //   isDocnameinit = true;
                      // }
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
                    widget.prevDate,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              TextField(
                focusNode: _focusNodenotes,
                controller: _contentctrl,
                maxLines: null,
                decoration: const InputDecoration(
                    //hintText: "Whats on your Mind?",
                    border: InputBorder.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
