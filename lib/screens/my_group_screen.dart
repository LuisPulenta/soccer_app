import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../components/loader_component.dart';
import '../helpers/api_helper.dart';
import '../models/models.dart';
import 'screens.dart';

class MyGroupScreen extends StatefulWidget {
  final Token token;
  final User user;
  final GroupBet group;

  const MyGroupScreen({
    super.key,
    required this.token,
    required this.user,
    required this.group,
  });

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
        title: Text('Grupo ${widget.group.name}'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 69, 48),
      ),
      body: Container(
        color: const Color(0xFF00D99D),
        child: Column(
          children: [
            _showInfoGroup(),
            const Divider(color: Colors.black, height: 2),
            const SizedBox(height: 10),
            _showButtons(),
            widget.user.fullName == widget.group.adminName
                ? const SizedBox(height: 10)
                : Container(),
            widget.user.fullName == widget.group.adminName
                ? const Divider(color: Colors.black, height: 2)
                : Container(),
            Expanded(
              child: Container(
                child: _showLoader
                    ? const LoaderComponent(text: 'Por favor espere...')
                    : _getContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- getContent ---------------------------------
  //-----------------------------------------------------------------------
  Widget _getContent() {
    return _groupBetPlayers!.isEmpty ? _noContent() : _getListView();
  }

  //-----------------------------------------------------------------------
  //-------------------------- noContent ----------------------------------
  //-----------------------------------------------------------------------
  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
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
      padding: const EdgeInsets.all(0),
      children: _groupBetPlayers!.map((e) {
        return Card(
          color: const Color(0xFFFFFFCC),
          shadowColor: const Color(0xFF0000FF),
          elevation: 10,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: InkWell(
            onTap: () => _goPredictionsUser(e),
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
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
                              ? const Color.fromARGB(255, 141, 145, 149)
                              : e.ranking == 3
                              ? const Color.fromARGB(255, 156, 66, 59)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          e.ranking.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      e.ranking == 1
                          ? const Text('Oro')
                          : e.ranking == 2
                          ? const Text('Plata')
                          : e.ranking == 3
                          ? const Text('Bronce')
                          : const Text(''),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: CachedNetworkImage(
                          imageUrl: e.playerResponse!.pictureFullPath,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: CachedNetworkImage(
                            imageUrl: e.playerResponse!.team!.logoFullPath,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.contain,
                            height: 30,
                            width: 30,
                            placeholder: (context, url) => const Image(
                              image: AssetImage('assets/loading.gif'),
                              fit: BoxFit.contain,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e.playerResponse!.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "(a) ${e.playerResponse!.nickName}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      e.points.toString(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 40),
                ],
              ),
            ),
          ),
        );
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
      color: const Color(0xFF00D99D),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                imageUrl: widget.group.logoFullPath,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: 70,
                width: 70,
                placeholder: (context, url) => const Image(
                  image: AssetImage('assets/loading.gif'),
                  fit: BoxFit.cover,
                  height: 70,
                  width: 70,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                imageUrl: widget.group.adminPicture,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: 80,
                width: 80,
                placeholder: (context, url) => const Image(
                  image: AssetImage('assets/loading.gif'),
                  fit: BoxFit.cover,
                  height: 60,
                  width: 60,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                imageUrl: widget.group.adminTeam,
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
                    'Administrador',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.group.adminName,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 33, 33, 243),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " (a) ${widget.group.adminNickName}",
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

  //**************************************************************************
  //************************* _showButtons ***********************************
  //**************************************************************************

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          widget.user.fullName == widget.group.adminName
              ? Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 8, 69, 48),
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () => _invitar(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.contact_mail),
                        SizedBox(width: 20),
                        Text('Invitar'),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  //***********************************************************************
  //******************** Método _invitar **********************************
  //***********************************************************************
  void _invitar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvitarScreen(
          group: widget.group,
          user: widget.user,
          tournamentId: widget.group.tournamentId,
          token: widget.token,
        ),
      ),
    );
  }

  //***********************************************************************
  //******************** Método goInfoTournament **************************
  //***********************************************************************
  void _goInfoGroupPlayer(GroupPosition groupBetPlayer) async {}

  //***********************************************************************
  //******************** Método getGroupPositions *************************
  //***********************************************************************
  Future<void> _getGroupPositions() async {
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

    Response response = await ApiHelper.getPositionsByTournament(
      widget.group.tournamentId,
      widget.group.id,
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

    _groupBetPlayers = response.result;
    setState(() {});
  }

  //***********************************************************************
  //******************** Método goPredictionsUser *************************
  //***********************************************************************
  void _goPredictionsUser(GroupPosition groupPosition) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PredictionsUser(
          groupPosition: groupPosition,
          user: widget.user,
          tournamentId: widget.group.tournamentId,
          token: widget.token,
        ),
      ),
    );
  }
}
