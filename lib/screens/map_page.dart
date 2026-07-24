import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/geocoding_service.dart';

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
  Position? currentPosition;
  LatLng? destinationPosition;
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

      setState(() {
        currentPosition = position;
        destinationPosition = destination;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
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
              options: MapOptions(
                initialCenter: LatLng(
                  currentPosition!.latitude,
                  currentPosition!.longitude,
                ),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                  'com.example.routetales_web',
                ),

                MarkerLayer(
                  markers: [
                    // Current Location
                    Marker(
                      point: LatLng(
                        currentPosition!.latitude,
                        currentPosition!.longitude,
                      ),
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),

                    // Destination
                    if (destinationPosition != null)
                      Marker(
                        point: destinationPosition!,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.flag,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
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