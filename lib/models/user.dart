import 'package:soccer_app/models/team.dart';

class User {
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
  int? emailConfirmed = 0;

  User(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.picturePath,
      required this.nickName,
      required this.team,
      required this.points,
      required this.email,
      required this.userType,
      required this.fullName,
      required this.pictureFullPath,
      required this.emailConfirmed});

  User.fromJson(Map<String, dynamic> json) {
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
    emailConfirmed = json['emailConfirmed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['emailConfirmed'] = this.emailConfirmed;
    return data;
  }
}
