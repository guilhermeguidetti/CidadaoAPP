import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:app_cidadao/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  List polygonList = await getZoneCoordinates();
  List polygonMarkers = await getZoneMarkers();
  runApp(MyApp(polygonList, polygonMarkers));
}

class MyApp extends StatelessWidget {
  final polygonList, polygonMarkers;
  const MyApp(this.polygonList, this.polygonMarkers, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(polygonList, polygonMarkers),
    );
  }
}

Future<List> getZoneMarkers() async {
  List<List> polygonMarkersList = [];
  List<LatLng> polygonMarkers = [];
  List<LatLng> polygonMarkers2 = [];
  List<LatLng> polygonMarkers3 = [];
  final result =
  await FirebaseFunctions.instanceFor(region: "southamerica-east1")
      .httpsCallable('getZonesInfo')
      .call();
  for (var item in result.data[0]["markers"]) {
    polygonMarkers.add(LatLng(item["_latitude"], item["_longitude"]));
  }
  for (var item in result.data[1]["markers"]) {
    polygonMarkers2.add(LatLng(item["_latitude"], item["_longitude"]));
  }
  for (var item in result.data[2]["markers"]) {
    polygonMarkers3.add(LatLng(item["_latitude"], item["_longitude"]));
  }
  polygonMarkersList.add(polygonMarkers);
  polygonMarkersList.add(polygonMarkers2);
  polygonMarkersList.add(polygonMarkers3);
  return polygonMarkersList;
}

Future<List> getZoneCoordinates() async {
  List<List> polygonList = [];
  List<LatLng> polygonMarkers = [];
  List<LatLng> polygonMarkers2 = [];
  List<LatLng> polygonMarkers3 = [];
  final result =
      await FirebaseFunctions.instanceFor(region: "southamerica-east1")
          .httpsCallable('getZonesCoordinates')
          .call();
  for (var item in result.data[0]["points"]) {
    polygonMarkers.add(LatLng(item["_latitude"], item["_longitude"]));
  }
  for (var item in result.data[1]["points"]) {
    polygonMarkers2.add(LatLng(item["_latitude"], item["_longitude"]));
  }
  for (var item in result.data[2]["points"]) {
    polygonMarkers3.add(LatLng(item["_latitude"], item["_longitude"]));
  }
  polygonList.add(polygonMarkers);
  polygonList.add(polygonMarkers2);
  polygonList.add(polygonMarkers3);
  return polygonList;
}
