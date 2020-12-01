import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:maps_launcher/maps_launcher.dart';

class FishingMap extends StatefulWidget {
  @override
  _FishingMapState createState() => _FishingMapState();
}

class _FishingMapState extends State<FishingMap> {
  final _key = GlobalKey<GoogleMapStateBase>();
  PermissionStatus permisison;
  Set<Marker> _markers = Set();
  Geolocator _geolocator = Geolocator();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String title = "";
  String description = "";

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapy'),
      ),
      body: Stack(
        children: [
          GoogleMap(
              key: _key,
              initialPosition: GeoCoord(50.50, 18.18),
              markers: _markers,
              interactive: true,
              initialZoom: 2,
              mobilePreferences: MobileMapPreferences(
                myLocationEnabled: true,
                mapToolbarEnabled: true,
              ),
              onLongPress: (markerId) async {
                await showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: Text(
                        "Dodaj ciekawe miejsce, mozesz pozniej je udostepnic"),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: "Nazwa",
                                ),
                                controller: _titleController,
                                onChanged: _titleChanged,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: "Opis",
                                ),
                                controller: _descriptionController,
                                onChanged: _descriptionChanged,
                              ),
                            ],
                          )),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  Marker newMarker = Marker(
                                    markerId,
                                    info: title,
                                    infoSnippet: description,
                                    onTap: _onMarkerTap,
                                  );
                                  _markers.add(newMarker);
                                  GoogleMap.of(_key).addMarker(newMarker);
                                });
                                print(_markers.length);
                                Navigator.of(context).pop();
                              },
                              child: Text("Dodaj"),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Anuluj"),
                            ),
                          ]),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  _onMarkerTap(String str) async {
    print(str);
    var splittedString = str.substring(9, str.length - 1).split(", ");
    GeoCoord geoCoord = GeoCoord(
        double.parse(splittedString[0]), double.parse(splittedString[1]));
    Marker tappedMarker =
        _markers.firstWhere((marker) => marker.position == geoCoord);
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(tappedMarker.info),
        children: [
          Column(
            children: [
              Text(tappedMarker.infoSnippet),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _markers.remove(tappedMarker);
                        GoogleMap.of(_key).removeMarker(geoCoord);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Usun"),
                  ),
                  FlatButton(
                    onPressed: () {
                      MapsLauncher.launchCoordinates(
                          tappedMarker.position.latitude,
                          tappedMarker.position.longitude);
                    },
                    child: Text("Pokaz droge"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Anuluj"),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      GoogleMap.of(_key)
          .moveCamera(GeoCoord(position.latitude, position.longitude));
    }).catchError((e) {
      print(e);
    });
  }

  void _titleChanged(String value) {
    setState(() {
      title = value;
    });
  }

  void _descriptionChanged(String value) {
    setState(() {
      description = value;
    });
  }
}
