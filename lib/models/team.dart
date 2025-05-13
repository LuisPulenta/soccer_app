class Team {
  int id = 0;
  String name = '';
  String initials = '';
  String logoPath = '';
  int leagueId = 0;
  String leagueName = '';
  String logoFullPath = '';

  Team(
      {required this.id,
      required this.name,
      required this.initials,
      required this.logoPath,
      required this.leagueId,
      required this.leagueName,
      required this.logoFullPath});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    initials = json['initials'];
    logoPath = json['logoPath'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    logoFullPath = json['logoFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['initials'] = initials;
    data['logoPath'] = logoPath;
    data['leagueId'] = leagueId;
    data['leagueName'] = leagueName;
    data['logoFullPath'] = logoFullPath;
    return data;
  }
}
