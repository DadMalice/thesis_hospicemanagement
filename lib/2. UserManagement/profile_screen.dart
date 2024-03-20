import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_hospicesystem/1.%20MainComponents/login_screen.dart';
import 'package:thesis_hospicesystem/1.%20MainComponents/section_heading.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/profile_avatar.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/profile_details.dart';

class ProfileScreen extends StatefulWidget {
  final String currentuid;

  ProfileScreen({Key? key, required this.currentuid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String userImg = "/assets/images/defaultuserImg.jpg";

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _birthDateController;

  String? uid;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _roleController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _birthDateController = TextEditingController();
    // Fetch user profile data based on the UID
    fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                        ///Profile Picture
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              const ProfileAvatar(),
                              TextButton(
                                onPressed: () {
                                  // Your onPressed logic goes here
                                },
                                child: const Text('Change Profile Picture'),
                              )
                            ],
                          ),
                        ),

                        ///Profile Details
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(height: 10),
                        const SectionHeading(
                          title: 'Profile Information',
                          showActionButton: false,
                        ),
                        const SizedBox(height: 12),

                        ProfileDetails(
                          title: 'Name',
                          value: _nameController.text,
                          onPressed: () {},
                        ),
                        ProfileDetails(
                          title: 'Email',
                          value: _emailController.text,
                          onPressed: () {},
                        ),
                        ProfileDetails(
                          title: 'Position',
                          value: _roleController.text,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        const SectionHeading(
                          title: 'Personal Information',
                          showActionButton: false,
                        ),
                        const SizedBox(height: 10),
                        ProfileDetails(
                          title: 'Age',
                          value: _ageController.text,
                          onPressed: () {},
                        ),
                        ProfileDetails(
                          title: 'Gender',
                          value: _genderController.text,
                          onPressed: () {},
                        ),
                        ProfileDetails(
                          title: 'Date of Birth',
                          value: _birthDateController.text,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 20), // Add spacing between profile info and sign out text
                        TextButton(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              print("Sign out SUCCESS!");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            } catch (e) {
                              print("Error signing out: $e");
                            }
                          },
                          child: const Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Colors.red, // Customize the color if needed
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  void fetchUserProfile() {
    final uid = widget.currentuid;
    if (uid != null) {
      FirebaseFirestore.instance.collection('users').doc(uid).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          final userData = documentSnapshot.data() as Map<String, dynamic>;
          if (userData != null) {
            setState(() {
              final firstName = userData['first name'] ?? ''; // Fetch first name
              final lastName = userData['last name'] ?? ''; // Fetch last name
              final fullName = '$firstName $lastName';
              _nameController.text = fullName.isNotEmpty ? fullName : 'Undefined';
              _emailController.text = userData['email'] ?? 'Undefined';
              _roleController.text = userData['role'] ?? 'Undefined';
              _ageController.text = userData['age'] ?? 'Undefined';
              _genderController.text = userData['gender'] ?? 'Undefined';
              _birthDateController.text = userData['birthdate'] ?? 'Undefined';
            });
          }
        }
      }).catchError((error) {
        print('Error fetching user profile: $error');
      });
    }
  }

  void _updateProfile() {
    // Implement update profile method as before
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
