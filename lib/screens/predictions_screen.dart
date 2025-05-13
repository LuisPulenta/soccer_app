import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/loader_component.dart';
import '../helpers/api_helper.dart';
import '../models/models.dart';

class PredictionsScreen extends StatefulWidget {
  final Token token;
  final User user;
  final Tournament tournament;

  const PredictionsScreen(
      {super.key,
      required this.token,
      required this.user,
      required this.tournament});

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
  List<Prediction> _predictions = [];
  final List<Prediction> _pendingPredictions = [];
  final List<Prediction> _completePredictions = [];
  List<Prediction> _pendingPredictionsFiltered = [];
  List<Prediction> _completePredictionsFiltered = [];

  String _filter = '';
  final String _filterError = '';
  final bool _filterShowError = false;
  final TextEditingController _filterController = TextEditingController();

  String _filter2 = '';
  final String _filter2Error = '';
  final bool _filter2ShowError = false;
  final TextEditingController _filter2Controller = TextEditingController();

  String _localGoals = '';
  final String _localGoalsError = '';
  bool _localGoalsShowError = false;
  final TextEditingController _localGoalsController = TextEditingController();

  String _visitorGoals = '';
  final String _visitorGoalsError = '';
  bool _visitorGoalsShowError = false;
  final TextEditingController _visitorGoalsController = TextEditingController();

//***********************************************************************
//******************** Init State ***************************************
//***********************************************************************
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getPredictions();
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
                        : _getPendingPredictions(),
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
                        : _getCompletePredictions(),
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
                      'Finalizadas.',
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
          title: const Text('Predicciones Finalizadas'),
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
        _completePredictionsFiltered.isEmpty
            ? Container()
            : _showCompleteResumen(),
        Expanded(
          child: _completePredictionsFiltered.isEmpty
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
          title: const Text('Predicciones Pendientes'),
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
        _pendingPredictionsFiltered.isEmpty
            ? Container()
            : _showPendingResumen(),
        Expanded(
          child: _pendingPredictionsFiltered.isEmpty
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
      margin: const EdgeInsets.all(20),
      child: const Center(
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
      margin: const EdgeInsets.all(20),
      child: const Center(
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
      margin: const EdgeInsets.all(20),
      child: const Center(
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
      padding: const EdgeInsets.all(0),
      children: _completePredictionsFiltered.map((e) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
              color: const Color(0xFFFFFFCC),
              margin: const EdgeInsets.all(2),
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
                            InkWell(
                              onTap: () {
                                _filter = e.match!.local.initials;
                                _search();
                              },
                              child: CachedNetworkImage(
                                imageUrl: e.match!.local.logoFullPath,
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
                            ),
                            Text(e.match!.local.initials,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                            const Divider(
                              color: Colors.black,
                            ),
                            const Text('Real',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '${e.match!.goalsLocal} - ${e.match!.goalsVisitor}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),

                      //----------- Columna Resultado -----------

                      Column(
                        children: [
                          Text(
                            e.match!.dateName.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(e.match!.dateLocal)),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.indigo,
                                  child: const Text(
                                    'Puntos',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  color: Colors.indigo,
                                  child: Text(
                                    e.points.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //----------- Columna Visitante -----------
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: e.match!.visitor.logoFullPath,
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
                            Text(e.match!.visitor.initials,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                            const Divider(
                              color: Colors.black,
                            ),
                            const Text('Predicción',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text('${e.goalsLocal} - ${e.goalsVisitor}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold))
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
      padding: const EdgeInsets.all(0),
      children: _pendingPredictionsFiltered.map((e) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
              color: (e.goalsLocal == null && e.goalsVisitor == null)
                  ? const Color(0xFFFFFFCC)
                  : const Color.fromARGB(255, 141, 235, 94),
              margin: const EdgeInsets.all(2),
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
                              imageUrl: e.match!.local.logoFullPath,
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
                            Text(e.match!.local.initials,
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
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black)),
                                child: e.goalsLocal != null
                                    ? Text(e.goalsLocal.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold))
                                    : const Text(''),
                              ),
                              const Text(' - ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black)),
                                child: e.goalsVisitor != null
                                    ? Text(e.goalsVisitor.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold))
                                    : const Text(''),
                              ),
                            ],
                          ),
                          Text(
                            '${e.match!.dateName.toString()} ',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(
                                DateTime.parse(e.match!.dateLocal)
                                    .add(const Duration(hours: -3))),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          _showButton(e),
                        ],
                      ),
                      //----------- Columna Visitante -----------
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: e.match!.visitor.logoFullPath,
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
                            Text(e.match!.visitor.initials,
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

//***********************************************************************
//******************** Método getPredictions ****************************
//***********************************************************************
  Future<void> _getPredictions() async {
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

    Response response = await ApiHelper.getPredictions(
        widget.tournament.id, widget.user.id, widget.token);

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

    _predictions = response.result;

    for (var prediction in _predictions) {
      if (prediction.match!.isClosed == true) {
        _completePredictions.add(prediction);
      } else {
        _pendingPredictions.add(prediction);
      }
    }

    _completePredictionsFiltered = _completePredictions;
    _pendingPredictionsFiltered = _pendingPredictions;

    _completePredictionsFiltered.sort((a, b) {
      int dateNameComp = a.match!.date.compareTo(b.match!.date);
      if (dateNameComp != 0) return dateNameComp;
      int initialsName =
          b.match!.local.initials.compareTo(a.match!.local.initials);
      return initialsName;
    });

    _pendingPredictionsFiltered.sort((a, b) {
      int dateNameComp = a.match!.date.compareTo(b.match!.date);
      if (dateNameComp != 0) return dateNameComp;
      int initialsName =
          b.match!.local.initials.compareTo(a.match!.local.initials);
      return initialsName;
    });

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
//--------------------- METODO SHOWERASEBUTTON --------------------
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
                _completePredictionsFiltered = _completePredictions;
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
                _pendingPredictionsFiltered = _pendingPredictions;
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
                backgroundColor: const Color.fromARGB(166, 5, 68, 7),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _search(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
                backgroundColor: const Color.fromARGB(166, 5, 68, 7),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _search2(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
    _completePredictionsFiltered = [];
    for (var _completeMatch in _completePredictions) {
      if (_completeMatch.match!.local.initials
              .toLowerCase()
              .contains(_filter.toLowerCase()) ||
          _completeMatch.match!.visitor.initials
              .toLowerCase()
              .contains(_filter.toLowerCase()) ||
          _completeMatch.match!.dateName!
              .toLowerCase()
              .contains(_filter.toLowerCase())) {
        _completePredictionsFiltered.add(_completeMatch);
      }
    }
    _completePredictionsFiltered.sort((b, a) {
      int dateNameComp = a.match!.dateName!.compareTo(b.match!.dateName!);
      if (dateNameComp != 0) return dateNameComp;
      int initialsName =
          b.match!.local.initials.compareTo(a.match!.local.initials);
      return initialsName;
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
    _pendingPredictionsFiltered = [];
    for (var _pendingMatch in _pendingPredictions) {
      if (_pendingMatch.match!.local.initials
              .toLowerCase()
              .contains(_filter2.toLowerCase()) ||
          _pendingMatch.match!.visitor.initials
              .toLowerCase()
              .contains(_filter2.toLowerCase()) ||
          _pendingMatch.match!.dateName!
              .toLowerCase()
              .contains(_filter2.toLowerCase())) {
        _pendingPredictionsFiltered.add(_pendingMatch);
      }
    }

    _pendingPredictionsFiltered.sort((b, a) {
      int dateNameComp = a.match!.dateName!.compareTo(b.match!.dateName!);
      if (dateNameComp != 0) return dateNameComp;
      int initialsName =
          b.match!.local.initials.compareTo(a.match!.local.initials);
      return initialsName;
    });
    setState(() {});
  }

//-----------------------------------------------------------------------
//-------------------------- _showCompleteResumen -----------------------
//-----------------------------------------------------------------------
  Widget _showCompleteResumen() {
    int puntos = 0;

    for (var prediction in _completePredictionsFiltered) {
      if (prediction.points != null) {
        puntos = puntos + prediction.points!;
      }
    }

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
                                  'Partidos:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (_completePredictionsFiltered.length)
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Puntos:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  puntos.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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

//-----------------------------------------------------------------------
//-------------------------- _showCompleteResumen -----------------------
//-----------------------------------------------------------------------
  Widget _showPendingResumen() {
    int pendientes = 0;

    for (var prediction in _pendingPredictionsFiltered) {
      if (prediction.goalsLocal == null && prediction.goalsVisitor == null) {
        pendientes = pendientes + 1;
      }
    }

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
                                  'Partidos:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (_pendingPredictionsFiltered.length)
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Pendientes:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  pendientes.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
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

//-----------------------------------------------------------------------
//-------------------------- showButton -------------------------------
//-----------------------------------------------------------------------
  Widget _showButton(Prediction e) {
    return Container(
      width: 160,
      height: 50,
      margin: const EdgeInsets.only(left: 0, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(166, 5, 68, 7),
                minimumSize: const Size(100, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _localGoalsController.text =
                    e.goalsLocal == null ? '' : e.goalsLocal.toString();

                _visitorGoalsController.text =
                    e.goalsVisitor == null ? '' : e.goalsVisitor.toString();

                _localGoalsShowError = false;
                _visitorGoalsShowError = false;

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[300],
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        actionsPadding: const EdgeInsets.all(0),
                        titlePadding: const EdgeInsets.only(top: 10, left: 10),
                        title: const Text('Ingrese los Goles'),
                        content: SizedBox(
                          height: 130,
                          child: Row(
                            children: [
                              //--------------- Escudo e Iniciales Local --------------
                              Container(
                                padding: const EdgeInsets.all(0),
                                height: 90,
                                width: 65,
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: e.match!.local.logoFullPath,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.contain,
                                      height: 65,
                                      width: 65,
                                      placeholder: (context, url) =>
                                          const Image(
                                        image: AssetImage('assets/loading.gif'),
                                        fit: BoxFit.contain,
                                        height: 65,
                                        width: 65,
                                      ),
                                    ),
                                    Text(e.match!.local.initials,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),

                              //--------------- Goles Local --------------
                              Container(
                                width: 60,
                                alignment: Alignment.center,
                                child: TextField(
                                  autofocus: true,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  controller: _localGoalsController,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: '',
                                      labelText: '',
                                      errorText: _localGoalsShowError
                                          ? _localGoalsError
                                          : null,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onChanged: (value) {
                                    _localGoals = value;
                                  },
                                ),
                              ),
                              //--------------- Separador --------------
                              const Text(
                                ' - ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              //--------------- Goles Visitante --------------
                              Container(
                                width: 60,
                                alignment: Alignment.center,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  controller: _visitorGoalsController,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: '',
                                      labelText: '',
                                      errorText: _visitorGoalsShowError
                                          ? _visitorGoalsError
                                          : null,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onChanged: (value) {
                                    _visitorGoals = value;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              //--------------- Escudo e Iniciales Visitante --------------
                              Container(
                                padding: const EdgeInsets.all(0),
                                height: 90,
                                width: 65,
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: e.match!.visitor.logoFullPath,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.contain,
                                      height: 65,
                                      width: 65,
                                      placeholder: (context, url) =>
                                          const Image(
                                        image: AssetImage('assets/loading.gif'),
                                        fit: BoxFit.contain,
                                        height: 65,
                                        width: 65,
                                      ),
                                    ),
                                    Text(e.match!.visitor.initials,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB4161B),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Icon(Icons.cancel),
                                      Text('Cancelar'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(166, 5, 68, 7),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_localGoalsController.text == '') {
                                      await showAlertDialog(
                                          context: context,
                                          title: 'Error',
                                          message:
                                              'Ingrese Goles para el Local',
                                          actions: <AlertDialogAction>[
                                            const AlertDialogAction(
                                                key: null, label: 'Aceptar'),
                                          ]);
                                      return;
                                    }

                                    if (_visitorGoalsController.text == '') {
                                      await showAlertDialog(
                                          context: context,
                                          title: 'Error',
                                          message:
                                              'Ingrese Goles para el Visitante',
                                          actions: <AlertDialogAction>[
                                            const AlertDialogAction(
                                                key: null, label: 'Aceptar'),
                                          ]);
                                      return;
                                    }

                                    for (Prediction prediction
                                        in _pendingPredictions) {
                                      if (prediction.match!.id == e.match!.id) {
                                        prediction.goalsLocal = int.parse(
                                            _localGoalsController.text);
                                        prediction.goalsVisitor = int.parse(
                                            _visitorGoalsController.text);
                                        _savePrediction(e);
                                      }
                                    }

                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Icon(Icons.save),
                                      Text('Aceptar'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      );
                    },
                    barrierDismissible: false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.sports_soccer),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Cargar goles'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

//***********************************************************************
//******************** savePrediction ***********************************
//***********************************************************************
  _savePrediction(Prediction prediction) async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'userId': widget.user.userId,
      'matchId': prediction.match!.id,
      'goalsLocal': prediction.goalsLocal,
      'goalsVisitor': prediction.goalsVisitor,
    };

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

    Response response =
        await ApiHelper.post('/api/Predictions/', request, widget.token);

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
    //Navigator.pop(context, 'yes');
  }
}
