import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';
import 'constants.dart';

class ApiHelper {
  //---------------------------------------------------------------------------
  static Future<Response> getTournaments(Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }

    var url = Uri.parse('${Constants.apiUrl}/api/Tournaments');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Tournament> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Tournament.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> put(
      String controller, Map<String, dynamic> request, Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}$controller');

    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> postNoToken(
      String controller, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> post(
      String controller, Map<String, dynamic> request, Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> delete(
      String controller, String id, Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static bool _validateToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

//---------------------------------------------------------------------------
  static Future<Response> getLeagues() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Leagues');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<League> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(League.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getGroups(int codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Tournaments/GetGroups/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Groups> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Groups.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getGroupDetails(int codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Tournaments/GetGroupDetails/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<GroupDetails> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(GroupDetails.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getMatches(int codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Tournaments/GetMatches/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Matches> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Matches.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getMyGroups(String codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Tournaments/GetMyGroups/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<GroupBet> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(GroupBet.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getPredictions(
      int tournamentId, int userId, Token token) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Predictions/GetPredictionsForUser/$tournamentId/$userId');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Prediction> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Prediction.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getPositionsByTournament(
      int tournament, int groupBet, Token token) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Predictions/GetPositionsByTournament/$tournament/$groupBet');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<GroupPosition> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(GroupPosition.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }
}
