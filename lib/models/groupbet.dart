import 'models.dart';

class GroupBet {
  int id = 0;
  String name = '';
  String logoPath = '';
  String adminName = '';
  String adminNickName = '';
  String adminPicture = '';
  String adminTeam = '';
  String tournamentName = '';
  int tournamentId = 0;
  String creationDate = '';
  List<GroupBetPlayers>? groupBetPlayers = [];
  int cantPlayers = 0;
  String logoFullPath = '';

  GroupBet(
      {required this.id,
      required this.name,
      required this.logoPath,
      required this.adminName,
      required this.adminNickName,
      required this.adminPicture,
      required this.adminTeam,
      required this.tournamentName,
      required this.tournamentId,
      required this.creationDate,
      required this.groupBetPlayers,
      required this.cantPlayers,
      required this.logoFullPath});

  GroupBet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logoPath = json['logoPath'];
    adminName = json['adminName'];
    adminNickName = json['adminNickName'];
    adminPicture = json['adminPicture'];
    adminTeam = json['adminTeam'];
    tournamentName = json['tournamentName'];
    tournamentId = json['tournamentId'];
    creationDate = json['creationDate'];
    if (json['groupBetPlayers'] != null) {
      groupBetPlayers = <GroupBetPlayers>[];
      json['groupBetPlayers'].forEach((v) {
        groupBetPlayers!.add(GroupBetPlayers.fromJson(v));
      });
    }
    cantPlayers = json['cantPlayers'];
    logoFullPath = json['logoFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logoPath'] = logoPath;
    data['adminName'] = adminName;
    data['adminNickName'] = adminNickName;
    data['adminPicture'] = adminPicture;
    data['adminTeam'] = adminTeam;
    data['tournamentName'] = tournamentName;
    data['tournamentId'] = tournamentId;
    data['creationDate'] = creationDate;
    if (groupBetPlayers != null) {
      data['groupBetPlayers'] =
          groupBetPlayers!.map((v) => v.toJson()).toList();
    }
    data['cantPlayers'] = cantPlayers;
    data['logoFullPath'] = logoFullPath;
    return data;
  }
}
