import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soccer_app/components/loader_component.dart';
import 'package:soccer_app/models/models.dart';

class MyGroupScreen extends StatefulWidget {
  final User user;
  final GroupBet group;

  const MyGroupScreen({required this.user, required this.group});

  @override
  State<MyGroupScreen> createState() => _MyGroupScreenState();
}

class _MyGroupScreenState extends State<MyGroupScreen> {
//***********************************************************************
//******************** Declaración de Variables *************************
//***********************************************************************

  bool _showLoader = false;
  List<GroupBetPlayers>? _groupBetPlayers = [];

//***********************************************************************
//******************** Init State ***************************************
//***********************************************************************
  @override
  void initState() {
    super.initState();
    _groupBetPlayers = widget.group.groupBetPlayers;
    var a = 1;
    //_getGroupPlayers();
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
              Center(
                child: _showLoader
                    ? LoaderComponent(text: 'Por favor espere...')
                    : _getContent(),
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
  Widget _getListView() {
    return Text("ListView");
    // return ListView(
    //   children: _groupBetPlayers!.map((e) {
    //     return Card(
    //       color: Color(0xFFFFFFCC),
    //       shadowColor: Color(0xFF0000FF),
    //       elevation: 10,
    //       margin: EdgeInsets.all(10),
    //       child: InkWell(
    //         onTap: () => _goInfoGroupPlayer(e),
    //         child: Container(
    //           margin: EdgeInsets.all(10),
    //           padding: EdgeInsets.all(5),
    //           child: Row(
    //             children: [
    //               // ClipRRect(
    //               //   borderRadius: BorderRadius.circular(0),
    //               //   child: CachedNetworkImage(
    //               //     imageUrl: e.isAccepted.toString(),
    //               //     errorWidget: (context, url, error) => Icon(Icons.error),
    //               //     fit: BoxFit.contain,
    //               //     height: 80,
    //               //     width: 120,
    //               //     placeholder: (context, url) => Image(
    //               //       image: AssetImage('assets/loading.gif'),
    //               //       fit: BoxFit.cover,
    //               //       height: 80,
    //               //       width: 120,
    //               //     ),
    //               //   ),
    //               // ),
    //               // Expanded(
    //               //   child: Container(
    //               //     margin: EdgeInsets.symmetric(horizontal: 10),
    //               //     child: Row(
    //               //       mainAxisAlignment: MainAxisAlignment.start,
    //               //       children: [
    //               //         Expanded(
    //               //           child: Column(
    //               //             children: [
    //               //               Row(
    //               //                 children: [
    //               //                   Expanded(
    //               //                     child: Text(e.isBlocked.toString(),
    //               //                         style: TextStyle(
    //               //                           fontSize: 16,
    //               //                           fontWeight: FontWeight.bold,
    //               //                         )),
    //               //                   ),
    //               //                 ],
    //               //               ),
    //               //             ],
    //               //           ),
    //               //         ),
    //               //       ],
    //               //     ),
    //               //   ),
    //               // ),
    //               Icon(Icons.arrow_forward_ios),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   }).toList(),
    // );
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
  void _goInfoGroupPlayer(GroupBetPlayers groupBetPlayer) async {}
}
