import 'models.dart';

class Prediction {
  int id = 0;
  int? goalsLocal = 0;
  int? goalsVisitor = 0;
  int? points = 0;
  User? player = User(
      id: 0,
      userId: '',
      firstName: '',
      lastName: '',
      picturePath: '',
      nickName: '',
      team: Team(
          id: 0,
          name: '',
          initials: '',
          logoPath: '',
          leagueId: 0,
          leagueName: '',
          logoFullPath: ''),
      points: 0,
      email: '',
      userType: 0,
      fullName: '',
      pictureFullPath: '');
  Matches? match;

  Prediction(
      {required this.id,
      required this.goalsLocal,
      required this.goalsVisitor,
      required this.points,
      required this.player,
      required this.match});

  Prediction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goalsLocal = json['goalsLocal'];
    goalsVisitor = json['goalsVisitor'];
    points = json['points'];
    player = json['player'] != null ? User.fromJson(json['player']) : null;
    match = json['match'] != null ? Matches.fromJson(json['match']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['goalsLocal'] = goalsLocal;
    data['goalsVisitor'] = goalsVisitor;
    data['points'] = points;
    data['player'] = player;
    if (match != null) {
      data['match'] = match!.toJson();
    }
    return data;
  }
}
