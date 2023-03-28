import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location_screen';

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  // Declare Location outside of methods
  Location location = Location();

  // Add this method to request location service and permission
  Future<void> _checkLocationServiceAndPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      _locationData = await location.getLocation();
      setState(() {});
    } catch (e) {
      print('Could not get location: $e');
    }
  }

  late GoogleMapController _controller;

  final LatLng _center = const LatLng(45.5231, -122.6765);

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;

    // Call _checkLocationServiceAndPermission before _getCurrentLocation
    await _checkLocationServiceAndPermission();
    await _getCurrentLocation();

    if (_locationData != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _locationData.latitude!,
            _locationData.longitude!,
          ),
          zoom: 14.0,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        myLocationEnabled: true, // Add this to enable my location button
      ),
    );
  }
}
