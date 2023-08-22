import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/homepage.dart';
import 'package:notes_app/services/userauth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isPasswordShow = false;
  bool isRegisterPageShow = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailControllerRegister =
      TextEditingController();
  final TextEditingController _passwordControllerRegister =
      TextEditingController();

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController phone = TextEditingController();
  final UserAuth _auth = UserAuth();
  String? _validatePwdLength(String? value) {
    if (value!.length <= 8) {
      return 'Minimun 8 Chars';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return !isRegisterPageShow
        ? SafeArea(
            child: Scaffold(
                body: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 35),
                          ),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _emailController.clear();
                                    // _emailController.text = '';
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                                fillColor: Colors.black,
                                filled: true,
                                hintText: "Please enter your email",
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            // validator: _validatePwdLength
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !isPasswordShow,
                            obscuringCharacter: '⬤',
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    isPasswordShow = !isPasswordShow;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    isPasswordShow
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                                fillColor: Colors.black,
                                filled: true,
                                hintText: "Please enter your password",
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            validator: _validatePwdLength,
                          ),
                          TextButton(
                              onPressed: () {
                                isRegisterPageShow = !isRegisterPageShow;

                                setState(() {});
                              },
                              child: const Text(
                                  "Don't have an Account? Register Now")),
                          OutlinedButton(
                              onPressed: () {
                                _auth.loginUser(
                                    logEmail: _emailController.text,
                                    logPassword: _passwordController.text);

                                if (FirebaseAuth.instance.currentUser != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Error Logging In")));
                                }

                                // _formKey.currentState!.validate();
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(
                                //         content: Text("I AM THE BUTTON")));
                              },
                              child: const Text("LOGIN NOW"))
                        ],
                      ),
                    ))))
        : SafeArea(
            child: Scaffold(
                body: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            "REGISTER",
                            style: TextStyle(fontSize: 35),
                          ),
                          TextFormField(
                            controller: fname,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _emailController.clear();
                                    // _emailController.text = '';
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                                fillColor: Colors.black,
                                filled: true,
                                hintText: "First Name",
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            // validator: _validatePwdLength
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          TextFormField(
                            controller: lname,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _emailController.clear();
                                    // _emailController.text = '';
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                                fillColor: Colors.black,
                                filled: true,
                                hintText: "Last Name",
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            // validator: _validatePwdLength
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          TextFormField(
                            controller: phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _emailController.clear();
                                    // _emailController.text = '';
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                                fillColor: Colors.black,
                                filled: true,
                                hintText: "Phone Number",
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            // validator: _validatePwdLength
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          TextFormField(
                            controller: _emailControllerRegister,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _emailController.clear();
                                    // _emailController.text = '';
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                                fillColor: Colors.black,
                                filled: true,
                                hintText: "Please enter your email",
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            // validator: _validatePwdLength
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          TextFormField(
                            controller: _passwordControllerRegister,
                            obscureText: !isPasswordShow,
                            obscuringCharacter: '⬤',
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    isPasswordShow = !isPasswordShow;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    isPasswordShow
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                                fillColor: Colors.black,
                                filled: true,
                                hintText: "Please enter your password",
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            validator: _validatePwdLength,
                          ),
                          TextButton(
                              onPressed: () {
                                isRegisterPageShow = !isRegisterPageShow;
                                setState(() {});
                              },
                              child: const Text("Have an Account? Login")),
                          OutlinedButton(
                              onPressed: () {
                                // _auth.loginUser(
                                //     logEmail: _emailController.text,
                                //     logPassword: _passwordController.text);
                                //print("im here!");
                                _auth.createNewUser(
                                    firstName: fname.text,
                                    lastName: lname.text,
                                    phoneNumber: phone.text,
                                    regEmail: _emailControllerRegister.text,
                                    regPassword:
                                        _passwordControllerRegister.text);
                                _formKey.currentState!.validate();
                                if (FirebaseAuth.instance.currentUser != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                } else {
                                  setState(() {
                                    isRegisterPageShow = !isRegisterPageShow;
                                  });
                                }
                                // // ScaffoldMessenger.of(context).showSnackBar(
                                // //     const SnackBar(
                                // //         content: Text("I AM THE BUTTON")));
                              },
                              child: Text(!isRegisterPageShow
                                  ? "LOGIN NOW"
                                  : "REGISTER NOW"))
                        ],
                      ),
                    ))));
  }
}
