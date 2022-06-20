import 'package:njia/models/location.dart';

class Geometry {
  final Location location;
  Geometry({required this.location});

  Geometry.fromJson(Map<String, dynamic> parsedjson)
      : location = Location.fromJson(parsedjson['location']);
}
