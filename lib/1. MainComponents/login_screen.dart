import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesis_hospicesystem/1.%20MainComponents/navigation_menu.dart';
import 'package:thesis_hospicesystem/1.%20MainComponents/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final _showErrorMessage = false;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Login Error',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Email or Password is incorrect'),
                Text('Please check your credentials.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Try again'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    User? user = await _auth.loginInWithEmailAndPassword(email, password);

    if (user != null) {
      // Get UID of the logged-in user
      String currentUID = FirebaseAuth.instance.currentUser!.uid;

      // Navigate to the NavigationMenu screen and pass the UID
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NavigationMenu(currentuid: currentUID)),
      );
    } else {
      // Show error dialog if login fails
      _showMyDialog();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double sidePadding = 20.0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: sidePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello there!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Welcome to OurHospice App",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32.0),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.mail, color: Colors.black),
              ),
            ),
            const SizedBox(height: 14.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10.0),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Can't remember your password?",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            if (_showErrorMessage)
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Incorrect Password. Please Try Again!",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            SizedBox(
              height: _showErrorMessage ? 10.0 : 0.0,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.50,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _handleLogin(context),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                    ),
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            "Login",
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
    );
  }
}
