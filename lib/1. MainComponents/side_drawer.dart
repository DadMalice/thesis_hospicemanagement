import 'package:flutter/material.dart';
import 'package:thesis_hospicesystem/2.%20UserManagement/usermanagement_screen.dart';

class SideDrawer extends StatelessWidget {
  final String userRole;
  SideDrawer({required this.userRole});

  @override
  Widget build(BuildContext context) {
    List<String> allowedScreens = [];

    // Determine allowed screens based on user role
    switch (userRole) {
      case 'Admin':
        allowedScreens = ['User Management', 'Patient Management', 'Appointment Management', 'Inventory Management'];
        break;
      case 'Doctor':
      case 'Nurse':
        allowedScreens = ['Patient Management', 'Appointment Management', 'Inventory Management'];
        break;
      case 'Healthcare Provider':
        allowedScreens = ['Patient Management', 'Inventory Management'];
        break;
      case 'Spiritual Counselor':
        allowedScreens = ['Patient Management', 'Appointment Management'];
        break;
      case 'Patient':
        allowedScreens = ['Patient Management', 'Appointment Management'];
        break;
      default:
        allowedScreens = [];
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'Dashboard Screens',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          for (var screen in allowedScreens)
            ListTile(
              title: Text(screen),
              onTap: () {
                // Handle tapping on a screen item in the drawer
                Navigator.pop(context); // Close the drawer

                // Navigate to the selected screen
                if (screen == 'User Management') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserManagementScreen()),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
