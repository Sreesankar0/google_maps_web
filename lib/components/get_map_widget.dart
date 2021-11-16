import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart';
import 'package:firebase_database/firebase_database.dart';

Widget getMap() {
  final databaseRef = FirebaseDatabase.instance.reference();

  double currentlatitude = 0.0;
  double currentlongitude = 0.0;

  //A unique id to name the div element
  String htmlId = "6";
  //creates a webview in dart
  //ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    String deviceid = "01c7f25788962d88";
    databaseRef.child(deviceid).once().then((DataSnapshot snapshot) {
      currentlatitude = snapshot.value['latitude'];
      currentlongitude = snapshot.value['longitude'];
    });

    final latLang = LatLng(currentlatitude, currentlongitude);
    //class to create a div element

    final mapOptions = MapOptions()
      ..zoom = 11
      ..tilt = 90
      ..center = latLang;
    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = "none";

    final map = GMap(elem, mapOptions);
    Marker(MarkerOptions()
      ..position = latLang
      ..map = map
      ..title = 'My position');
    //Marker(MarkerOptions()
    // ..position = LatLng(12.9557616, 77.7568832)
    // ..map = map
    // ..title = 'My position');
    return elem;
  });
  //creates a platform view for Flutter Web
  return HtmlElementView(
    viewType: htmlId,
  );
}
