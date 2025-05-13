import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/token.dart';
import 'models/user.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/wait_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Estas líneas son para que funcione el http con las direcciones https
  final context = SecurityContext.defaultContext;
  context.allowLegacyUnsafeRenegotiation = true;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _showLoginPage = true;
  bool isRemembered = true;
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
          ? const WaitScreen()
          : _showLoginPage
              ? const LoginScreen()
              : HomeScreen(
                  token: _token,
                  user: _user,
                  rememberme: isRemembered,
                ),
    );
  }

  void _getHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isRemembered = prefs.getBool('isRemembered') ?? false;
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
