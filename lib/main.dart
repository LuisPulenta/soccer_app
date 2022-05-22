import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_app/models/token.dart';
import 'package:soccer_app/models/user.dart';
import 'package:soccer_app/screens/home_screen.dart';
import 'package:soccer_app/screens/login_screen.dart';
import 'package:soccer_app/screens/wait_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _showLoginPage = true;
  late Token _token;
  late User _user;

  @override
  void initState() {
    super.initState();
    _getHome();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soccer App',
      home: _isLoading
          ? WaitScreen()
          : _showLoginPage
              ? LoginScreen()
              : HomeScreen(token: _token, user: _user),
    );
  }

  void _getHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isRemembered = prefs.getBool('isRemembered') ?? false;
    if (isRemembered) {
      String? tokenBody = prefs.getString('tokenBody');

      if (tokenBody != null) {
        var decodedTokenJson = jsonDecode(tokenBody);
        _token = Token.fromJson(decodedTokenJson);
        if (DateTime.parse(_token.expiration).isAfter(DateTime.now())) {
          _showLoginPage = false;
        }
      }

      String? userBody = prefs.getString('userBody');

      if (userBody != null) {
        var decodedUserJson = jsonDecode(userBody);
        _user = User.fromJson(decodedUserJson);
      }
    }
    _isLoading = false;
    setState(() {});
  }
}
