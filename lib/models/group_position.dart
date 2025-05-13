import 'models.dart';

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
        ? PlayerResponse.fromJson(json['playerResponse'])
        : null;
    points = json['points'];
    ranking = json['ranking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (playerResponse != null) {
      data['playerResponse'] = playerResponse!.toJson();
    }
    data['points'] = points;
    data['ranking'] = ranking;
    return data;
  }
}
