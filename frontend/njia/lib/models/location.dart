class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> parsedjson) {
    return Location(lat: parsedjson['lat'], lng: parsedjson['lng']);
  }
}
