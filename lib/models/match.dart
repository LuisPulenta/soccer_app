import 'package:soccer_app/models/team.dart';

class Matches {
  int id = 0;
  String date = '';
  String dateLocal = '';
  Team local = Team(
      id: 0,
      name: '',
      initials: '',
      logoPath: '',
      leagueId: 0,
      leagueName: '',
      logoFullPath: '');
  Team visitor = Team(
      id: 0,
      name: '',
      initials: '',
      logoPath: '',
      leagueId: 0,
      leagueName: '',
      logoFullPath: '');
  int? goalsLocal = 0;
  int? goalsVisitor = 0;
  bool isClosed = false;
  String? dateName2 = '';

  Matches(
      {required this.id,
      required this.date,
      required this.dateLocal,
      required this.local,
      required this.visitor,
      required this.goalsLocal,
      required this.goalsVisitor,
      required this.isClosed,
      required this.dateName2});

  Matches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateLocal = json['dateLocal'];
    local = new Team.fromJson(json['local']);
    visitor = new Team.fromJson(json['visitor']);
    goalsLocal = json['goalsLocal'];
    goalsVisitor = json['goalsVisitor'];
    isClosed = json['isClosed'];
    dateName2 = json['dateName2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['dateLocal'] = this.dateLocal;
    data['local'] = this.local.toJson();
    data['visitor'] = this.visitor.toJson();
    data['goalsLocal'] = this.goalsLocal;
    data['goalsVisitor'] = this.goalsVisitor;
    data['isClosed'] = this.isClosed;
    data['dateName2'] = this.dateName2;
    return data;
  }
}
