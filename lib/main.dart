import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'package:thesis_hospicesystem/1.%20MainComponents/login_screen.dart';
// ignore: unused_import
import 'package:thesis_hospicesystem/1.%20MainComponents/navigation_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDmPXtDHg3C0b6ka0fL3KuCytTK_vgIAXE",
      appId: "1:774583639375:android:d720abd57ea218e787b93a",
      messagingSenderId: "774583639375",
      projectId: "thesis-ourhospice",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),
    );
  }
}
