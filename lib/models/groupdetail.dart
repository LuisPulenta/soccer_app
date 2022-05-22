import 'package:soccer_app/models/team.dart';

class GroupDetails {
  int id = 0;
  int matchesPlayed = 0;
  int matchesWon = 0;
  int matchesTied = 0;
  int matchesLost = 0;
  int points = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;
  int goalDifference = 0;
  Team team = Team(
      id: 0,
      name: '',
      initials: '',
      logoPath: '',
      leagueId: 0,
      leagueName: '',
      logoFullPath: '');

  GroupDetails({
    required this.id,
    required this.matchesPlayed,
    required this.matchesWon,
    required this.matchesTied,
    required this.matchesLost,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    required this.team,
  });

  GroupDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matchesPlayed = json['matchesPlayed'];
    matchesWon = json['matchesWon'];
    matchesTied = json['matchesTied'];
    matchesLost = json['matchesLost'];
    points = json['points'];
    goalsFor = json['goalsFor'];
    goalsAgainst = json['goalsAgainst'];
    goalDifference = json['goalDifference'];
    team = new Team.fromJson(json['team']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['matchesPlayed'] = this.matchesPlayed;
    data['matchesWon'] = this.matchesWon;
    data['matchesTied'] = this.matchesTied;
    data['matchesLost'] = this.matchesLost;
    data['points'] = this.points;
    data['goalsFor'] = this.goalsFor;
    data['goalsAgainst'] = this.goalsAgainst;
    data['goalDifference'] = this.goalDifference;
    if (this.team != null) {
      data['team'] = this.team.toJson();
    }
    return data;
  }
}
