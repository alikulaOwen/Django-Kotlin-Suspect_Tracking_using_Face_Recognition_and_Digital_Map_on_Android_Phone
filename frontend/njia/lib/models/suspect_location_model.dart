// To parse this JSON data, do
//
//     final suspectLocationModel = suspectLocationModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

// List<SuspectLocationModel> suspectLocationModelFromJson(String str) =>
//     List<SuspectLocationModel>.from(
//         json.decode(str).map((x) => SuspectLocationModel.fromJson(x)));

// String suspectLocationModelToJson(List<SuspectLocationModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SuspectLocationModel {
  SuspectLocationModel({
    required this.url,
    required this.latitude,
    required this.longitude,
    required this.county,
    required this.subCounty,
    required this.constituency,
  });

  final String url;
  final String latitude;
  final String longitude;
  final String county;
  final String subCounty;
  final String constituency;

  factory SuspectLocationModel.fromJson(Map<String, dynamic> json) =>
      SuspectLocationModel(
        url: json["url"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        county: json["county"],
        subCounty: json["sub_county"],
        constituency: json["constituency"],
      );

  // Map<String, dynamic> toJson() => {
  //       "url": url,
  //       "latitude": latitude,
  //       "longitude": longitude,
  //       "county": county,
  //       "sub_county": subCounty,
  //       "constituency": constituency,
  //     };
}
