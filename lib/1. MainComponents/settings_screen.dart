import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double sidePadding = 20.0;
  double topPadding = 25;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      sidePadding = 240.0;
      topPadding = 50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          centerTitle: true,
          title: Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: topPadding),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Settings Screen'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
