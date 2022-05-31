import 'package:soccer_app/models/models.dart';

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
        groupBetPlayers!.add(new GroupBetPlayers.fromJson(v));
      });
    }
    cantPlayers = json['cantPlayers'];
    logoFullPath = json['logoFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logoPath'] = this.logoPath;
    data['adminName'] = this.adminName;
    data['adminNickName'] = this.adminNickName;
    data['adminPicture'] = this.adminPicture;
    data['adminTeam'] = this.adminTeam;
    data['tournamentName'] = this.tournamentName;
    data['tournamentId'] = this.tournamentId;
    data['creationDate'] = this.creationDate;
    if (this.groupBetPlayers != null) {
      data['groupBetPlayers'] =
          this.groupBetPlayers!.map((v) => v.toJson()).toList();
    }
    data['cantPlayers'] = this.cantPlayers;
    data['logoFullPath'] = this.logoFullPath;
    return data;
  }
}
