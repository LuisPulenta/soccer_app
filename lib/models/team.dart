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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['initials'] = this.initials;
    data['logoPath'] = this.logoPath;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['logoFullPath'] = this.logoFullPath;
    return data;
  }
}
