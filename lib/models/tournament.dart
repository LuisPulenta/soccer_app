import 'datename.dart';
import 'group.dart';

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
        groups.add(Groups.fromJson(v));
      });
    }

    if (json['dateNames'] != null) {
      groups = [];
      json['dateNames'].forEach((v) {
        dateNames.add(DateNames.fromJson(v));
      });
    }

    logoFullPath = json['logoFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['startDate'] = startDate;
    data['startDateLocal'] = startDateLocal;
    data['endDate'] = endDate;
    data['endDateLocal'] = endDateLocal;
    data['isActive'] = isActive;
    data['logoPath'] = logoPath;

    data['groups'] = groups.map((v) => v.toJson()).toList();

    data['dateNames'] = dateNames.map((v) => v.toJson()).toList();

    data['logoFullPath'] = logoFullPath;
    return data;
  }
}
