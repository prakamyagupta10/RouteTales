import 'package:latlong2/latlong.dart';

class RouteModel {
  final List<LatLng> points;
  final double distance;
  final double duration;

  RouteModel({
    required this.points,
    required this.distance,
    required this.duration,
  });
}