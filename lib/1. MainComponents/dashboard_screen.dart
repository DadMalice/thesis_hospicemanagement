import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thesis_hospicesystem/1.%20MainComponents/side_drawer.dart';

class DashboardScreen extends StatefulWidget {
  final String currentuid;

  DashboardScreen({Key? key, required this.currentuid}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

Future<String> getUserRole(String userID) async {
  String role = 'default'; // Default role if not found

  try {
    // Fetch user document from Firestore using UserID
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userID).get();

    // Check if user document exists and contains 'role' field
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if (userData.containsKey('role')) {
        role = userData['role'] as String;
      }
    }
  } catch (e) {
    print('Error fetching user role: $e');
  }

  return role;
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dashboard',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(75.0), // Increased height to accommodate top margin
            child: AppBar(
              backgroundColor: Colors.green,
              elevation: 0,
              centerTitle: true,
              leading: Container(
                margin: const EdgeInsets.only(top: 20.0, left: 5.0), // Adding top and right margins to leading widget
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Open the side drawer when the menu icon is pressed
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
              title: Container(
                margin: const EdgeInsets.only(top: 20.0), // Adding top margin to title
                child: const Text(
                  'Dashboard',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              actions: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20.0, right: 5.0), // Adding top and left margins to action widget
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Add your action widget functionality here
                    },
                  ),
                ),
              ],
            ),
          ),
          drawer: FutureBuilder<String>(
            future: getUserRole(widget.currentuid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the future to complete, show a loading indicator
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If there's an error fetching the user role, display an error message
                return Text('Error fetching user role');
              } else {
                // If the future completes successfully, pass the user role to the SideDrawer
                return SideDrawer(userRole: snapshot.data ?? 'default');
              }
            },
          ), // Add the SideDrawer widget here
          body: Center(
            child: Text('UserID Logged in: ${widget.currentuid}'),
          ),
        ));
  }
}
