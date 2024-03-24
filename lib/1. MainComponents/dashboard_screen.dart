import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final String currentuid;
  DashboardScreen({Key? key, required this.currentuid}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // Add your leading widget functionality here
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
      body: Center(
        child: Text('UserID Logged in: ${widget.currentuid}'),
      ),
    );
  }
}
