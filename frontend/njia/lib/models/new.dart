// To parse this JSON data, do
//
//     final locations = locationsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:njia/constants/app_constants.dart';

Locations locationsFromJson(String str) => Locations.fromJson(json.decode(str));

String locationsToJson(Locations data) => json.encode(data.toJson());

class Locations {
  Locations({
    required this.offices,
  });

  late List<Office> offices;

  Locations.fromJson(Map<String, dynamic> json) {
    if (json['locations'] != null) {
      offices = <Office>[];
      json['locations'].forEach((v) {
        offices.add(Office.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
        "offices": List<dynamic>.from(offices.map((x) => x.toJson()).toList()),
      };
}

Future<Locations> getGoogleOffices(String search) async {
  final loginCredentials = await Hive.openBox('logindata');
  var token = loginCredentials.get('token');
  var url = Uri.parse("$baseUrl/locations/?search=$search");
  // Retrieve the locations of Google offices
  var response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Token $token"
    },
  );
  if (response.statusCode == 200) {
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: url);
  }
}

class Office {
  Office({
    required this.url,
    required this.latitude,
    required this.longitude,
    required this.county,
    required this.subCounty,
    required this.constituency,
  });

  final String url;
  final double latitude;
  final double longitude;
  final String county;
  final String subCounty;
  final String constituency;

  factory Office.fromJson(Map<String, dynamic> json) => Office(
        url: json["url"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
        county: json["county"],
        subCounty: json["sub_county"],
        constituency: json["constituency"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "latitude": latitude,
        "longitude": longitude,
        "county": county,
        "sub_county": subCounty,
        "constituency": constituency,
      };
}
