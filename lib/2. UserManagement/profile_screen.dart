import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as DatePicker;
import 'package:thesis_hospicesystem/1.%20MainComponents/login_screen.dart';
import 'package:thesis_hospicesystem/1.%20MainComponents/section_heading.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/profile_avatar.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/profile_details.dart';

class ProfileScreen extends StatefulWidget {
  final String currentuid;
  String selectedDate = '';

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
  late TextEditingController _addressController;
  late TextEditingController _birthDateController;

  final TextEditingController editAge = TextEditingController();
  final TextEditingController editGender = TextEditingController();
  final TextEditingController editAddress = TextEditingController();
  final TextEditingController editDateOfBirth = TextEditingController();

  String? uid;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _roleController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _addressController = TextEditingController();
    _birthDateController = TextEditingController();
    // Fetch user profile data based on the UID
    fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: AppBar(
            backgroundColor: Colors.green,
            elevation: 0,
            centerTitle: true,
            title: Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: const Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
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
                                  // Changeing Profile Picture
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
                          onPressed: () {
                            showEditDetailDialog(context, 'Update Age');
                          },
                        ),

                        ProfileDetails(
                          title: 'Gender',
                          value: _genderController.text,
                          onPressed: () {
                            showEditDetailDialog(context, 'Update Gender');
                          },
                        ),
                        ProfileDetails(
                          title: 'Address',
                          value: _addressController.text,
                          onPressed: () {
                            showEditDetailDialog(context, 'Update Address');
                          },
                        ),
                        ProfileDetails(
                          title: 'Date of Birth',
                          value: _birthDateController.text,
                          onPressed: () {
                            showEditDetailDialog(context, 'Update Date Of Birth');
                          },
                        ),
                        const SizedBox(height: 20),
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
              final firstName = userData['first name'] ?? '';
              final lastName = userData['last name'] ?? '';
              final fullName = '$firstName $lastName';
              _nameController.text = fullName.isNotEmpty ? fullName : 'Undefined';
              _emailController.text = userData['email'] ?? 'Undefined';
              _roleController.text = userData['role'] ?? 'Undefined';
              _ageController.text = userData['age'] ?? 'Undefined';
              _genderController.text = userData['gender'] ?? 'Undefined';
              _addressController.text = userData['address'] ?? 'Undefined';
              _birthDateController.text = userData['birthdate'] ?? 'Undefined';
            });
          }
        }
      }).catchError((error) {
        print('Error fetching user profile: $error');
      });
    }
  }

  void showEditDetailDialog(BuildContext context, String title) {
    String selectedDate = '';
    String newValue = '';
    String? selectedGender = 'Male';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('$title'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title == 'Update Age' || title == 'Update Address')
                    TextFormField(
                      onChanged: (value) {
                        newValue = value;
                      },
                    ),
                  if (title == 'Update Gender')
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      items: ['Male', 'Female']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                    ),
                  if (title == 'Update Date Of Birth')
                    Column(
                      children: [
                        Text(selectedDate.isNotEmpty ? 'Selected Date: $selectedDate' : selectedDate),
                        TextButton(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                              });
                            }
                          },
                          child: Text('Choose Date'),
                        ),
                      ],
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
                    if ((title == 'Update Date Of Birth' && selectedDate.isNotEmpty == true) ||
                        (title != 'Update Date Of Birth' && newValue.isNotEmpty) ||
                        (title == 'Update Gender' && selectedGender != null)) {
                      String valueToUpdate = title == 'Update Date Of Birth'
                          ? selectedDate
                          : title == 'Update Gender'
                              ? selectedGender!
                              : newValue;
                      bool success = await updateDetails(valueToUpdate, title);
                      if (success) {
                        Navigator.of(context).pop();
                      } else {
                        print('Error updating the details');
                      }
                    } else {
                      print('Please select a valid value.');
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        widget.selectedDate = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
        _birthDateController.text = widget.selectedDate;
      });
    }
  }

  Future<bool> updateDetails(String value, String title) async {
    final uid = widget.currentuid;

    try {
      // Get a reference to Firestore collection
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Determine which field to update based on the title
      String fieldName;
      if (title == 'Update Age') {
        fieldName = 'age';
      } else if (title == 'Update Gender') {
        fieldName = 'gender';
      } else if (title == 'Update Address') {
        fieldName = 'address';
      } else if (title == 'Update Date Of Birth') {
        fieldName = 'birthdate';
      } else {
        throw Exception('Invalid title provided.');
      }

      // Update the specific field for the user
      await users.doc(uid).update({fieldName: value});

      // Update the corresponding text field with the new value
      setState(() {
        switch (title) {
          case 'Update Age':
            _ageController.text = value;
            break;
          case 'Update Gender':
            _genderController.text = value;
            break;
          case 'Update Address':
            _addressController.text = value;
            break;
          case 'Update Date Of Birth':
            _birthDateController.text = value; // Make sure widget.selectedDate is updated correctly
            break;
          default:
            break;
        }
      });

      print('Update successful');
      return true;
    } catch (e) {
      print('Error updating details: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
