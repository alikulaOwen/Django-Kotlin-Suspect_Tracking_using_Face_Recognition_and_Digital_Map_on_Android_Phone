import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:njia/models/place.dart';
import 'package:njia/models/place_search.dart';
import 'package:njia/models/suspect_location_model.dart';
import 'package:njia/services/geolocater_service.dart';
import 'package:njia/services/places_service.dart';
import 'package:njia/services/suspect_location_service.dart';

class ApplicationBloc with ChangeNotifier {
  final placesService = PlacesService();
  final geolocaterService = GeolocaterService();
  final suspectLocationService = GetLocationService();

  // Variables
  Position? currentLocation;
  List<PlaceSearch>? searchResults;
  List<SuspectLocationModel>? suspectLocationResults;
  StreamController<Place> selectedLocation = StreamController<Place>();

  ApplicationBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geolocaterService.getCurrentLocation();
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutoComplete(searchTerm);
    notifyListeners();
  }

  // searchSuspectLocation(String name) async {
  //   suspectLocationResults = await suspectLocationService.locate(name);
  //   notifyListeners();
  // }

  setSelectedLocation(String placeId) async {
    selectedLocation.add(await placesService.getPlace(placeId));
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedLocation.close();
    super.dispose();
  }
}
