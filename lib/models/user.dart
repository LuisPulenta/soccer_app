import 'package:soccer_app/models/team.dart';

class User {
  String userId = '';
  String document = '';
  String firstName = '';
  String lastName = '';
  String address = '';
  String bornDate = '';
  String sex = '';
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
  double latitude = 0;
  double longitude = 0;
  String email = '';
  String phoneNumber = '';
  int userType = 0;
  String fullName = '';
  String fullNameWithDocument = '';
  String pictureFullPath = '';
  int? emailConfirmed = 0;

  User(
      {required this.userId,
      required this.document,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.bornDate,
      required this.sex,
      required this.picturePath,
      required this.nickName,
      required this.team,
      required this.points,
      required this.latitude,
      required this.longitude,
      required this.email,
      required this.phoneNumber,
      required this.userType,
      required this.fullName,
      required this.fullNameWithDocument,
      required this.pictureFullPath,
      required this.emailConfirmed});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    document = json['document'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    address = json['address'];
    bornDate = json['bornDate'];
    sex = json['sex'];
    picturePath = json['picturePath'];
    nickName = json['nickName'];
    team = new Team.fromJson(json['team']);
    points = json['points'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    userType = json['userType'];
    fullName = json['fullName'];
    fullNameWithDocument = json['fullNameWithDocument'];
    pictureFullPath = json['pictureFullPath'];
    emailConfirmed = json['emailConfirmed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['document'] = this.document;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['address'] = this.address;
    data['bornDate'] = this.bornDate;
    data['sex'] = this.sex;
    data['picturePath'] = this.picturePath;
    data['nickName'] = this.nickName;
    data['team'] = this.team.toJson();
    data['points'] = this.points;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['userType'] = this.userType;
    data['fullName'] = this.fullName;
    data['fullNameWithDocument'] = this.fullNameWithDocument;
    data['pictureFullPath'] = this.pictureFullPath;
    data['emailConfirmed'] = this.emailConfirmed;
    return data;
  }
}
