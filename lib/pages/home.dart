import 'dart:async';

import 'package:ev_connect/components/app_menu_drawer.dart';
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
  final MapController _mapController = MapController();

  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  bool _mapReady = false;

  int _selectedNavIndex = 0;

  // Accra fallback location
  static const LatLng _accra = LatLng(5.6037, -0.1870);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ============================================================
  // LOCATION
  // ============================================================

  Future<void> _getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
      });

      debugPrint(
        'Current location: '
        '${position.latitude}, ${position.longitude}',
      );

      _moveToCurrentLocation();
      _startLocationTracking();
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  void _startLocationTracking() {
    _positionStream?.cancel();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            if (!mounted) return;

            setState(() {
              _currentPosition = position;
            });
          },
          onError: (error) {
            debugPrint('Location stream error: $error');
          },
        );
  }

  void _moveToCurrentLocation() {
    if (!_mapReady || _currentPosition == null) {
      return;
    }

    final location = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    _mapController.move(location, 15.0);
  }

  void _onMapReady() {
    setState(() {
      _mapReady = true;
    });

    if (_currentPosition != null) {
      _moveToCurrentLocation();
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // ======================================================
          // MAP
          // ======================================================
          FlutterMap(
            mapController: _mapController,

            options: MapOptions(
              initialCenter: _accra,
              initialZoom: 12.5,
              onMapReady: _onMapReady,
            ),

            children: [
              // ==================================================
              // OPEN STREET MAP
              // ==================================================
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/'
                    '{z}/{x}/{y}.png',

                userAgentPackageName: 'com.example.ev_connect',
              ),

              // ==================================================
              // USER LOCATION
              // ==================================================
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),

                      width: 70,
                      height: 70,

                      child: const UserLocationMarker(),
                    ),
                  ],
                ),

              // ==================================================
              // MAP ATTRIBUTION
              // ==================================================
              RichAttributionWidget(
                attributions: [TextSourceAttribution('OpenStreetMap')],
              ),
            ],
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: IconButton(onPressed: () {
                     AppMenuDrawer();
                  },
                    icon: Icon(Icons.menu_rounded)
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade50,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                         
                        },
                        icon: Icon(Icons.location_on_outlined, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for stations here',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // BOTTOM NAVIGATION
          // ======================================================
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,

            child: SafeArea(
              child: BottomNavigation(
                selectedIndex: _selectedNavIndex,

                onChanged: (index) {
                  setState(() {
                    _selectedNavIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}

// =================================================================
// USER LOCATION MARKER
// =================================================================

class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 48,

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.withOpacity(0.15),
        ),

        child: Center(
          child: Container(
            width: 19,
            height: 19,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.black,

              border: Border.all(color: Colors.white, width: 3),

              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =================================================================
// BOTTOM NAVIGATION
// =================================================================

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),

            blurRadius: 15,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          // HOME / MAP
          NavItem(
            icon: Icons.map_outlined,
            label: 'Map',

            selected: selectedIndex == 0,

            onTap: () {
              onChanged(0);
            },
          ),

          // HISTORY
          NavItem(
            icon: Icons.history_toggle_off_sharp,
            label: 'History',

            selected: selectedIndex == 1,

            onTap: () {
              onChanged(1);
            },
          ),

          // TRIPS
          NavItem(
            icon: Icons.receipt_long_outlined,

            label: 'Trips',

            selected: selectedIndex == 2,

            onTap: () {
              onChanged(2);
            },
          ),

          // ACCOUNT
          NavItem(
            icon: Icons.person_outline,

            label: 'Account',

            selected: selectedIndex == 3,

            onTap: () {
              onChanged(3);
            },
          ),
        ],
      ),
    );
  }
}

// =================================================================
// NAV ITEM
// =================================================================

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      behavior: HitTestBehavior.opaque,

      child: SizedBox(
        width: 70,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 23, color: selected ? Colors.black : Colors.grey),

            const SizedBox(height: 3),

            Text(
              label,

              style: TextStyle(
                fontSize: 10,

                fontWeight: selected ? FontWeight.bold : FontWeight.normal,

                color: selected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
