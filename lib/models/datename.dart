import 'package:soccer_app/models/match.dart';

class DateNames {
  int id = 0;
  String name = '';
  List<Matches> matches = [];

  DateNames({required this.id, required this.name, required this.matches});

  DateNames.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    if (json['matches'] != null) {
      matches = [];
      json['matches'].forEach((v) {
        matches.add(new Matches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.matches != null) {
      data['matches'] = this.matches.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
