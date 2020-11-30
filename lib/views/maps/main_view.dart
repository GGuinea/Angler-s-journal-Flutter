import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';

class FishingMap extends StatefulWidget {
  @override
  _FishingMapState createState() => _FishingMapState();
}

class _FishingMapState extends State<FishingMap> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(0, 0);
  PermissionStatus permisison;

  void _getPermission() async {
    permisison = await LocationPermissions().requestPermissions();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    _getPermission();
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapy'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
        ),
      ),
    );
  }
}
