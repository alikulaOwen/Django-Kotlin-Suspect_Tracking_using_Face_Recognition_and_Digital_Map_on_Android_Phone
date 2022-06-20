import 'package:njia/constants/app_constants.dart';
import 'package:njia/models/suspect.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';

class SuspectService {
  Box? loginCredentials;
  Box? suspectLocations;
  String? token;

  Future<List<Suspect>?> getSuspects() async {
    loginCredentials = await Hive.openBox('logindata');
    token = loginCredentials!.get('token');
    var url = Uri.parse('$baseUrl/suspects/');
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
    );
    if (response.statusCode == 200) {
      var json = response.body;
      return suspectFromJson(json);
    }

    //   var json = convert.jsonDecode(response.body);
    //   var jsonResults = json as List;
    //   return jsonResults
    //       .map((suspect) => SuspectSearch.fromJson(suspect))
    //       .toList();
  }
}
