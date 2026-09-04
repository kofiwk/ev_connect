import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
Position? _currentPosition;
bool _isLoadingLocation = true;
String? _locationError;

Future<void> _getCurrentLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        _locationError = 'Location services are disabled.';
        _isLoadingLocation = false;
      });
      return;
    }

    // Permission has already been checked above; no need to repeat it.

    LocationPermission permission = 
      await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        setState(() {
          _locationError = 'Location permissions are denied.';
          _isLoadingLocation = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationError = 'Location permissions are permanently denied.';
        _isLoadingLocation = false;
      });
      return;
    }

    final position  = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    if (!mounted) return;

    setState(() {
      _currentPosition = position;
      _isLoadingLocation = false;
    });

    debugPrint(
      'Current location: ${position.latitude}, ${position.longitude}'
    );
  } catch (e) {
    if (!mounted) return;
    setState(() {
      _locationError = e.toString();
      _isLoadingLocation = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    // Accra's approximate centre coordinates
    const accra = LatLng(5.6037, -0.1870);
    return Scaffold(
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: accra,
          initialZoom: 12.5
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.ev_connect',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: const LatLng(5.6050, -0.1870),
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.ev_station,
                  color: Colors.green,
                  size: 42,
                )
              ),
              Marker(
                point: const LatLng(5.5780, -0.2080),
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.ev_station,
                  color: Colors.green,
                  size: 42,
                )
              ),
            ]
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors', 
              ),
            ]
          )
        ]
      ),
    );
  }
}