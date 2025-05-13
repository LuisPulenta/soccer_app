import 'match.dart';

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
        matches.add(Matches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (matches != null) {
      data['matches'] = matches.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
