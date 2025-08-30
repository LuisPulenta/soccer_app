import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/loader_component.dart';
import '../helpers/api_helper.dart';
import '../models/models.dart';
import 'screens.dart';

class MyGroupsScreen extends StatefulWidget {
  final Token token;
  final User user;

  const MyGroupsScreen({super.key, required this.token, required this.user});

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
    adminNickName: '',
    adminPicture: '',
    adminTeam: '',
    tournamentName: '',
    tournamentId: 0,
    creationDate: '',
    groupBetPlayers: [],
    cantPlayers: 0,
    logoFullPath: '',
  );

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
      backgroundColor: const Color(0xFF00D99D),
      appBar: AppBar(
        title: const Text('Mis Grupos de Apuesta'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 69, 48),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        color: const Color(0xFF00D99D),
        child: Center(
          child: _showLoader
              ? const LoaderComponent(text: 'Cargando Grupos...')
              : _getContent(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 8, 69, 48),
        onPressed: () async {
          String? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddBetGroupScreen(token: widget.token, user: widget.user),
            ),
          );
          if (result == 'yes') {
            _getMyGroups();
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //------------------------------ METODO GETCONTENT --------------------------
  //-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showInfoUser(),
        Expanded(child: _myGroups.isEmpty ? _noContent() : _getListView()),
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
      color: const Color(0xFF00D99D),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                imageUrl: widget.user.pictureFullPath,
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
                imageUrl: widget.user.team.logoFullPath,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Grupos de Apuestas de ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${widget.user.firstName} ${widget.user.lastName}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 33, 33, 243),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' (a) ${widget.user.nickName}',
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

  //-----------------------------------------------------------------------------
  //------------------------------ METODO NOCONTENT -----------------------------
  //-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
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
          color: const Color.fromARGB(255, 198, 230, 164),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: InkWell(
            onTap: () {
              groupSelected = e;
              _goInfoMyGroup(e);
            },
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: CachedNetworkImage(
                              imageUrl: e.logoFullPath,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Creado el ${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.creationDate))}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'por ${e.adminName}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Cant. Jugadores: ${e.cantPlayers}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  e.tournamentName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
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
                                    imageUrl: e.adminTeam,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    height: 30,
                                    width: 30,
                                    placeholder: (context, url) => const Image(
                                      image: AssetImage('assets/loading.gif'),
                                      fit: BoxFit.cover,
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
        ),
      ),
    );
    // if (result == 'Yes') {
    //   setState(() {});
    // }
  }

  //***********************************************************************
  //******************** Método getMyGroups *********************************
  //***********************************************************************
  Future<void> _getMyGroups() async {
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
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    _myGroups = response.result;

    _myGroups.sort((b, a) {
      return a.creationDate.toString().toLowerCase().compareTo(
        b.creationDate.toString().toLowerCase(),
      );
    });

    setState(() {});
  }
}
