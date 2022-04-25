import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import 'package:c3_4_maps_app/models/models.dart' show Feature;

class RouteDestination {

  final List<LatLng> points;
  final double duration;
  final double distance;
  final Feature endPlace;

  RouteDestination({
    required this.points,
    required this.duration,
    required this.distance,
    required this.endPlace,
  });

}