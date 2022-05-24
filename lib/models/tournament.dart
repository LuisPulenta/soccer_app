import 'package:soccer_app/models/datename.dart';
import 'package:soccer_app/models/group.dart';

class Tournament {
  int id = 0;
  String name = '';
  String startDate = '';
  String startDateLocal = '';
  String endDate = '';
  String endDateLocal = '';
  bool isActive = true;
  String logoPath = '';
  List<Groups> groups = [];
  List<DateNames> dateNames = [];
  String logoFullPath = '';

  Tournament(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.startDateLocal,
      required this.endDate,
      required this.endDateLocal,
      required this.isActive,
      required this.logoPath,
      required this.groups,
      required this.dateNames,
      required this.logoFullPath});

  Tournament.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startDate = json['startDate'];
    startDateLocal = json['startDateLocal'];
    endDate = json['endDate'];
    endDateLocal = json['endDateLocal'];
    isActive = json['isActive'];
    logoPath = json['logoPath'];

    if (json['groups'] != null) {
      groups = [];
      json['groups'].forEach((v) {
        groups.add(new Groups.fromJson(v));
      });
    }

    if (json['dateNames'] != null) {
      groups = [];
      json['dateNames'].forEach((v) {
        dateNames.add(new DateNames.fromJson(v));
      });
    }

    logoFullPath = json['logoFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['startDateLocal'] = this.startDateLocal;
    data['endDate'] = this.endDate;
    data['endDateLocal'] = this.endDateLocal;
    data['isActive'] = this.isActive;
    data['logoPath'] = this.logoPath;

    data['groups'] = this.groups.map((v) => v.toJson()).toList();

    data['dateNames'] = this.dateNames.map((v) => v.toJson()).toList();

    data['logoFullPath'] = this.logoFullPath;
    return data;
  }
}
