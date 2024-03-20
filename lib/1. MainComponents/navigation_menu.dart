import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:thesis_hospicesystem/1.%20MainComponents/management_screen.dart';
// ignore: unused_import
import 'package:thesis_hospicesystem/2.%20UserManagement/registration_screen.dart';

import 'dashboard_screen.dart';
import '../2. UserManagement/profile_screen.dart';
import '../6. Messaging/messages_screen.dart';
import 'settings_screen.dart';

class NavigationMenu extends StatefulWidget {
  final String currentuid;

  const NavigationMenu({required this.currentuid, Key? key}) : super(key: key);

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  String currentUID = FirebaseAuth.instance.currentUser!.uid;

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // ignore: avoid_print
    print('Tab $index selected');
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('OurHospice Management System'),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            DashboardScreen(currentuid: currentUID),
            ManagementScreen(),
            MessagesScreen(),
            ProfileScreen(currentuid: currentUID),
            SettingsScreen(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Hello USER'),
              ),
              ListTile(
                title: const Text('Dashboard'),
                onTap: () {
                  _selectedTab(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Management'),
                onTap: () {
                  _selectedTab(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Inbox'),
                onTap: () {
                  _selectedTab(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  _selectedTab(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  _selectedTab(4);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            DashboardScreen(currentuid: currentUID),
            MessagesScreen(),
            ProfileScreen(currentuid: currentUID),
            Register(currentuid: currentUID),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _selectedTab,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          selectedItemColor: Colors.green, // Set selected item color to black
          unselectedItemColor: Colors.black, // Set unselected item color to black
          selectedLabelStyle: const TextStyle(color: Colors.black), // Set selected label color to black
          unselectedLabelStyle: const TextStyle(color: Colors.black), // Set unselected label color to black
        ),
      );
    }
  }
}
