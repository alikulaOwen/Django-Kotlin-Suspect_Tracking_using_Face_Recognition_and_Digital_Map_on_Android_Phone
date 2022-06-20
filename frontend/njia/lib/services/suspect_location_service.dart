import 'package:http/http.dart' as http;
import 'package:njia/constants/app_constants.dart';
import 'dart:convert';
import 'package:njia/models/suspect_location_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GetLocationService {
  Box? loginCredentials;
  String? token;

  Future<SuspectLocationModel> locate(String search) async {
    var url = Uri.parse("$baseUrl/locations/?search=$search");
    token = loginCredentials!.get('token');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
    );
    if (response.statusCode == 200 || response.statusCode == 400) {
      var jsonResponse =
          SuspectLocationModel.fromJson(json.decode(response.body));
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
