import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/constants.dart';
import '../models/models.dart';
import 'screens.dart';

class HomeScreen extends StatefulWidget {
  final Token token;
  final User user;
  final bool rememberme;

  const HomeScreen({
    super.key,
    required this.token,
    required this.user,
    required this.rememberme,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLoader = false;
  late User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = widget.user;
    //_getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D99D),
      appBar: AppBar(
        title: const Text('Soccer'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 69, 48),
      ),
      body: _getBody(),
      drawer: _getMenu(),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/logo.png'), width: 200),
            const SizedBox(height: 40),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: _user.pictureFullPath,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                    placeholder: (context, url) => const Image(
                      image: AssetImage('assets/loading.gif'),
                      fit: BoxFit.cover,
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 00,
                  left: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: _user.team.logoFullPath,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.contain,
                      height: 70,
                      width: 70,
                      placeholder: (context, url) => const Image(
                        image: AssetImage('assets/loading.gif'),
                        fit: BoxFit.contain,
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Bienvenido/a ${_user.fullName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMenu() {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 5, 68, 7),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(5),
            child: Stack(
              children: [
                const Image(
                  image: AssetImage('assets/logo.png'),
                  height: 120,
                  width: 120,
                ),
                Positioned(
                  top: 10,
                  left: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: _user.pictureFullPath,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                      placeholder: (context, url) => const Image(
                        image: AssetImage('assets/loading.gif'),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 230,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: _user.team.logoFullPath,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.contain,
                      height: 60,
                      width: 60,
                      placeholder: (context, url) => const Image(
                        image: AssetImage('assets/loading.gif'),
                        fit: BoxFit.contain,
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 10,
                  child: Text(
                    "${_user.firstName} ${_user.lastName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 45,
                  child: Text(
                    '(a) ' + _user.nickName,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.black),
            title: const Text('Torneos'),
            tileColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TournamentsScreen(
                    token: widget.token,
                    opcion: 1,
                    user: widget.user,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.groups, color: Colors.black),
            title: const Text('Grupos'),
            tileColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyGroupsScreen(token: widget.token, user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer, color: Colors.black),
            title: const Text('Predicciones'),
            tileColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TournamentsScreen(
                    token: widget.token,
                    opcion: 2,
                    user: widget.user,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel, color: Colors.black),
            title: const Text('Reglamento'),
            tileColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RulesScreen()),
              );
            },
          ),
          const Divider(color: Colors.black, height: 2),
          ListTile(
            leading: const Icon(Icons.face, color: Colors.black),
            tileColor: Colors.lightGreenAccent,
            title: const Text('Editar perfil'),
            onTap: () => _editUser(),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            tileColor: Colors.lightGreenAccent,
            title: const Text('Cerrar Sesión'),
            onTap: () {
              _logOut();
            },
          ),
        ],
      ),
    );
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _getUser() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estés conectado a Internet',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    var url = Uri.parse('${Constants.apiUrl}/Api/Account/GetUserByEmail');

    Map<String, dynamic> request2 = {'Email': widget.user.email};

    var response2 = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${widget.token.token}',
      },
      body: jsonEncode(request2),
    );

    setState(() {
      _showLoader = false;
    });

    var body2 = response2.body;
    if (widget.rememberme) {
      _storeUser(body2);
    }
    var decodedJson2 = jsonDecode(body2);
    _user = User.fromJson(decodedJson2);
    setState(() {});
  }

  _editUser() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterUserScreen(
          token: widget.token,
          user: _user,
          myProfile: true,
        ),
      ),
    );
    if (result == 'yes') {
      _getUser();
      setState(() {});
    }
  }

  void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
  }
}
