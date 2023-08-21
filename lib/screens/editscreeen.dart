import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentctrl = TextEditingController();
  bool isEditing = false;
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
                    onPressed: () {
                      _deactivateTextField();
                      isTextFieldActive = !isTextFieldActive;
                      setState(() {});
                    },
                    icon: const Icon(Icons.check))
                : IconButton(
                    onPressed: () {
                      _deactivateTextField();
                      //isTextFieldActive = !isTextFieldActive;
                      setState(() {});
                    },
                    icon: const Icon(Icons.delete))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            focusNode: _focusNodenotes,
            controller: _contentctrl,
            maxLines: null,
            decoration: const InputDecoration(
                hintText: "Whats on your Mind?", border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
