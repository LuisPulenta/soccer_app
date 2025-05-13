import 'team.dart';

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
    team = Team.fromJson(json['team']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['matchesPlayed'] = matchesPlayed;
    data['matchesWon'] = matchesWon;
    data['matchesTied'] = matchesTied;
    data['matchesLost'] = matchesLost;
    data['points'] = points;
    data['goalsFor'] = goalsFor;
    data['goalsAgainst'] = goalsAgainst;
    data['goalDifference'] = goalDifference;
    if (team != null) {
      data['team'] = team.toJson();
    }
    return data;
  }
}
