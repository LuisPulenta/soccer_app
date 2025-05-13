import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/loader_component.dart';
import '../helpers/api_helper.dart';
import '../models/models.dart';
import 'screens.dart';

class TournamentsScreen extends StatefulWidget {
  final Token token;
  final int opcion;
  final User user;

  const TournamentsScreen(
      {super.key,
      required this.token,
      required this.opcion,
      required this.user});

  @override
  _TournamentsScreenState createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
//***********************************************************************
//******************** Declaración de Variables *************************
//***********************************************************************
  List<Tournament> _tournaments = [];
  List<Tournament> _tournamentsAux = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

//***********************************************************************
//******************** Init State ***************************************
//***********************************************************************
  @override
  void initState() {
    super.initState();
    _getTournaments();
  }

//***********************************************************************
//******************** Pantalla *****************************************
//***********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D99D),
      appBar: AppBar(
        title: const Text('Torneos'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(166, 5, 68, 7),
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: const Icon(Icons.filter_none))
              : IconButton(
                  onPressed: _showFilter, icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- getContent ---------------------------------
//-----------------------------------------------------------------------
  Widget _getContent() {
    return _tournaments.isEmpty ? _noContent() : _getListView();
  }

//-----------------------------------------------------------------------
//-------------------------- noContent ----------------------------------
//-----------------------------------------------------------------------
  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay torneos con ese criterio de búsqueda'
              : 'No hay torneos registrados',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- getListView --------------------------------
//-----------------------------------------------------------------------
  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getTournaments,
      child: ListView(
        children: _tournaments.map((e) {
          return Card(
            color: const Color(0xFFFFFFCC),
            shadowColor: const Color(0xFF0000FF),
            elevation: 10,
            margin: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () => _goInfoTournament(e),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: CachedNetworkImage(
                        imageUrl: e.logoFullPath,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.contain,
                        height: 80,
                        width: 120,
                        placeholder: (context, url) => const Image(
                          image: AssetImage('assets/loading.gif'),
                          fit: BoxFit.cover,
                          height: 80,
                          width: 120,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(e.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(e.startDateLocal)),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(e.endDateLocal)),
                                        style: const TextStyle(fontSize: 12),
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
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

//***********************************************************************
//******************** Método getTournaments ****************************
//***********************************************************************
  Future<void> _getTournaments() async {
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

    Response response = await ApiHelper.getTournaments(widget.token);

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
    _tournamentsAux = response.result;

    if (widget.opcion == 1) {
      _tournaments = _tournamentsAux;
    }

    if (widget.opcion == 2) {
      _tournaments = _tournamentsAux;
    }

    // if (widget.opcion == 2) {
    //   _tournaments = [];
    //   _tournamentsAux.forEach((tournament) {
    //     if (!DateTime.now().isAfter(DateTime.parse(tournament.endDateLocal))) {
    //       _tournaments.add(tournament);
    //     }
    //   });
    // }

    _tournaments.sort((b, a) {
      return a.startDate
          .toString()
          .toString()
          .toLowerCase()
          .compareTo(b.startDate.toString().toLowerCase());
    });

    setState(() {});
  }

//***********************************************************************
//******************** Método showFilter ********************************
//***********************************************************************

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Filtrar Usuarios'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text('Escriba las primeras letras del Torneo'),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Criterio de búsqueda...',
                    labelText: 'Buscar',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () => _filter(), child: const Text('Filtrar')),
            ],
          );
        });
  }

//***********************************************************************
//******************** Método removeFilter ******************************
//***********************************************************************
  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getTournaments();
  }

//***********************************************************************
//******************** Método filter ************************************
//***********************************************************************
  _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Tournament> filteredList = [];
    for (var user in _tournaments) {
      if (user.name.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(user);
      }
    }

    setState(() {
      _tournaments = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

//***********************************************************************
//******************** Método goInfoTournament **************************
//***********************************************************************
  void _goInfoTournament(Tournament tournament) async {
    if (widget.opcion == 1) {
      String? result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TournamentInfoScreen(
                  token: widget.token, tournament: tournament)));
      if (result == 'yes') {
        _getTournaments();
      }
    }

    if (widget.opcion == 2) {
      String? result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PredictionsScreen(
                  token: widget.token,
                  user: widget.user,
                  tournament: tournament)));
      if (result == 'yes') {
        _getTournaments();
      }
    }
  }
}
