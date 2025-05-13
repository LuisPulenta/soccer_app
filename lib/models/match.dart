import 'team.dart';

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
  String? dateName = '';

  Matches(
      {required this.id,
      required this.date,
      required this.dateLocal,
      required this.local,
      required this.visitor,
      required this.goalsLocal,
      required this.goalsVisitor,
      required this.isClosed,
      required this.dateName});

  Matches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateLocal = json['dateLocal'];
    local = Team.fromJson(json['local']);
    visitor = Team.fromJson(json['visitor']);
    goalsLocal = json['goalsLocal'];
    goalsVisitor = json['goalsVisitor'];
    isClosed = json['isClosed'];
    dateName = json['dateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['dateLocal'] = dateLocal;
    data['local'] = local.toJson();
    data['visitor'] = visitor.toJson();
    data['goalsLocal'] = goalsLocal;
    data['goalsVisitor'] = goalsVisitor;
    data['isClosed'] = isClosed;
    data['dateName'] = dateName;
    return data;
  }
}
