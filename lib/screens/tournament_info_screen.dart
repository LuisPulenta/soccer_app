import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soccer_app/components/loader_component.dart';
import 'package:soccer_app/models/group.dart';
import 'package:soccer_app/models/groupdetail.dart';
import 'package:soccer_app/models/token.dart';
import 'package:soccer_app/models/tournament.dart';

import 'group_info_screen.dart';

class TournamentInfoScreen extends StatefulWidget {
  final Token token;
  final Tournament tournament;

  TournamentInfoScreen({required this.token, required this.tournament});

  @override
  _TournamentInfoScreenState createState() => _TournamentInfoScreenState();
}

class _TournamentInfoScreenState extends State<TournamentInfoScreen> {
  bool _showLoader = false;
  List<Groups> _groups = [];
  List<GroupDetails> _groupDetails = [];

  @override
  void initState() {
    super.initState();
    Tournament _tournament = widget.tournament;
    List<Groups> _groups = widget.tournament.groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00D99D),
      appBar: AppBar(
        title: Text(widget.tournament.name),
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
        Expanded(
          child: widget.tournament.groups.length == 0
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
          'No hay equipos en este Torneo.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _getListView() {
    return ListView(
      children: widget.tournament.groups.map((e) {
        return Card(
            color: Color(0xFFFFFFCC),
            shadowColor: Color(0xFF0000FF),
            elevation: 10,
            margin: EdgeInsets.all(10),
            child: InkWell(
              onTap: () => _goGroup(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              'Zona: ${e.name}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 40,
                    )
                  ],
                ),
              ),
            ));
      }).toList(),
    );
  }

  void _goGroup(Groups group) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GroupInfoScreen(
                  token: widget.token,
                  group: group,
                )));
  }
}
