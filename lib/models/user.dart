import 'package:soccer_app/models/team.dart';

class User {
  int id = 0;
  String userId = '';
  String firstName = '';
  String lastName = '';
  String picturePath = '';
  String nickName = '';
  Team team = Team(
      id: 0,
      name: '',
      initials: '',
      logoPath: '',
      leagueId: 0,
      leagueName: '',
      logoFullPath: '');
  int points = 0;
  String email = '';
  int userType = 0;
  String fullName = '';
  String pictureFullPath = '';

  User(
      {required this.id,
      required this.userId,
      required this.firstName,
      required this.lastName,
      required this.picturePath,
      required this.nickName,
      required this.team,
      required this.points,
      required this.email,
      required this.userType,
      required this.fullName,
      required this.pictureFullPath});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    picturePath = json['picturePath'];
    nickName = json['nickName'];
    team = new Team.fromJson(json['team']);
    points = json['points'];
    email = json['email'];
    userType = json['userType'];
    fullName = json['fullName'];
    pictureFullPath = json['pictureFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['picturePath'] = this.picturePath;
    data['nickName'] = this.nickName;
    data['team'] = this.team.toJson();
    data['points'] = this.points;
    data['email'] = this.email;
    data['userType'] = this.userType;
    data['fullName'] = this.fullName;
    data['pictureFullPath'] = this.pictureFullPath;
    return data;
  }
}
