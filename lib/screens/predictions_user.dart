import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/loader_component.dart';
import '../helpers/api_helper.dart';
import '../models/models.dart';

class PredictionsUser extends StatefulWidget {
  final GroupPosition groupPosition;
  final User user;
  final int tournamentId;
  final Token token;

  const PredictionsUser({
    super.key,
    required this.groupPosition,
    required this.user,
    required this.tournamentId,
    required this.token,
  });

  @override
  State<PredictionsUser> createState() => _PredictionsUserState();
}

class _PredictionsUserState extends State<PredictionsUser> {
  //***********************************************************************
  //******************** Declaración de Variables *************************
  //***********************************************************************
  bool _showLoader = false;
  final List<GroupPosition> _groupBetPlayers = [];
  List<Prediction> _predictionsAux = [];
  List<Prediction> _predictions = [];
  List<Prediction> _predictionsFiltered = [];

  String _filter = '';
  final String _filterError = '';
  final bool _filterShowError = false;
  final TextEditingController _filterController = TextEditingController();

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
          'Predicciones de ${widget.groupPosition.playerResponse!.nickName}',
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 69, 48),
      ),
      body: Container(
        color: const Color(0xFF00D99D),
        child: Column(
          children: [
            _showInfoUser(),
            const Divider(color: Colors.black, height: 2),
            Row(
              children: [
                Expanded(flex: 3, child: _showFilter()),
                Expanded(flex: 1, child: _showEraseButton()),
                Expanded(flex: 1, child: _showSearchButton()),
              ],
            ),
            _predictionsFiltered.isEmpty ? Container() : _showResumen(),
            _showLoader
                ? Expanded(
                    child: Container(
                      child: const LoaderComponent(text: 'Por favor espere...'),
                    ),
                  )
                : Expanded(
                    child: _predictionsFiltered.isEmpty
                        ? _noContentPredictions()
                        : _getListViewPredictions(),
                  ),
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
      color: const Color(0xFF00D99D),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                imageUrl: widget.groupPosition.playerResponse!.pictureFullPath,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: 80,
                width: 80,
                placeholder: (context, url) => const Image(
                  image: AssetImage('assets/loading.gif'),
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                imageUrl:
                    widget.groupPosition.playerResponse!.team!.logoFullPath,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.contain,
                height: 50,
                width: 50,
                placeholder: (context, url) => const Image(
                  image: AssetImage('assets/loading.gif'),
                  fit: BoxFit.contain,
                  height: 50,
                  width: 50,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Predicciones de',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${widget.groupPosition.playerResponse!.firstName} ${widget.groupPosition.playerResponse!.lastName}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 33, 33, 243),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' (a) ${widget.groupPosition.playerResponse!.nickName}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //***********************************************************************
  //******************** Método getPredictionsUser ************************
  //***********************************************************************
  Future<void> _getPredictionsUser() async {
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

    Response response = await ApiHelper.getPredictions(
      widget.tournamentId,
      widget.groupPosition.playerResponse!.id,
      widget.token,
    );

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
        ],
      );
      return;
    }

    _predictionsAux = response.result;
    _predictions = [];

    for (var prediction in _predictionsAux) {
      if (prediction.match!.isClosed) {
        _predictions.add(prediction);
      }
    }

    _predictionsFiltered = _predictions;

    _predictionsFiltered.sort((b, a) {
      int dateNameComp = a.match!.dateName!.compareTo(b.match!.dateName!);
      if (dateNameComp != 0) return dateNameComp;
      int initialsName = b.match!.local.initials.compareTo(
        a.match!.local.initials,
      );
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
                _predictionsFiltered = _predictions;
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.delete), SizedBox(width: 5)],
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
                children: const [Icon(Icons.search), SizedBox(width: 5)],
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
        ],
      );
      return;
    }
    _predictionsFiltered = [];
    for (var prediction in _predictions) {
      if (prediction.match!.local.initials.toLowerCase().contains(
            _filter.toLowerCase(),
          ) ||
          prediction.match!.visitor.initials.toLowerCase().contains(
            _filter.toLowerCase(),
          ) ||
          prediction.match!.dateName!.toLowerCase().contains(
            _filter.toLowerCase(),
          )) {
        _predictionsFiltered.add(prediction);
      }
    }
    _predictionsFiltered.sort((b, a) {
      int dateNameComp = a.match!.dateName!.compareTo(b.match!.dateName!);
      if (dateNameComp != 0) return dateNameComp;
      int initialsName = b.match!.local.initials.compareTo(
        a.match!.local.initials,
      );
      return initialsName;
    });
    setState(() {});
  }

  //-----------------------------------------------------------------------
  //-------------------------- _showResumen -------------------------------
  //-----------------------------------------------------------------------
  Widget _showResumen() {
    int puntos = 0;

    for (var prediction in _predictionsFiltered) {
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
                                  (_predictionsFiltered.length).toString(),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- noContentPredictions ---------------
  //-----------------------------------------------------------------------
  Widget _noContentPredictions() {
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
  //-------------------------- _getListViewPredictions ------------
  //-----------------------------------------------------------------------
  _getListViewPredictions() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: _predictionsFiltered.map((e) {
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
                          Text(
                            e.match!.local.initials,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(color: Colors.black),
                          const Text(
                            'Real',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${e.match!.goalsLocal} - ${e.match!.goalsVisitor}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy',
                          ).format(DateTime.parse(e.match!.dateLocal)),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              Container(
                                color: Colors.indigo,
                                child: const Text(
                                  'Puntos',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.indigo,
                                child: Text(
                                  e.points.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                          Text(
                            e.match!.visitor.initials,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(color: Colors.black),
                          const Text(
                            'Predicción',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${e.goalsLocal} - ${e.goalsVisitor}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
