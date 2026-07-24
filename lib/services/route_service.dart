import 'dart:convert';
import '../models/route_model.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../constants/api_keys.dart';

class RouteService {
  Future<RouteModel> getRoute(
      LatLng start,
      LatLng end,
      ) async {
    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car/geojson",
    );

    final response = await http.post(
      url,
      headers: {
        "Authorization": ApiKeys.openRouteServiceApiKey,
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "coordinates": [
          [start.longitude, start.latitude],
          [end.longitude, end.latitude]
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final coordinates =
      data["features"][0]["geometry"]["coordinates"];

      final summary =
      data["features"][0]["properties"]["segments"][0];

      List<LatLng> route = [];

      for (var point in coordinates) {
        route.add(
          LatLng(
            point[1].toDouble(),
            point[0].toDouble(),
          ),
        );
      }

      return RouteModel(
        points: route,
        distance: summary["distance"].toDouble(),
        duration: summary["duration"].toDouble(),
      );
    } else {
      throw Exception("Failed to fetch route");
    }
  }
}