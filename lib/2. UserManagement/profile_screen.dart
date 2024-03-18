import 'package:flutter/material.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/profile_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String userImg = "/assets/images/defaultuserImg.jpg";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        ProfileAvatar(),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
