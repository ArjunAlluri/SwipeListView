import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapViews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MapViewsState();
  }
}

class MapViewsState extends State<MapViews> {
  static Position finalposition;
  initState() {
    super.initState();

    allmarkers.add(Marker(
        markerId: MarkerId('mymarker'),
        position: LatLng(finalposition.latitude, finalposition.longitude)));
  }

  List<Marker> allmarkers = [];

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Location"),
        ),
        body: GoogleMap(
          markers: Set.from(allmarkers),
          initialCameraPosition: CameraPosition(
              zoom: 11,
              target: LatLng(finalposition.latitude, finalposition.longitude)),
        ),
      ),
    );
  }
}
