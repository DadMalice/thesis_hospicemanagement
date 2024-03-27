import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/edituser_details.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserStream();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];

    if (_searchController.text.isNotEmpty) {
      for (var userSnapshot in _allResults) {
        var firstName = userSnapshot['first name'].toString().toLowerCase();
        var lastName = userSnapshot['last name'].toString().toLowerCase();
        var searchQuery = _searchController.text.toLowerCase();

        if (firstName.contains(searchQuery) || lastName.contains(searchQuery)) {
          showResults.add(userSnapshot);
        }
      }
    }

    setState(() {
      _resultList = showResults;
    });
  }

  getUserStream() async {
    var data = await FirebaseFirestore.instance.collection('users').orderBy('first name').get();

    setState(() {
      _allResults = data.docs;
    });
  }

  String? getUserId(String firstName, String lastName) {
    for (var userSnapshot in _allResults) {
      if (userSnapshot['first name'] == firstName && userSnapshot['last name'] == lastName) {
        return userSnapshot.id;
      }
    }
    return null; // If user not found, return null
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: CupertinoSearchTextField(
            controller: _searchController,
            placeholder: 'Search by name',
          ),
        ),
        body: _searchController.text.isEmpty
            ? Container() // Empty container when search text is empty
            : ListView.builder(
                itemCount: _resultList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _resultList[index]['first name'],
                    ),
                    subtitle: Text(
                      _resultList[index]['last name'],
                    ),
                    trailing: Text(
                      _resultList[index]['email'],
                    ),
                    onTap: () {
                      String? userId = getUserId(
                        _resultList[index]['first name'],
                        _resultList[index]['last name'],
                      );

                      if (userId != null) {
                        // Navigate to the edit profile screen when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              String? userId = getUserId(
                                _resultList[index]['first name'],
                                _resultList[index]['last name'],
                              );

                              if (userId != null) {
                                return EditUserProfileScreen(
                                  firstName: _resultList[index]['first name'],
                                  lastName: _resultList[index]['last name'],
                                  accountUID: userId,
                                );
                              } else {
                                // Handle the case when user ID is not found
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("User not found."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
