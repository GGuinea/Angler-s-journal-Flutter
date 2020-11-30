import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';

class FishingMap extends StatefulWidget {
  @override
  _FishingMapState createState() => _FishingMapState();
}

class _FishingMapState extends State<FishingMap> {
  static const LatLng _center = const LatLng(50.50, 18.18);

  GoogleMapController mapController;
  PermissionStatus permisison;
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  Geolocator _geolocator = Geolocator();
  Position _currentPosition;

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
            onMapCreated: _onMapCreated,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10.0,
            ),
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(children: [
                FloatingActionButton(
                  onPressed: _onAddMarkerButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.add_location, size: 30),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
