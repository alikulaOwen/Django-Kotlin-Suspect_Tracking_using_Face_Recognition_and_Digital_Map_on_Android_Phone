import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:njia/blocs/application_bloc.dart';
import 'package:njia/constants/app_constants.dart';
import 'package:njia/widgets/bottom_nav_bar.dart';
import 'package:njia/widgets/location_result_box.dart';
import 'package:njia/widgets/mapUserBadge.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:njia/models/new.dart';

class SuspectMap extends StatefulWidget {
  SuspectMap({Key? key}) : super(key: key);

  @override
  State<SuspectMap> createState() => _SuspectMapState();
}

class _SuspectMapState extends State<SuspectMap> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType currentMapType = MapType.normal;
  late bool serviceEnabled;
  late StreamSubscription locationSubscription;
  final _liveClassController = StreamController<ApplicationBloc>.broadcast();
  final Map<String, Marker> _markers = {};
  // final suspectLocationsBox = Hive.openBox('suspectLocations');

  Future<void> getMarkers() async {
    final suspectLocationsBox = await Hive.openBox('suspectLocations');
    final googleOffices =
        await getGoogleOffices(suspectLocationsBox.get('locationsJson'));
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.url),
          position: LatLng(office.latitude, office.longitude),
          infoWindow: InfoWindow(
            title: office.county,
            snippet: office.constituency,
          ),
        );
        _markers[office.url] = marker;
      }
      print('off${googleOffices.offices}');
      print('gotMarkers');
    });
  }

  @override
  void initState() {
    getMarkers();
    print('letsgo2');
    // _onMapCreated;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(1.2921, 36.8219),
                      tilt: 59.440717697143555,
                      zoom: 4.4746,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: _markers.values.toSet(),
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
}
