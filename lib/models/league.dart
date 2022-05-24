import 'package:soccer_app/models/models.dart';

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
        teams.add(new Team.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logoPath'] = this.logoPath;
    data['logoFullPath'] = this.logoFullPath;
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
