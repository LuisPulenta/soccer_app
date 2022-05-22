import 'package:soccer_app/models/team.dart';
import 'package:soccer_app/models/user.dart';

class Token {
  String token = '';
  String expiration = '';

  Token({required this.token, required this.expiration});

  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expiration'] = this.expiration;
    return data;
  }
}
