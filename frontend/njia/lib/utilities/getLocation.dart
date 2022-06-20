import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:njia/screens/home.dart';

class GetLocation {
  late bool serviceEnabled;
  late LocationPermission permission;
  late Position position;

  getCurrentLocation() async{
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


  }

}
