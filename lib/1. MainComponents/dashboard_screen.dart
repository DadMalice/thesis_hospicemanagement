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
      body: Center(
        child: Text('UserID Logged in: ${widget.currentuid}'),
      ),
    );
  }
}
