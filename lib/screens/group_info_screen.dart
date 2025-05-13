import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/loader_component.dart';
import '../helpers/api_helper.dart';
import '../models/models.dart';

class GroupInfoScreen extends StatefulWidget {
  final Token token;
  final Groups group;

  const GroupInfoScreen({super.key, required this.token, required this.group});

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
  final List<Matches> _pendingMatches = [];
  final List<Matches> _completeMatches = [];
  List<Matches> _pendingMatchesFiltered = [];
  List<Matches> _completeMatchesFiltered = [];
  List<GroupDetails> _groupDetails = [];

  String _filter = '';
  final String _filterError = '';
  final bool _filterShowError = false;
  final TextEditingController _filterController = TextEditingController();

  String _filter2 = '';
  final String _filter2Error = '';
  final bool _filter2ShowError = false;
  final TextEditingController _filter2Controller = TextEditingController();

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

    _pendingMatches.sort((b, a) {
      return a.dateLocal
          .toString()
          .toLowerCase()
          .compareTo(b.dateLocal.toString().toLowerCase());
    });

    _completeMatchesFiltered = _completeMatches;
    _pendingMatchesFiltered = _pendingMatches;
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
            decoration: const BoxDecoration(
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
              physics: const AlwaysScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              children: <Widget>[
//-------------------------------------------------------------------------
//-------------------------- 1° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Container(
                  color: const Color(0xFF00D99D),
                  child: Center(
                    child: _showLoader
                        ? const LoaderComponent(text: 'Por favor espere...')
                        : _getContent(),
                  ),
                ),
//-------------------------------------------------------------------------
//-------------------------- 2° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Container(
                  color: const Color(0xFF00D99D),
                  child: Center(
                    child: _showLoader
                        ? const LoaderComponent(text: 'Por favor espere...')
                        : _getPendingMatches(),
                  ),
                ),
//-------------------------------------------------------------------------
//-------------------------- 3° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Container(
                  color: const Color(0xFF00D99D),
                  child: Center(
                    child: _showLoader
                        ? const LoaderComponent(text: 'Por favor espere...')
                        : _getCompleteMatches(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(166, 5, 68, 7),
        child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.greenAccent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelPadding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
            tabs: <Widget>[
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.star),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Posiciones',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.pending_actions),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Pendientes',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.done_all),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Finalizados.',
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
          backgroundColor: const Color.fromARGB(166, 5, 68, 7),
        ),
        _showFilaTitulo(),
        Expanded(
          child: _groupDetails.isEmpty ? _noContent() : _getListView(),
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
          title: const Text('Finalizados'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(166, 5, 68, 7),
        ),
        Row(
          children: [
            Expanded(flex: 3, child: _showFilter()),
            Expanded(flex: 1, child: _showEraseButton()),
            Expanded(flex: 1, child: _showSearchButton()),
          ],
        ),
        Expanded(
          child: _completeMatchesFiltered.isEmpty
              ? _noContentCompleteMatches()
              : _getListViewCompleteMatches(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------
//-------------------------- getPendingMatches --------------------------
//-----------------------------------------------------------------------
  Widget _getPendingMatches() {
    return Column(
      children: <Widget>[
        AppBar(
          title: const Text('Pendientes'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(166, 5, 68, 7),
        ),
        Row(
          children: [
            Expanded(flex: 3, child: _showFilter2()),
            Expanded(flex: 1, child: _showEraseButton2()),
            Expanded(flex: 1, child: _showSearchButton2()),
          ],
        ),
        Expanded(
          child: _pendingMatchesFiltered.isEmpty
              ? _noContentPendingMatches()
              : _getListViewPendingMatches(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------
//-------------------------- noContent ----------------------------------
//-----------------------------------------------------------------------
  Widget _noContent() {
    return Container(
      color: const Color(0xFF00D99D),
      margin: const EdgeInsets.all(20),
      child: const Center(
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
      color: const Color(0xFF00D99D),
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay partidos finalizados.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- noContentPendingMatches -------------------
//-----------------------------------------------------------------------
  Widget _noContentPendingMatches() {
    return Container(
      color: const Color(0xFF00D99D),
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay partidos pendientes.',
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
      padding: const EdgeInsets.all(0),
      children: _groupDetails.map((e) {
        return Container(
          color: const Color(0xFF00D99D),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
              color: const Color(0xFFFFFFCC),
              margin: const EdgeInsets.all(1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  padding: const EdgeInsets.all(0),
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
                                    const Icon(Icons.error),
                                fit: BoxFit.contain,
                                height: 35,
                                width: 35,
                                placeholder: (context, url) => const Image(
                                  image: AssetImage('assets/loading.gif'),
                                  fit: BoxFit.cover,
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.team.initials,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //----- Puntos -----
                              SizedBox(
                                width: 30,
                                child: Text(
                                  e.points.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- PJ -----
                              SizedBox(
                                width: 30,
                                child: Text(
                                  e.matchesPlayed.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- PG -----
                              SizedBox(
                                width: 30,
                                child: Text(
                                  e.matchesWon.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- PE -----
                              SizedBox(
                                width: 30,
                                child: Text(
                                  e.matchesTied.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- PP -----
                              SizedBox(
                                width: 30,
                                child: Text(
                                  e.matchesLost.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- GF -----
                              SizedBox(
                                width: 30,
                                child: Text(
                                  e.goalsFor.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- GC -----
                              SizedBox(
                                width: 30,
                                child: Text(
                                  e.goalsAgainst.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              //----- DG -----
                              SizedBox(
                                width: 30,
                                child: Text(
                                  e.goalDifference.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
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
      padding: const EdgeInsets.all(0),
      children: _completeMatchesFiltered.map((e) {
        return Container(
          color: const Color(0xFF00D99D),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
              color: const Color(0xFFFFFFCC),
              margin: const EdgeInsets.all(1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  padding: const EdgeInsets.all(0),
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
                                  const Icon(Icons.error),
                              fit: BoxFit.contain,
                              height: 80,
                              width: 80,
                              placeholder: (context, url) => const Image(
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            Text(e.local.initials,
                                style: const TextStyle(
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
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text("${e.goalsLocal}-${e.goalsVisitor}",
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(e.dateLocal)),
                            style: const TextStyle(
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
                                  const Icon(Icons.error),
                              fit: BoxFit.contain,
                              height: 80,
                              width: 80,
                              placeholder: (context, url) => const Image(
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            Text(e.visitor.initials,
                                style: const TextStyle(
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
//-------------------------- _getListViewPendingMatches ----------------
//-----------------------------------------------------------------------
  _getListViewPendingMatches() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: _pendingMatchesFiltered.map((e) {
        return Container(
          color: const Color(0xFF00D99D),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
              color: const Color(0xFFFFFFCC),
              margin: const EdgeInsets.all(1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  padding: const EdgeInsets.all(0),
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
                                  const Icon(Icons.error),
                              fit: BoxFit.contain,
                              height: 80,
                              width: 80,
                              placeholder: (context, url) => const Image(
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            Text(e.local.initials,
                                style: const TextStyle(
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
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(e.dateLocal)),
                            style: const TextStyle(
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
                                  const Icon(Icons.error),
                              fit: BoxFit.contain,
                              height: 80,
                              width: 80,
                              placeholder: (context, url) => const Image(
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            Text(e.visitor.initials,
                                style: const TextStyle(
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
          color: const Color.fromARGB(255, 240, 229, 105),
          margin: const EdgeInsets.all(1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
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
                          SizedBox(
                            width: 30,
                            child: const Text(
                              'Pts',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- PJ -----
                          SizedBox(
                            width: 30,
                            child: const Text(
                              'PJ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- PG -----
                          SizedBox(
                            width: 30,
                            child: const Text(
                              'PG',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- PE -----
                          SizedBox(
                            width: 30,
                            child: const Text(
                              'PE',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- PP -----
                          SizedBox(
                            width: 30,
                            child: const Text(
                              'PP',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- GF -----
                          SizedBox(
                            width: 30,
                            child: const Text(
                              'GF',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- GC -----
                          SizedBox(
                            width: 30,
                            child: const Text(
                              'GC',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //----- DG -----
                          SizedBox(
                            width: 30,
                            child: const Text(
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
  Future<void> _getGroupDetails() async {
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
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
  Future<void> _getMatches() async {
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    _matches = response.result;

    for (var match in _matches) {
      if (match.isClosed) {
        _completeMatches.add(match);
      } else {
        _pendingMatches.add(match);
      }
    }

    _completeMatchesFiltered = _completeMatches;
    _pendingMatchesFiltered = _pendingMatches;

    setState(() {});
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWFILTER -------------------------
//-----------------------------------------------------------------

  Widget _showFilter() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _filterController,
        decoration: InputDecoration(
          iconColor: const Color(0xFF781f1e),
          prefixIconColor: const Color(0xFF781f1e),
          hoverColor: const Color(0xFF781f1e),
          focusColor: const Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Buscar...',
          labelText: 'Buscar:',
          errorText: _filterShowError ? _filterError : null,
          prefixIcon: const Icon(Icons.badge),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF781f1e)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _filter = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWFILTER2 -------------------------
//-----------------------------------------------------------------

  Widget _showFilter2() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _filter2Controller,
        decoration: InputDecoration(
          iconColor: const Color(0xFF781f1e),
          prefixIconColor: const Color(0xFF781f1e),
          hoverColor: const Color(0xFF781f1e),
          focusColor: const Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Buscar...',
          labelText: 'Buscar:',
          errorText: _filter2ShowError ? _filter2Error : null,
          prefixIcon: const Icon(Icons.badge),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF781f1e)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _filter2 = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWERASEBUTTON -------------------------
//-----------------------------------------------------------------

  Widget _showEraseButton() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _filterController.text = '';
                _completeMatchesFiltered = _completeMatches;
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWERASEBUTTON -------------------------
//-----------------------------------------------------------------

  Widget _showEraseButton2() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _filter2Controller.text = '';
                _pendingMatchesFiltered = _pendingMatches;
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWSEARCHBUTTON -------------------
//-----------------------------------------------------------------

  Widget _showSearchButton() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(166, 5, 68, 7),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _search(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWSEARCHBUTTON2 -------------------
//-----------------------------------------------------------------

  Widget _showSearchButton2() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(166, 5, 68, 7),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _search2(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SEARCH -----------------------------
//-----------------------------------------------------------------

  _search() async {
    FocusScope.of(context).unfocus();
    if (_filter.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ingrese un texto a buscar',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    _completeMatchesFiltered = [];
    for (var _completeMatch in _completeMatches) {
      if (_completeMatch.local.initials
              .toLowerCase()
              .contains(_filter.toLowerCase()) ||
          _completeMatch.visitor.initials
              .toLowerCase()
              .contains(_filter.toLowerCase()) ||
          _completeMatch.dateName!
              .toLowerCase()
              .contains(_filter.toLowerCase())) {
        _completeMatchesFiltered.add(_completeMatch);
      }
    }
    _completeMatchesFiltered.sort((b, a) {
      return a.dateLocal
          .toString()
          .toLowerCase()
          .compareTo(b.dateLocal.toString().toLowerCase());
    });
    setState(() {});
  }

//-----------------------------------------------------------------
//--------------------- METODO SEARCH2 ----------------------------
//-----------------------------------------------------------------

  _search2() async {
    FocusScope.of(context).unfocus();
    if (_filter2.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ingrese un texto a buscar',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    _pendingMatchesFiltered = [];
    for (var _pendingMatch in _pendingMatches) {
      if (_pendingMatch.local.initials
              .toLowerCase()
              .contains(_filter2.toLowerCase()) ||
          _pendingMatch.visitor.initials
              .toLowerCase()
              .contains(_filter2.toLowerCase()) ||
          _pendingMatch.dateName!
              .toLowerCase()
              .contains(_filter2.toLowerCase())) {
        _pendingMatchesFiltered.add(_pendingMatch);
      }
    }
    _pendingMatchesFiltered.sort((b, a) {
      return a.dateLocal
          .toString()
          .toLowerCase()
          .compareTo(b.dateLocal.toString().toLowerCase());
    });
    setState(() {});
  }
}
