import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soccer_app/components/loader_component.dart';
import 'package:soccer_app/models/group.dart';
import 'package:soccer_app/models/groupdetail.dart';
import 'package:soccer_app/models/token.dart';

class GroupInfoScreen extends StatefulWidget {
  final Token token;
  final Groups group;

  GroupInfoScreen({required this.token, required this.group});

  @override
  _GroupInfoScreenState createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  bool _showLoader = false;
  List<GroupDetails> _groupDetails = [];

  @override
  void initState() {
    super.initState();
    List<GroupDetails> _groupDetails = widget.group.groupDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00D99D),
      appBar: AppBar(
        title: Text(widget.group.name),
        centerTitle: true,
        backgroundColor: Color.fromARGB(166, 5, 68, 7),
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
    ;
  }

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showFilaTitulo(),
        Expanded(
          child: widget.group.groupDetails.length == 0
              ? _noContent()
              : _getListView(),
        )
      ],
    );
  }

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

  _getListView() {
    return ListView(
      children: widget.group.groupDetails.map((e) {
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

  Widget _showFilaTitulo() {
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
}
