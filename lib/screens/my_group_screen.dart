import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:soccer_app/components/loader_component.dart';
import 'package:soccer_app/helpers/api_helper.dart';
import 'package:soccer_app/models/models.dart';

class MyGroupScreen extends StatefulWidget {
  final Token token;
  final User user;
  final GroupBet group;

  const MyGroupScreen(
      {required this.token, required this.user, required this.group});

  @override
  State<MyGroupScreen> createState() => _MyGroupScreenState();
}

class _MyGroupScreenState extends State<MyGroupScreen> {
//***********************************************************************
//******************** Declaración de Variables *************************
//***********************************************************************

  bool _showLoader = false;
  List<GroupPosition>? _groupBetPlayers = [];

//***********************************************************************
//******************** Init State ***************************************
//***********************************************************************
  @override
  void initState() {
    super.initState();
    _getGroupPositions();
  }

//***********************************************************************
//******************** Pantalla *****************************************
//***********************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Grupo ' + widget.group.name),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 8, 69, 48),
        ),
        body: Container(
          color: Color(0xFF00D99D),
          child: Column(
            children: [
              _showInfoGroup(),
              Divider(
                color: Colors.black,
                height: 2,
              ),
              SizedBox(
                height: 10,
              ),
              _showButtons(),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black,
                height: 2,
              ),
              Expanded(
                child: Container(
                  child: _showLoader
                      ? LoaderComponent(text: 'Por favor espere...')
                      : _getContent(),
                ),
              ),
            ],
          ),
        ));
  }

//-----------------------------------------------------------------------
//-------------------------- getContent ---------------------------------
//-----------------------------------------------------------------------
  Widget _getContent() {
    return _groupBetPlayers!.length == 0 ? _noContent() : _getListView();
  }

//-----------------------------------------------------------------------
//-------------------------- noContent ----------------------------------
//-----------------------------------------------------------------------
  Widget _noContent() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'No hay jugadores en este grupo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- getListView --------------------------------
//-----------------------------------------------------------------------
  _getListView() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: _groupBetPlayers!.map((e) {
        return Card(
            color: Color(0xFFFFFFCC),
            shadowColor: Color(0xFF0000FF),
            elevation: 10,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: e.ranking == 1
                                  ? Colors.amber
                                  : e.ranking == 2
                                      ? Color.fromARGB(255, 141, 145, 149)
                                      : e.ranking == 3
                                          ? Color.fromARGB(255, 156, 66, 59)
                                          : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black)),
                          child: Text(e.ranking.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        e.ranking == 1
                            ? Text("Oro")
                            : e.ranking == 2
                                ? Text("Plata")
                                : e.ranking == 3
                                    ? Text("Bronce")
                                    : Text(""),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: CachedNetworkImage(
                              imageUrl: e.playerResponse!.pictureFullPath,
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
                                imageUrl: e.playerResponse!.team!.logoFullPath,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.contain,
                                height: 30,
                                width: 30,
                                placeholder: (context, url) => Image(
                                  image: AssetImage('assets/loading.gif'),
                                  fit: BoxFit.contain,
                                  height: 30,
                                  width: 30,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              e.playerResponse!.fullName,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "(a) " + e.playerResponse!.nickName,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        e.points.toString(),
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 40,
                    )
                  ],
                ),
              ),
            ));
      }).toList(),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ showInfoGroup --------------------------------
//-----------------------------------------------------------------------------
  Widget _showInfoGroup() {
    return Container(
      width: double.infinity,
      height: 100,
      color: Color(0xFF00D99D),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 50,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: CachedNetworkImage(
                  imageUrl: widget.group.logoFullPath,
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
          ),
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
              right: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Administrador",
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

//**************************************************************************
//************************* _showButtons ***********************************
//**************************************************************************

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contact_mail),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Invitar'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 8, 69, 48),
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _invitar(),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Borrar'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _borrar(),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Salir'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _salir(),
            ),
          ),
        ],
      ),
    );
  }

  void _invitar() {}

  void _salir() {}

  void _borrar() {}

//***********************************************************************
//******************** Método goInfoTournament **************************
//***********************************************************************
  void _goInfoGroupPlayer(GroupPosition groupBetPlayer) async {}

//***********************************************************************
//******************** Método getGroupPositions *************************
//***********************************************************************
  Future<Null> _getGroupPositions() async {
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

    Response response = await ApiHelper.getPositionsByTournament(
        widget.group.tournamentId, widget.group.id, widget.token);

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

    _groupBetPlayers = response.result;
    // _groupBetPlayers.sort((b, a) {
    //   int pointsComp = a.points.compareTo(b.points);
    //   if (pointsComp != 0) return pointsComp;
    //   int goalDifferenceComp = a.goalDifference.compareTo(b.goalDifference);
    //   if (goalDifferenceComp != 0) return goalDifferenceComp;
    //   int goalsForComp = a.goalsFor.compareTo(b.goalsFor);
    //   if (goalsForComp != 0) return goalsForComp;
    //   int goalsName = b.team.initials.compareTo(a.team.initials);
    //   return goalsName;
    // }
    // );

    setState(() {});
  }
}
