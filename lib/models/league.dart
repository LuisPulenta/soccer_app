import 'models.dart';

class League {
  int id = 0;
  String name = '';
  String? logoPath = '';
  String? logoFullPath = '';
  List<Team> teams = [];

  League(
      {required this.id,
      required this.name,
      required this.logoPath,
      required this.logoFullPath,
      required this.teams});

  League.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logoPath = json['logoPath'];
    logoFullPath = json['logoFullPath'];
    if (json['teams'] != null) {
      teams = [];
      json['teams'].forEach((v) {
        teams.add(Team.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logoPath'] = logoPath;
    data['logoFullPath'] = logoFullPath;
    if (teams != null) {
      data['teams'] = teams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
