import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:njia/constants/app_constants.dart';
import 'package:njia/models/suspect.dart';
import 'package:njia/models/suspect_location_model.dart';
import 'package:njia/services/suspect_service.dart';
import 'package:njia/widgets/bottom_nav_bar.dart';

class SuspectPage extends StatefulWidget {
  SuspectPage({Key? key}) : super(key: key);

  @override
  State<SuspectPage> createState() => _SuspectPageState();
}

class _SuspectPageState extends State<SuspectPage> {
  List<Suspect>? suspects;
  var isLoaded = false;
  var hasLocations = false;


  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    suspects = await SuspectService().getSuspects();
    if (suspects != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  Future locate(String search) async {
    final suspectLocationsBox = await Hive.openBox('suspectLocations');
    final loginCredentials = await Hive.openBox('logindata');
    var token = loginCredentials.get('token');
    var url = Uri.parse("$baseUrl/locations/?search=$search");
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
    );
    var jsonData = jsonDecode(response.body);
    suspectLocationsBox.put('locationsJson', search);
    print(suspectLocationsBox.get('locationsJson'));
    if (jsonData['locations'].isNotEmpty) {
      setState(() {
        hasLocations = !hasLocations;
      });
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Suspects",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: mainHexColor,
      body: (isLoaded == false)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView.builder(
                  itemCount: suspects?.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (() async {
                        await locate(suspects![index].name);
                        if (hasLocations) {
                          Navigator.popAndPushNamed(context, '/suspect_map');
                        } else {
                          Fluttertoast.showToast(
                              msg: "${suspects![index].name} Not found yet",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 94, 87, 87),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }),
                      child: Card(
                        elevation: 10.5,
                        color: Color.fromARGB(255, 219, 219, 226),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                              title: Row(
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(60 / 2),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        NetworkImage(suspects![index].mugshot),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          140,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: suspects![index].name,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    suspects![index].charges.toString(),
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 66, 65, 65)),
                                  ),
                                ],
                              )
                            ],
                          )),
                        ),
                      ),
                    );
                  }),
            ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

// List<SuspectLocation> suspectLocationFromJson(String str) =>
//     List<SuspectLocation>.from(
//         json.decode(str).map((x) => SuspectLocation.fromJson(x)));

// String suspectLocationToJson(List<SuspectLocation> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SuspectLocation {
  final String url, latitude, longitude;

  SuspectLocation(
    this.url,
    this.latitude,
    this.longitude,
  );

  // factory SuspectLocation.fromJson(Map<String, dynamic> json) =>
  //     SuspectLocation(
  //       url: json["url"],
  //       latitude: json["latitude"],
  //       longitude: json["longitude"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "url": url,
  //       "latitude": latitude,
  //       "longitude": longitude,
  //     };
}
