import 'team.dart';

class Admin {
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
  int? emailConfirmed = 0;

  Admin(
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
      required this.pictureFullPath,
      required this.emailConfirmed});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    picturePath = json['picturePath'];
    nickName = json['nickName'];
    team = Team.fromJson(json['team']);
    points = json['points'];
    email = json['email'];
    userType = json['userType'];
    fullName = json['fullName'];
    pictureFullPath = json['pictureFullPath'];
    emailConfirmed = json['emailConfirmed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['picturePath'] = picturePath;
    data['nickName'] = nickName;
    data['team'] = team.toJson();
    data['points'] = points;
    data['email'] = email;
    data['userType'] = userType;
    data['fullName'] = fullName;
    data['pictureFullPath'] = pictureFullPath;
    data['emailConfirmed'] = emailConfirmed;
    return data;
  }
}
