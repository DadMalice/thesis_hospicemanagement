import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_hospicesystem/1.%20MainComponents/tab_bar_widget.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/editusers_screen.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/registration_screen.dart'; // Import your TabBarApp file

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String currentUID = FirebaseAuth.instance.currentUser!.uid;
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: const Column(
        children: [
          Expanded(
            child: TabBarApp(), // Include your custom tab bar here
          ),
        ],
      ),
    );
  }
}
