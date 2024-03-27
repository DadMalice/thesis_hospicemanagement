import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/registration_screen.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/usersearch_bar.dart';
// Import your Register widget here

class TabBarApp extends StatelessWidget {
  const TabBarApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const TabBarExample(),
    );
  }
}

class TabBarExample extends StatelessWidget {
  const TabBarExample({Key? key});

  @override
  Widget build(BuildContext context) {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.person_add_alt),
                  text: 'User Registration',
                ),
                Tab(
                  icon: Icon(Icons.edit),
                  text: 'Edit User Profile',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  // First tab's content
                  Register(currentuid: currentUID),
                  // Second tab's content
                  UserSearch(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
