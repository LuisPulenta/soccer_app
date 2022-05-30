import 'package:soccer_app/models/models.dart';

class GroupPosition {
  PlayerResponse? playerResponse;
  int? points;
  int? ranking;

  GroupPosition(
      {required this.playerResponse,
      required this.points,
      required this.ranking});

  GroupPosition.fromJson(Map<String, dynamic> json) {
    playerResponse = json['playerResponse'] != null
        ? new PlayerResponse.fromJson(json['playerResponse'])
        : null;
    points = json['points'];
    ranking = json['ranking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.playerResponse != null) {
      data['playerResponse'] = this.playerResponse!.toJson();
    }
    data['points'] = this.points;
    data['ranking'] = this.ranking;
    return data;
  }
}
