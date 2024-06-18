// lib/screens/home.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _logoutTimer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
    }
    _logoutTimer = Timer(const Duration(minutes: 5), _logoutUser);
  }

  void _logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetTimer,
      onPanDown: (details) => _resetTimer(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ERPNext App'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.receipt),
                title: const Text('Sales'),
                onTap: () {
                  Navigator.pushNamed(context, '/sales');
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Purchase'),
                onTap: () {
                  Navigator.pushNamed(context, '/purchase');
                },
              ),
            ],
          ),
        ),
        body: const Center(
          child: Text('Welcome to ERPNext App'),
        ),
      ),
    );
  }
}
