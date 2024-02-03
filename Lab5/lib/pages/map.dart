import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:lab3/models/Exam.dart';

class MapPage extends StatefulWidget {
  final List<Exam> exams;

  MapPage({Key? key, required this.exams}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = Set();
  Set<Marker> _markers = {};
  LatLng? _userLocation;
  String googleAPIKey = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _createMarkers();
  }

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.denied && permission != LocationPermission.deniedForever) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location permission is not granted")));
    }
  }

  void _createMarkers() {
    widget.exams.forEach((exam) {
      _markers.add(Marker(
        markerId: MarkerId(exam.name),
        position: LatLng(exam.latitude, exam.longitude),
        infoWindow: InfoWindow(title: exam.name),
        onTap: () {
          findShortestPathToExam(LatLng(exam.latitude, exam.longitude));
        },
      ));
    });
  }

  Future<void> findShortestPathToExam(LatLng examLocation) async {
    final Position currentPosition = await getUserCurrentLocation();
    final LatLng currentLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
    final List<LatLng>? points = await getDirections(currentLocation, examLocation);
    if (points != null) {
      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId("poly_${DateTime.now().millisecondsSinceEpoch}"),
          color: Colors.blue,
          points: points,
          width: 5,
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No route found")));
    }
  }

  Future<Position> getUserCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<LatLng>?> getDirections(LatLng origin, LatLng destination) async {
    final String apiUrl = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<LatLng> points = PolylinePoints().decodePolyline(data['routes'][0]['overview_polyline']['points'])
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      return points;
    } else {
      print('Error getting directions: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Map Page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _determinePosition,
            ),
          ],
        ),
        body: GoogleMap(
        initialCameraPosition: CameraPosition(
        target: _userLocation ?? LatLng(42.00478491557928, 21.40917442067392),
    zoom: 14,
    ),
    markers: _markers,
    polylines: _polylines,
    myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
    );
  }
}
