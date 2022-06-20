import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:njia/blocs/application_bloc.dart';
import 'package:njia/constants/app_constants.dart';
import 'package:njia/models/place.dart';
import 'package:njia/widgets/bottom_nav_bar.dart';
import 'package:njia/widgets/location_result_box.dart';
import 'package:njia/widgets/mapUserBadge.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType currentMapType = MapType.normal;
  late bool serviceEnabled;
  late StreamSubscription locationSubscription;
  Box? loginCredentials;
  final _liveClassController = StreamController<ApplicationBloc>.broadcast();

  @override
  void initState() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    if (_liveClassController == null) {
      locationSubscription =
          applicationBloc.selectedLocation.stream.listen((place) {
        if (place != null) {
          _goToPlace(place);
        }
      });
    }

    super.initState();
    // createOpenBox();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

  static final Marker _kGoogMarker = Marker(
    
      markerId: const MarkerId('_kGoogMarker'),
      infoWindow: const InfoWindow(title: 'Hello'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(defaultPosition.latitude, defaultPosition.longitude));

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: (applicationBloc.currentLocation == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    mapType: currentMapType,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(applicationBloc.currentLocation!.latitude,
                          applicationBloc.currentLocation!.longitude),
                      tilt: 59.440717697143555,
                      zoom: 14.4746,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      //  on tap screen
                    },
                    markers: {_kGoogMarker},
                  ),
                ),
                const Positioned(
                    top: 50, left: 0, right: 0, child: MapUserBadge()),
                const Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    child: Center(child: LocationResultBox())),
                // const Positioned(child: Center(child: MyBottomNavBar())),
              ],
            ),
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   width: 20,
            // ),
            SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 18),
              backgroundColor: mainHexColor,
              visible: true,
              overlayOpacity: 0.4,
              curve: Curves.bounceIn,
              buttonSize: Size(50.0, 49.0),
              label: const Text(
                'Map Type',
                style: TextStyle(fontSize: 12),
              ),
              children: [
                // Fab 1
                SpeedDialChild(
                    child: Icon(Icons.landscape_outlined),
                    backgroundColor: accentHexColor,
                    onTap: () {
                      setState(() {
                        currentMapType = MapType.normal;
                      });
                    },
                    label: 'Normal',
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16.0),
                    labelBackgroundColor: mainHexColor),
                SpeedDialChild(
                    child: Icon(Icons.satellite_sharp),
                    backgroundColor: accentHexColor,
                    onTap: () {
                      setState(() {
                        currentMapType = MapType.satellite;
                      });
                    },
                    label: 'Satellite',
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16.0),
                    labelBackgroundColor: mainHexColor),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        tilt: 59.440717697143555,
        zoom: 14.4746,
      ),
    ));
  }
}
