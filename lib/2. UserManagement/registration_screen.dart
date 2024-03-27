import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:thesis_hospicesystem/1.%20MainComponents/navigation_menu.dart';

class Register extends StatefulWidget {
  final String currentuid;

  const Register({Key? key, required this.currentuid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController verifyEmail = TextEditingController();
  final TextEditingController verifyPassword = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobilefnameController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'Admin',
    'Doctor',
    'Nurse',
    'Healthcare Provider',
    'Spiritual Counselor',
    'Patient',
  ];
  var _currentItemSelected = "Patient";
  var role = "Patient";

  late double sidePadding;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      sidePadding = 240.0;
    } else {
      sidePadding = 20.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'User Registration',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sidePadding,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Account Creation",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: fnameController,
                                    decoration: const InputDecoration(
                                      hintText: "First Name",
                                      //prefixIcon: Icon(Icons.person, color: Colors.black),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "First name cannot be empty";
                                      }
                                      // Add your validation logic here for the first name.
                                      return null;
                                    },
                                    onChanged: (value) {},
                                    keyboardType: TextInputType.name,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: lnameController,
                                    decoration: const InputDecoration(
                                      hintText: "Last Name",
                                      //prefixIcon: Icon(Icons.person, color: Colors.black),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Last name cannot be empty";
                                      }
                                      // Add your validation logic here for the last name.
                                      return null;
                                    },
                                    onChanged: (value) {},
                                    keyboardType: TextInputType.name,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                hintText: "Email",
                                prefixIcon: Icon(Icons.mail, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email cannot be empty";
                                }
                                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                  return ("Please enter a valid email");
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {},
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: _isObscure,
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.lock, color: Colors.black),
                                suffixIcon: IconButton(
                                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    }),
                              ),
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return "Password cannot be empty";
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Please enter valid password minimum of 6 characters.");
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: _isObscure2,
                              controller: confirmpassController,
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                prefixIcon: const Icon(Icons.lock, color: Colors.black),
                                suffixIcon: IconButton(
                                    icon: Icon(_isObscure2 ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure2 = !_isObscure2;
                                      });
                                    }),
                              ),
                              validator: (value) {
                                if (confirmpassController.text != passwordController.text) {
                                  return "Password did not match";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Role : ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                DropdownButton<String>(
                                  dropdownColor: Colors.green,
                                  isDense: false,
                                  isExpanded: false,
                                  iconEnabledColor: Colors.black,
                                  focusColor: Colors.black,
                                  padding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 12.0),
                                  items: options.map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(
                                        dropDownStringItem,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValueSelected) {
                                    setState(() {
                                      _currentItemSelected = newValueSelected!;
                                      role = newValueSelected;
                                    });
                                  },
                                  value: _currentItemSelected,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      signUp(fnameController.text, lnameController.text, emailController.text,
                                          passwordController.text, role, context);
                                    },
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                                    ),
                                    child: const Text(
                                      "Create Account",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }

  Future<void> postDetailsToFirestore(
      String fname, String lname, String email, String role, BuildContext context) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      String currentUID = FirebaseAuth.instance.currentUser!.uid;
      if (user != null) {
        CollectionReference ref = FirebaseFirestore.instance.collection('users');
        await ref.doc(user.uid).set({
          'first name': fname,
          'last name': lname,
          'email': email,
          'role': role,
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("User Created"),
              content: Text("Current UID: $currentUID"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationMenu(currentuid: currentUID),
                      ),
                    );
                  },
                  child: const Text("Okay"),
                ),
              ],
            );
          },
        );
      } else {
        throw FirebaseAuthException(message: "User not logged in", code: '');
      }
    } catch (e) {
      print("Error occurred during posting details to Firestore: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Failed to create user. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Okay"),
              ),
            ],
          );
        },
      );
    }
  }

  // Show the sign-in dialog
  void showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Security Verification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: verifyEmail,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: verifyPassword,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                bool success = await handleSignIn();
                if (success) {
                  Navigator.of(context).pop();
                } else {
                  print('Incorrect Credentials!');
                }
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  // Handle sign-in when the user submits the form
  Future<bool> handleSignIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: verifyEmail.text,
        password: verifyPassword.text,
      );
      // User signed in successfully
      User? user = userCredential.user;
      print('Re Sign-in SUCCESS!');
      return true; // Return true indicating successful sign-in
    } catch (e) {
      // Handle sign-in error (e.g., invalid credentials)
      print('Sign-in error: $e');
      return false; // Return false indicating unsuccessful sign-in
    }
  }

  void signUp(String fname, String lname, String email, String password, String role, BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      try {
        // Create user
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Now push user details to Firestore
        await postDetailsToFirestore(fname, lname, email, role, context);

        // Show dialog indicating successful sign up
        showSignInDialog(context);

        // Clear form fields
        fnameController.clear();
        lnameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmpassController.clear();
      } catch (e) {
        // Handle errors if any
        print("Error occurred during sign up: $e");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("User Registration"),
                content: const Text("Sign up failed. Please try again."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Okay"),
                  ),
                ],
              );
            });
      }
    }
  }
}
