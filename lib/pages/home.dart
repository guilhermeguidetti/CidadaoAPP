import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:app_cidadao/pages/zone_info.dart';
import 'package:location/location.dart';

class MyApp extends StatelessWidget {
  final polygonList, polygonMarkers;
  const MyApp(this.polygonList, this.polygonMarkers);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluezone',
      home: MapSample(polygonList, polygonMarkers),
    );
  }
}

class MapSample extends StatefulWidget {
  final polygonList, polygonMarkers;
  const MapSample(this.polygonList, this.polygonMarkers);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<LatLng> polylineList = [];

  double latitude_data = -22.91245337996965;
  double longitude_data = -47.063394680217264;
  bool _serviceEnabled = true;
  int zoneId = 0;

  Future<void> _getLocation() async {
    Location location = Location();

    var _permissionGranted = await location.hasPermission();
    _serviceEnabled = await location.serviceEnabled();

    if (_permissionGranted != PermissionStatus.granted || !_serviceEnabled) {
      _permissionGranted = await location.requestPermission();

      _serviceEnabled = await location.requestService();

      LocationData _currentPosition = await location.getLocation();
      setState(() {
        longitude_data = _currentPosition.longitude!;
        latitude_data = _currentPosition.latitude!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
    List<LatLng> polylineList2;
  }

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-22.91245337996965, -47.063394680217264),
    zoom: 12.999,
  );

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    final Polygon _taquaral = Polygon(
        polygonId: const PolygonId('_kPolyline'),
        consumeTapEvents: true,
        points: widget.polygonList[0],
        strokeWidth: 4,
        strokeColor: Colors.deepPurple,
        onTap: () {
          zoneId = 1;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ZoneInfoPage(zoneId, title: "Zona Azul Taquaral")),
          );
        },
        fillColor: Colors.blue.withOpacity(0.5));
    final Polygon _cambui = Polygon(
        polygonId: const PolygonId('_kPolyline2'),
        consumeTapEvents: true,
        points: widget.polygonList[2],
        onTap: () {
          zoneId = 2;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ZoneInfoPage(zoneId, title: "Zona Azul Cambuí")),
          );
        },
        strokeWidth: 4,
        strokeColor: Colors.redAccent,
        fillColor: Colors.orangeAccent.withOpacity(0.5));

    final Polygon _pontePreta = Polygon(
        polygonId: const PolygonId('_pontePreta'),
        consumeTapEvents: true,
        points: widget.polygonList[1],
        onTap: () {
          zoneId = 0;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ZoneInfoPage(zoneId, title: "Zona Azul Ponte Preta")),
          );
        },
        strokeWidth: 4,
        strokeColor: Colors.black54,
        fillColor: Colors.black54.withOpacity(0.5));
    List<Marker> _markers = <Marker>[];
    _markers.add(
      Marker(
          markerId: const MarkerId('1'),
          position: widget.polygonMarkers[0][0],
          infoWindow: const InfoWindow(
            title: 'Apaloosas Churrascaria',
          )),
    );
    _markers.add(
      Marker(
          markerId: const MarkerId('2'),
          position: widget.polygonMarkers[0][1],
          infoWindow: const InfoWindow(
            title: 'Farmácia de Alto Custo',
          )),
    );
    _markers.add(
      Marker(
          markerId: const MarkerId('3'),
          position: widget.polygonMarkers[0][2],
          infoWindow: const InfoWindow(
            title: 'Discamp',
          )),
    );
    _markers.add(
      Marker(
          markerId: const MarkerId('4'),
          position: widget.polygonMarkers[1][0],
          infoWindow: const InfoWindow(
            title: 'Farmácia Drogasil',
          )),
    );
    _markers.add(
      Marker(
          markerId: const MarkerId('5'),
          position: widget.polygonMarkers[1][1],
          infoWindow: const InfoWindow(
            title: 'Bar Américo',
          )),
    );
    _markers.add(
      Marker(
          markerId: const MarkerId('6'),
          position: widget.polygonMarkers[1][2],
          infoWindow: const InfoWindow(
            title: 'Restaurante Villani',
          )),
    );
    _markers.add(
      Marker(
          markerId: const MarkerId('6'),
          position: widget.polygonMarkers[2][0],
          infoWindow: const InfoWindow(
            title: 'Macaxeira Campinas',
          )),
    );
    _markers.add(
      Marker(
          markerId: const MarkerId('6'),
          position: widget.polygonMarkers[2][1],
          infoWindow: const InfoWindow(
            title: 'Padaria Croissant D`or',
          )),
    );
    _markers.add(
      Marker(
          markerId: const MarkerId('6'),
          position: widget.polygonMarkers[2][2],
          infoWindow: const InfoWindow(
            title: 'Nakoo Sushi',
          )),
    );
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_markers),
        polygons: {_taquaral, _cambui, _pontePreta},
      ),
      floatingActionButton: Align(
          child: FloatingActionButton(
            onPressed: () {
              _goToTheLake();
              _getLocation();
            },
          ),
          alignment: const Alignment(1, 0.7)),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latitude_data, longitude_data),
        tilt: 49,
        zoom: 14.151926040649414)));
  }
}
