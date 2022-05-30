import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soccer_app/components/loader_component.dart';
import 'package:soccer_app/helpers/api_helper.dart';
import 'package:soccer_app/models/models.dart';
import 'package:soccer_app/screens/add_bet_group_screen.dart';
import 'package:soccer_app/screens/screens.dart';

class MyGroupsScreen extends StatefulWidget {
  final Token token;
  final User user;

  MyGroupsScreen({required this.token, required this.user});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************
  bool _showLoader = false;
  List<GroupBet> _myGroups = [];

  GroupBet groupSelected = GroupBet(
      id: 0,
      name: '',
      logoPath: '',
      adminName: '',
      adminPicture: '',
      adminTeam: '',
      tournamentName: '',
      tournamentId: 0,
      creationDate: '',
      groupBetPlayers: [],
      cantPlayers: 0,
      logoFullPath: '');

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _getMyGroups();

    var a = 1;
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00D99D),
      appBar: AppBar(
        title: Text('Mis Grupos de Apuesta'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 69, 48),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        color: Color(0xFF00D99D),
        child: Center(
          child: _showLoader
              ? LoaderComponent(
                  text: 'Cargando Grupos...',
                )
              : _getContent(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 8, 69, 48),
          onPressed: () async {
            String? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBetGroupScreen(
                  token: widget.token,
                  user: widget.user,
                ),
              ),
            );
            if (result == 'yes') {
              _getMyGroups();
              setState(() {});
            }
          }),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETCONTENT --------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showInfoUser(),
        Expanded(
          child: _myGroups.length == 0 ? _noContent() : _getListView(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ showInfoUser ---------------------------------
//-----------------------------------------------------------------------------
  Widget _showInfoUser() {
    return Container(
      width: double.infinity,
      height: 100,
      color: Color(0xFF00D99D),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 50,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: CachedNetworkImage(
                  imageUrl: widget.user.pictureFullPath,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                  placeholder: (context, url) => Image(
                    image: AssetImage('assets/loading.gif'),
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ),
                )),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: CachedNetworkImage(
                  imageUrl: widget.user.team.logoFullPath,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.contain,
                  height: 50,
                  width: 50,
                  placeholder: (context, url) => Image(
                    image: AssetImage('assets/loading.gif'),
                    fit: BoxFit.contain,
                    height: 50,
                    width: 50,
                  ),
                )),
          ),
          Positioned(
              top: 10,
              left: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Grupos de Apuestas de ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  Text(widget.user.firstName + " " + widget.user.lastName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromARGB(255, 33, 33, 243),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(" (a) " + widget.user.nickName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              )),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO NOCONTENT -----------------------------
//-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'No tengo ni pertenezco a ningún Grupo de Apuestas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETLISTVIEW ---------------------------
//-----------------------------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _myGroups.map((e) {
        return Card(
          //color: Colors.white,
          color: Color.fromARGB(255, 198, 230, 164),
          shadowColor: Colors.white,
          elevation: 10,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: InkWell(
            onTap: () {
              groupSelected = e;
              _goInfoMyGroup(e);
            },
            child: Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: CachedNetworkImage(
                                  imageUrl: e.logoFullPath,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                  placeholder: (context, url) => Image(
                                    image: AssetImage('assets/loading.gif'),
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "Creado el " +
                                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.creationDate))}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                  Text("por " + e.adminName,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                  Text(
                                      "Cant. Jugadores: " +
                                          e.cantPlayers.toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                  Text(e.tournamentName,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12))
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: CachedNetworkImage(
                                      imageUrl: e.adminPicture,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: 80,
                                      placeholder: (context, url) => Image(
                                        image: AssetImage('assets/loading.gif'),
                                        fit: BoxFit.cover,
                                        height: 80,
                                        width: 80,
                                      ),
                                    )),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: CachedNetworkImage(
                                        imageUrl: e.adminTeam,
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        height: 30,
                                        width: 30,
                                        placeholder: (context, url) => Image(
                                          image:
                                              AssetImage('assets/loading.gif'),
                                          fit: BoxFit.cover,
                                          height: 30,
                                          width: 30,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

//*****************************************************************************
//************************** METODO GOINFMYGROUP ********************************
//*****************************************************************************

  void _goInfoMyGroup(GroupBet groupBet) async {
    //String? result =
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyGroupScreen(
                  token: widget.token,
                  user: widget.user,
                  group: groupBet,
                )));
    // if (result == 'Yes') {
    //   setState(() {});
    // }
  }

//***********************************************************************
//******************** Método getMyGroups *********************************
//***********************************************************************
  Future<Null> _getMyGroups() async {
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

    Response response = await ApiHelper.getMyGroups(widget.user.userId);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    _myGroups = response.result;

    _myGroups.sort((b, a) {
      return a.creationDate
          .toString()
          .toLowerCase()
          .compareTo(b.creationDate.toString().toLowerCase());
    });

    setState(() {});
  }
}
