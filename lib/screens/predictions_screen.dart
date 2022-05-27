import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soccer_app/components/loader_component.dart';
import 'package:soccer_app/helpers/api_helper.dart';
import 'package:soccer_app/models/models.dart';
import 'package:flutter/gestures.dart';

class PredictionsScreen extends StatefulWidget {
  final Token token;
  final User user;
  final Tournament tournament;

  PredictionsScreen(
      {required this.token, required this.user, required this.tournament});

  @override
  State<PredictionsScreen> createState() => _PredictionsScreenState();
}

class _PredictionsScreenState extends State<PredictionsScreen>
    with SingleTickerProviderStateMixin {
//***********************************************************************
//******************** Declaración de Variables *************************
//***********************************************************************
  bool _showLoader = false;
  TabController? _tabController;
  List<Matches> _predictions = [];
  List<Matches> _pendingPredictions = [];
  List<Matches> _completePredictions = [];
  List<Matches> _pendingPredictionsFiltered = [];
  List<Matches> _completePredictionsFiltered = [];

  String _filter = '';
  String _filterError = '';
  bool _filterShowError = false;
  TextEditingController _filterController = TextEditingController();

  String _filter2 = '';
  String _filter2Error = '';
  bool _filter2ShowError = false;
  TextEditingController _filter2Controller = TextEditingController();

//***********************************************************************
//******************** Init State ***************************************
//***********************************************************************
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _completePredictions.sort((b, a) {
      return a.dateLocal
          .toString()
          .toLowerCase()
          .compareTo(b.dateLocal.toString().toLowerCase());
    });

    _pendingPredictions.sort((b, a) {
      return a.dateLocal
          .toString()
          .toLowerCase()
          .compareTo(b.dateLocal.toString().toLowerCase());
    });

    _completePredictionsFiltered = _completePredictions;
    _pendingPredictionsFiltered = _pendingPredictions;
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
                      : _getPendingPredictions(),
                ),
//-------------------------------------------------------------------------
//-------------------------- 2° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Center(
                  child: _showLoader
                      ? LoaderComponent(text: 'Por favor espere...')
                      : _getCompletePredictions(),
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
                      "Finalizadas.",
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
//-------------------------- getCompletePredictions ---------------------
//-----------------------------------------------------------------------
  Widget _getCompletePredictions() {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Predicciones Finalizadas"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(166, 5, 68, 7),
        ),
        Row(
          children: [
            Expanded(flex: 3, child: _showFilter()),
            Expanded(flex: 1, child: _showEraseButton()),
            Expanded(flex: 1, child: _showSearchButton()),
          ],
        ),
        Expanded(
          child: _completePredictionsFiltered.length == 0
              ? _noContentCompletePredictions()
              : _getListViewCompletePredictions(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------
//-------------------------- getPendingPredictions ----------------------
//-----------------------------------------------------------------------
  Widget _getPendingPredictions() {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Predicciones Pendientes"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(166, 5, 68, 7),
        ),
        Row(
          children: [
            Expanded(flex: 3, child: _showFilter2()),
            Expanded(flex: 1, child: _showEraseButton2()),
            Expanded(flex: 1, child: _showSearchButton2()),
          ],
        ),
        Expanded(
          child: _pendingPredictionsFiltered.length == 0
              ? _noContentPendingPredictions()
              : _getListViewPendingPredictions(),
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
          'No hay predicciones en este Torneo.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- noContentCompletePredictions ---------------
//-----------------------------------------------------------------------
  Widget _noContentCompletePredictions() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'No hay predicciones finalizadas.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- noContentPendingPredictions ----------------
//-----------------------------------------------------------------------
  Widget _noContentPendingPredictions() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'No hay predicciones pendientes.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- _getListViewCompletePredictions ------------
//-----------------------------------------------------------------------
  _getListViewCompletePredictions() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: _completePredictionsFiltered.map((e) {
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
//-------------------------- _getListViewPendingPredictions -------------
//-----------------------------------------------------------------------
  _getListViewPendingPredictions() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: _pendingPredictionsFiltered.map((e) {
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

    Response response =
        await ApiHelper.getPredictions(widget.tournament.id, widget.user.id);

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

    _predictions = response.result;

    _predictions.forEach((match) {
      if (match.isClosed) {
        _completePredictions.add(match);
      } else {
        _pendingPredictions.add(match);
      }
      ;
    });

    var a = 1;
    _completePredictionsFiltered = _completePredictions;
    _pendingPredictionsFiltered = _pendingPredictions;

    setState(() {});
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWFILTER -------------------------
//-----------------------------------------------------------------

  Widget _showFilter() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _filterController,
        decoration: InputDecoration(
          iconColor: Color(0xFF781f1e),
          prefixIconColor: Color(0xFF781f1e),
          hoverColor: Color(0xFF781f1e),
          focusColor: Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Buscar...',
          labelText: 'Buscar:',
          errorText: _filterShowError ? _filterError : null,
          prefixIcon: Icon(Icons.badge),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF781f1e)),
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
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _filter2Controller,
        decoration: InputDecoration(
          iconColor: Color(0xFF781f1e),
          prefixIconColor: Color(0xFF781f1e),
          hoverColor: Color(0xFF781f1e),
          focusColor: Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Buscar...',
          labelText: 'Buscar:',
          errorText: _filter2ShowError ? _filter2Error : null,
          prefixIcon: Icon(Icons.badge),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF781f1e)),
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
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _filterController.text = '';
                _completePredictionsFiltered = _completePredictions;
                setState(() {});
              },
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
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _filter2Controller.text = '';
                _pendingPredictionsFiltered = _pendingPredictions;
                setState(() {});
              },
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
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(166, 5, 68, 7),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _search(),
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
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(166, 5, 68, 7),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _search2(),
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    _completePredictionsFiltered = [];
    _completePredictions.forEach((_completeMatch) {
      if (_completeMatch.local.initials
              .toLowerCase()
              .contains(_filter.toLowerCase()) ||
          _completeMatch.visitor.initials
              .toLowerCase()
              .contains(_filter.toLowerCase()) ||
          _completeMatch.dateName!
              .toLowerCase()
              .contains(_filter.toLowerCase())) {
        _completePredictionsFiltered.add(_completeMatch);
      }
    });
    _completePredictionsFiltered.sort((b, a) {
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    _pendingPredictionsFiltered = [];
    _pendingPredictions.forEach((_pendingMatch) {
      if (_pendingMatch.local.initials
              .toLowerCase()
              .contains(_filter2.toLowerCase()) ||
          _pendingMatch.visitor.initials
              .toLowerCase()
              .contains(_filter2.toLowerCase()) ||
          _pendingMatch.dateName!
              .toLowerCase()
              .contains(_filter2.toLowerCase())) {
        _pendingPredictionsFiltered.add(_pendingMatch);
      }
    });
    _pendingPredictionsFiltered.sort((b, a) {
      return a.dateLocal
          .toString()
          .toLowerCase()
          .compareTo(b.dateLocal.toString().toLowerCase());
    });
    setState(() {});
  }
}
