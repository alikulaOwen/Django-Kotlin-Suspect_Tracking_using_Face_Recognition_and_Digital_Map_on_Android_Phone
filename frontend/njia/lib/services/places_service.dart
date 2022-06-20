import 'package:http/http.dart' as http;
import 'package:njia/models/place.dart';
import 'dart:convert' as convert;

import 'package:njia/models/place_search.dart';

class PlacesService {
  final key = 'Your Google Maps APi Key';

  Future<List<PlaceSearch>> getAutoComplete(String search) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=%28cities%29&key=$key');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }
}
