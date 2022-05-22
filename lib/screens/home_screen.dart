import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_app/models/token.dart';
import 'package:soccer_app/models/user.dart';
import 'package:soccer_app/screens/login_screen.dart';
import 'package:soccer_app/screens/tournaments_screen.dart';

class HomeScreen extends StatefulWidget {
  final Token token;
  final User user;

  HomeScreen({required this.token, required this.user});

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
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00D99D),
      appBar: AppBar(
        title: Text('Soccer'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(166, 5, 68, 7),
      ),
      body: _getBody(),
      drawer: _getMenu(),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/logo.png'),
              width: 200,
            ),
            SizedBox(
              height: 40,
            ),
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: _user.pictureFullPath,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 200,
                      width: 200,
                      placeholder: (context, url) => Image(
                        image: AssetImage('assets/loading.gif'),
                        fit: BoxFit.cover,
                        height: 200,
                        width: 200,
                      ),
                    )),
                Positioned(
                  bottom: 00,
                  left: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: _user.team.logoFullPath,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                        placeholder: (context, url) => Image(
                          image: AssetImage('assets/loading.gif'),
                          fit: BoxFit.cover,
                          height: 200,
                          width: 200,
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Bienvenido/a ${_user.fullName}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMenu() {
    return Drawer(
      backgroundColor: Color.fromARGB(166, 5, 68, 7),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Stack(
            children: [
              Image(image: AssetImage('assets/logo.png')),
              Positioned(
                bottom: 0,
                left: 130,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: _user.pictureFullPath,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 80,
                      width: 80,
                      placeholder: (context, url) => Image(
                        image: AssetImage('assets/loading.gif'),
                        fit: BoxFit.cover,
                        height: 200,
                        width: 200,
                      ),
                    )),
              ),
              Positioned(
                bottom: 00,
                left: 190,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: _user.team.logoFullPath,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                      placeholder: (context, url) => Image(
                        image: AssetImage('assets/loading.gif'),
                        fit: BoxFit.cover,
                        height: 200,
                        width: 200,
                      ),
                    )),
              )
            ],
          )),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('Torneos'),
            tileColor: Colors.lightGreenAccent,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TournamentsScreen(
                            token: widget.token,
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.groups),
            title: Text('Grupos'),
            tileColor: Colors.lightGreenAccent,
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.sports_soccer),
            title: Text('Predicciones'),
            tileColor: Colors.lightGreenAccent,
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.gavel),
            title: Text('Reglamento'),
            tileColor: Colors.lightGreenAccent,
            onTap: () {},
          ),
          Divider(
            color: Colors.black,
            height: 2,
          ),
          ListTile(
            leading: Icon(Icons.face),
            tileColor: Colors.green,
            title: Text('Editar perfil'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            tileColor: Colors.green,
            title: Text('Cerrar Sesión'),
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
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<Null> _getUser() async {
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
  }
}
