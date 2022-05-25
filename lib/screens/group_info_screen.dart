import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soccer_app/components/loader_component.dart';
import 'package:soccer_app/helpers/api_helper.dart';
import 'package:soccer_app/models/group.dart';
import 'package:soccer_app/models/groupdetail.dart';
import 'package:soccer_app/models/models.dart';
import 'package:soccer_app/models/token.dart';

class GroupInfoScreen extends StatefulWidget {
  final Token token;
  final Groups group;

  GroupInfoScreen({required this.token, required this.group});

  @override
  _GroupInfoScreenState createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen>
    with SingleTickerProviderStateMixin {
//***********************************************************************
//******************** Declaración de Variables *************************
//***********************************************************************
  bool _showLoader = false;
  TabController? _tabController;
  List<Matches> _matches = [];
  List<Matches> _pendingMatches = [];
  List<Matches> _completeMatches = [];
  List<GroupDetails> _groupDetails = [];

//***********************************************************************
//******************** Init State ***************************************
//***********************************************************************
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getGroupDetails();

    _completeMatches.sort((b, a) {
      return a.dateLocal
          .toString()
          .toLowerCase()
          .compareTo(b.dateLocal.toString().toLowerCase());
    });

    var a = 1;
  }

//***********************************************************************
//******************** Pantalla *****************************************
//***********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(
                    (0xffdadada),
                  ),
                  Color(
                    (0xffb3b3b4),
                  ),
                ],
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              physics: AlwaysScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              children: <Widget>[
//-------------------------------------------------------------------------
//-------------------------- 1° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Center(
                  child: _showLoader
                      ? LoaderComponent(text: 'Por favor espere...')
                      : _getContent(),
                ),
//-------------------------------------------------------------------------
//-------------------------- 2° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Container(
                  color: Colors.yellow,
                ),
