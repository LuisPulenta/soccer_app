import 'package:soccer_app/models/models.dart';

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
    player = json['player'] != null ? new User.fromJson(json['player']) : null;
    match = json['match'] != null ? new Matches.fromJson(json['match']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goalsLocal'] = this.goalsLocal;
    data['goalsVisitor'] = this.goalsVisitor;
    data['points'] = this.points;
    data['player'] = this.player;
    if (this.match != null) {
      data['match'] = this.match!.toJson();
    }
    return data;
  }
}
