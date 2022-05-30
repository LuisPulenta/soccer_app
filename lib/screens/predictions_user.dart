import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soccer_app/components/loader_component.dart';
import 'package:soccer_app/helpers/api_helper.dart';
import 'package:soccer_app/models/models.dart';

class PredictionsUser extends StatefulWidget {
  final GroupPosition groupPosition;
  final User user;
  final int tournamentId;
  final Token token;

  const PredictionsUser(
      {required this.groupPosition,
      required this.user,
      required this.tournamentId,
      required this.token});

  @override
  State<PredictionsUser> createState() => _PredictionsUserState();
}

class _PredictionsUserState extends State<PredictionsUser> {
//***********************************************************************
//******************** Declaración de Variables *************************
//***********************************************************************
  bool _showLoader = false;
  List<GroupPosition>? _groupBetPlayers = [];
  List<Prediction> _predictionsAux = [];
  List<Prediction> _predictions = [];
  List<Prediction> _predictionsFiltered = [];

  String _filter = '';
  String _filterError = '';
  bool _filterShowError = false;
  TextEditingController _filterController = TextEditingController();

//***********************************************************************
//******************** Init State ***************************************
//***********************************************************************
  @override
  void initState() {
    super.initState();
    _getPredictionsUser();
  }

//***********************************************************************
//******************** Pantalla *****************************************
//***********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Predicciones de ' + widget.groupPosition.playerResponse!.nickName),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 69, 48),
      ),
      body: Container(
        color: Color(0xFF00D99D),
        child: Column(
          children: [
            _showInfoUser(),
            Divider(
              color: Colors.black,
              height: 2,
            ),
            Row(
              children: [
                Expanded(flex: 3, child: _showFilter()),
                Expanded(flex: 1, child: _showEraseButton()),
                Expanded(flex: 1, child: _showSearchButton()),
              ],
            ),
            _predictionsFiltered.length == 0 ? Container() : _showResumen(),
            _showLoader
                ? Expanded(
                    child: Container(
                        child: LoaderComponent(text: 'Por favor espere...')),
                  )
                : Expanded(
                    child: _predictionsFiltered.length == 0
                        ? _noContentPredictions()
                        : _getListViewPredictions(),
                  )
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ _showInfoUser --------------------------------
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
            left: 10,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: CachedNetworkImage(
                  imageUrl:
                      widget.groupPosition.playerResponse!.pictureFullPath,
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
          ),
          Positioned(
            top: 50,
            left: 70,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: CachedNetworkImage(
                  imageUrl:
                      widget.groupPosition.playerResponse!.team!.logoFullPath,
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
                    child: Text("Predicciones de",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  Text(
                      widget.groupPosition.playerResponse!.firstName +
                          " " +
                          widget.groupPosition.playerResponse!.lastName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromARGB(255, 33, 33, 243),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(" (a) " + widget.groupPosition.playerResponse!.nickName,
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

//***********************************************************************
//******************** Método getPredictionsUser ************************
//***********************************************************************
  Future<Null> _getPredictionsUser() async {
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

    Response response = await ApiHelper.getPredictions(widget.tournamentId,
        widget.groupPosition.playerResponse!.id, widget.token);

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

    _predictionsAux = response.result;
    _predictions = [];

    _predictionsAux.forEach((prediction) {
      if (prediction.match!.isClosed) {
        _predictions.add(prediction);
      }
    });

    _predictionsFiltered = _predictions;

    _predictionsFiltered.sort((b, a) {
      int dateNameComp = a.match!.dateName!.compareTo(b.match!.dateName!);
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
//--------------------- METODO SHOWERASEBUTTON --------------------
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
                _predictionsFiltered = _predictions;
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
    _predictionsFiltered = [];
    _predictions.forEach((prediction) {
      if (prediction.match!.local.initials
              .toLowerCase()
              .contains(_filter.toLowerCase()) ||
          prediction.match!.visitor.initials
              .toLowerCase()
              .contains(_filter.toLowerCase()) ||
          prediction.match!.dateName!
              .toLowerCase()
              .contains(_filter.toLowerCase())) {
        _predictionsFiltered.add(prediction);
      }
    });
    _predictionsFiltered.sort((b, a) {
      int dateNameComp = a.match!.dateName!.compareTo(b.match!.dateName!);
      if (dateNameComp != 0) return dateNameComp;
      int initialsName =
          b.match!.local.initials.compareTo(a.match!.local.initials);
      return initialsName;
    });
    setState(() {});
  }

//-----------------------------------------------------------------------
//-------------------------- _showResumen -------------------------------
//-----------------------------------------------------------------------
  Widget _showResumen() {
    int puntos = 0;

    _predictionsFiltered.forEach((prediction) {
      if (prediction.points != null) {
        puntos = puntos + prediction.points!;
      }
      ;
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
          color: Color.fromARGB(255, 240, 229, 105),
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
                                  'Partidos:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (_predictionsFiltered.length).toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                          Container(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  puntos.toString(),
                                  style: TextStyle(
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
//-------------------------- noContentPredictions ---------------
//-----------------------------------------------------------------------
  Widget _noContentPredictions() {
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
//-------------------------- _getListViewPredictions ------------
//-----------------------------------------------------------------------
  _getListViewPredictions() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: _predictionsFiltered.map((e) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
              color: Color(0xFFFFFFCC),
              margin: EdgeInsets.all(2),
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
                            InkWell(
                              onTap: () {
                                _filter = e.match!.local.initials;
                                _search();
                              },
                              child: CachedNetworkImage(
                                imageUrl: e.match!.local.logoFullPath,
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
                            ),
                            Text(e.match!.local.initials,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                            Divider(
                              color: Colors.black,
                            ),
                            Text("Real",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                e.match!.goalsLocal.toString() +
                                    " - " +
                                    e.match!.goalsVisitor.toString(),
                                style: TextStyle(
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
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.match!.dateLocal))}',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.indigo,
                                  child: Text(
                                    "Puntos",
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
                                    style: TextStyle(
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
                            Text(e.match!.visitor.initials,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                            Divider(
                              color: Colors.black,
                            ),
                            Text("Predicción",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                e.goalsLocal.toString() +
                                    " - " +
                                    e.goalsVisitor.toString(),
                                style: TextStyle(
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
}
