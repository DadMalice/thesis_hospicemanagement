import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/profile_details.dart';

class EditUserProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String accountUID;
  String selectedDate = '';

  EditUserProfileScreen({
    required this.firstName,
    required this.lastName,
    required this.accountUID,
  });

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  File? _image;
  final picker = ImagePicker();
  String selectedDate = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    final uid = widget.accountUID;
    if (uid != null) {
      try {
        final userData = (await FirebaseFirestore.instance.collection('users').doc(uid).get()).data();
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
            final profilePictureFileName = '$firstName.jpg';
            getProfilePictureUrl(uid, profilePictureFileName);
          });
        }
      } catch (error) {
        print('Error fetching user profile: $error');
      }
    }
  }

  void getProfilePictureUrl(String userId, String fileName) async {
    try {
      final Reference ref = FirebaseStorage.instance.ref().child('profile_pictures/$userId/$fileName');
      final String downloadUrl = await ref.getDownloadURL();
      setState(() {
        _profilePictureUrl = downloadUrl;
        print('Profile Picture URL loaded successfully: $_profilePictureUrl');
      });
    } catch (error) {
      print('Error getting profile picture URL: $error');
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

  Future<void> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadProfilePicture();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadProfilePicture() async {
    try {
      if (_image != null) {
        final uid = widget.accountUID;
        final firstName = _nameController.text.split(' ')[0]; // Get the first name
        if (uid != null) {
          // Upload image to Firebase Storage with the user's first name as the file name
          final Reference ref = FirebaseStorage.instance.ref().child('profile_pictures/$uid/$firstName.jpg');
          final UploadTask uploadTask = ref.putFile(_image!);

          // Get download URL and update user profile
          final TaskSnapshot taskSnapshot = await uploadTask;
          final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          // Update user profile with the new profile picture URL
          await _firestore.collection('users').doc(uid).update({
            'profile_picture': downloadUrl,
          });
          setState(() {
            // Reload the app when the profile picture is uploaded
            _profilePictureUrl = downloadUrl;
          });
          print('Profile picture loaded successfully.');
        }
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
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
    final uid = widget.accountUID;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.firstName} ${widget.lastName}\'s Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          // Display profile picture
                          _profilePictureUrl != null
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(_profilePictureUrl!),
                                )
                              : const CircleAvatar(
                                  radius: 60,
                                  child: Icon(Icons.account_circle, size: 100),
                                ),
                          TextButton(
                            onPressed: () {
                              _pickImage();
                            },
                            child: const Text('Change Profile Picture'),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Profile Information',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    const Text(
                      'Personal Information',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