//-------------------------------------------------------------------------
//-------------------------- 3° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Center(
                  child: _showLoader
                      ? LoaderComponent(text: 'Por favor espere...')
                      : _getCompleteMatches(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(166, 5, 68, 7),
        child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.greenAccent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
            tabs: <Widget>[
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.star),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Posiciones",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.pending_actions),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Pendientes",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.done_all),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Finalizados.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- getContent ---------------------------------
//-----------------------------------------------------------------------
  Widget _getContent() {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text(widget.group.name),
          centerTitle: true,
          backgroundColor: Color.fromARGB(166, 5, 68, 7),
        ),
        _showFilaTitulo(),
        Expanded(
          child: _groupDetails.length == 0 ? _noContent() : _getListView(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------
//-------------------------- getCompleteMatches -------------------------
//-----------------------------------------------------------------------
  Widget _getCompleteMatches() {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Finalizados"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(166, 5, 68, 7),
        ),
        //_showFilaTitulo(),
        Expanded(
          child: _completeMatches.length == 0
              ? _noContentCompleteMatches()
              : _getListViewCompleteMatches(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------
//-------------------------- noContent ----------------------------------
//-----------------------------------------------------------------------
  Widget _noContent() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'No hay equipos en este Grupo.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- noContentCompleteMatches -------------------
//-----------------------------------------------------------------------
  Widget _noContentCompleteMatches() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'No hay partidos finalizados.',
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
      children: _groupDetails.map((e) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
              color: Color(0xFFFFFFCC),
              margin: EdgeInsets.all(1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  margin: EdgeInsets.all(1),
                  padding: EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                imageUrl: e.team.logoFullPath,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.contain,
                                height: 35,
                                width: 35,
                                placeholder: (context, url) => Image(
                                  image: AssetImage('assets/loading.gif'),
                                  fit: BoxFit.cover,
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                              Container(
                                width: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.team.initials,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //----- Puntos -----
                              Container(
                                width: 30,
                                child: Text(
                                  e.points.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- PJ -----
                              Container(
                                width: 30,
                                child: Text(
                                  e.matchesPlayed.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- PG -----
                              Container(
                                width: 30,
                                child: Text(
                                  e.matchesWon.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- PE -----
                              Container(
                                width: 30,
                                child: Text(
                                  e.matchesTied.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- PP -----
                              Container(
                                width: 30,
                                child: Text(
                                  e.matchesLost.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- GF -----
                              Container(
                                width: 30,
                                child: Text(
                                  e.goalsFor.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- GC -----
                              Container(
                                width: 30,
                                child: Text(
                                  e.goalsAgainst.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- DG -----
                              Container(
                                width: 30,
                                child: Text(
                                  e.goalDifference.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              )),
        );
      }).toList(),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- _getListViewCompleteMatches ----------------
//-----------------------------------------------------------------------
  _getListViewCompleteMatches() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: _completeMatches.map((e) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
              color: Color(0xFFFFFFCC),
              margin: EdgeInsets.all(1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  margin: EdgeInsets.all(1),
                  padding: EdgeInsets.all(0),
                  //----------- Fila Principal -----------
                  child: Row(
                    children: <Widget>[
                      //----------- Columna Local -----------
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: e.local.logoFullPath,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.contain,
                              height: 80,
                              width: 80,
                              placeholder: (context, url) => Image(
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            Text(e.local.initials,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),

                      //----------- Columna Resultado -----------

                      Column(
                        children: [
                          Text(
                            e.dateName.toString(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              e.goalsLocal.toString() +
                                  "-" +
                                  e.goalsVisitor.toString(),
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                            '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.dateLocal))}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      //----------- Columna Visitante -----------
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: e.visitor.logoFullPath,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.contain,
                              height: 80,
                              width: 80,
                              placeholder: (context, url) => Image(
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            Text(e.visitor.initials,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      }).toList(),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- _showFilaTitulo ----------------------------
//-----------------------------------------------------------------------
  Widget _showFilaTitulo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
          color: Colors.greenAccent,
          margin: EdgeInsets.all(1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              margin: EdgeInsets.all(1),
              padding: EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Equipo',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //----- Puntos -----
                          Container(
                            width: 30,
                            child: Text(
                              'Pts',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- PJ -----
                          Container(
                            width: 30,
                            child: Text(
                              'PJ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- PG -----
                          Container(
                            width: 30,
                            child: Text(
                              'PG',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- PE -----
                          Container(
                            width: 30,
                            child: Text(
                              'PE',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- PP -----
                          Container(
                            width: 30,
                            child: Text(
                              'PP',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- GF -----
                          Container(
                            width: 30,
                            child: Text(
                              'GF',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- GC -----
                          Container(
                            width: 30,
                            child: Text(
                              'GC',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- DG -----
                          Container(
                            width: 30,
                            child: Text(
                              'DG',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ],
              ),
            ),
          )),
    );
  }

//***********************************************************************
//******************** Método getGroupDetails ***************************
//***********************************************************************
  Future<Null> _getGroupDetails() async {
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

    Response response = await ApiHelper.getGroupDetails(widget.group.id);

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

    _groupDetails = response.result;
    _groupDetails.sort((b, a) {
      int pointsComp = a.points.compareTo(b.points);
      if (pointsComp != 0) return pointsComp;
      int goalDifferenceComp = a.goalDifference.compareTo(b.goalDifference);
      if (goalDifferenceComp != 0) return goalDifferenceComp;
      int goalsForComp = a.goalsFor.compareTo(b.goalsFor);
      if (goalsForComp != 0) return goalsForComp;
      int goalsName = b.team.initials.compareTo(a.team.initials);
      return goalsName;
    });

    setState(() {});

    _getMatches();
  }

//***********************************************************************
//******************** Método getMatches ********************************
//***********************************************************************
  Future<Null> _getMatches() async {
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

    Response response = await ApiHelper.getMatches(widget.group.id);

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

    _matches = response.result;

    _matches.forEach((match) {
      if (match.isClosed) {
        _completeMatches.add(match);
      } else {
        _pendingMatches.add(match);
      }
      ;
    });

    setState(() {});
  }
}
