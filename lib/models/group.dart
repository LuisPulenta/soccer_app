import 'package:soccer_app/models/groupdetail.dart';
import 'package:soccer_app/models/match.dart';
import 'package:soccer_app/models/tournament.dart';

class Groups {
  int id = 0;
  String name = '';
  List<GroupDetails> groupDetails = [];
  List<Matches> matches = [];
  Null zona;

  Groups(
      {required this.id,
      required this.name,
      required this.groupDetails,
      required this.matches,
      required this.zona});

  Groups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['groupDetails'] != null) {
      groupDetails = [];
      json['groupDetails'].forEach((v) {
        groupDetails.add(new GroupDetails.fromJson(v));
      });
    }
    if (json['matches'] != null) {
      matches = [];
      json['matches'].forEach((v) {
        matches.add(new Matches.fromJson(v));
      });
    }
    zona = json['zona'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.groupDetails != null) {
      data['matches'] = this.groupDetails.map((v) => v.toJson()).toList();
    }
    if (this.matches != null) {
      data['matches'] = this.matches.map((v) => v.toJson()).toList();
    }
    data['zona'] = this.zona;
    return data;
  }
}
