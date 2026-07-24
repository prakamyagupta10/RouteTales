import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/geocoding_service.dart';
import '../services/route_service.dart';

import '../services/location_service.dart';

class MapPage extends StatefulWidget {
  final String destination;

  const MapPage({
    super.key,
    required this.destination,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LocationService _locationService = LocationService();
  final GeocodingService _geocodingService = GeocodingService();
  final MapController _mapController = MapController();
  Position? currentPosition;
  LatLng? destinationPosition;

  List<LatLng> routePoints = [];

  final RouteService _routeService = RouteService();
  bool isLoading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      // Get current location
      Position position = await _locationService.getCurrentLocation();

      // Get destination coordinates
      LatLng? destination = await _geocodingService.getCoordinates(
        widget.destination,
      );
      List<LatLng> route = [];

      if (destination != null) {
        route = await _routeService.getRoute(
          LatLng(position.latitude, position.longitude),
          destination,
        );
      }

      setState(() {
        currentPosition = position;
        destinationPosition = destination;
        routePoints = route;
        isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        fitMapToMarkers();
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
  void fitMapToMarkers() {
    if (currentPosition == null || destinationPosition == null) return;

    final bounds = LatLngBounds(
      LatLng(
        currentPosition!.latitude,
        currentPosition!.longitude,
      ),
      destinationPosition!,
    );

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(60),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Map"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            color: Colors.blue.shade50,
            child: Text(
              "Destination: ${widget.destination}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : error.isNotEmpty
                ? Center(
              child: Text(
                error,
                style: const TextStyle(fontSize: 18),
              ),
            )
                : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  currentPosition!.latitude,
                  currentPosition!.longitude,
                ),
                initialZoom: 15,
              ),
              children: [

                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.routetales_web',
                ),

                // Draw Route
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 5,
                        color: Colors.blue,
                      ),
                    ],
                  ),

                MarkerLayer(
                  markers: [
                    // your current marker code
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}