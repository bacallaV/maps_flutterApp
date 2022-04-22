import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:c3_4_maps_app/services/services.dart' show TrafficInterceptor;
import 'package:c3_4_maps_app/models/models.dart' show TrafficResponse;

class TrafficService {

  final Dio _dioTraffic;
  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  TrafficService()
    : _dioTraffic = Dio()..interceptors.add( TrafficInterceptor() );

  Future<TrafficResponse> getCoorsStartToEnd( LatLng start, LatLng end ) async {
    final String coorsString = '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseTrafficUrl/driving/$coorsString';

    final response = await _dioTraffic.get( url );

    final trafficResponse = TrafficResponse.fromMap(response.data);

    return trafficResponse;
  }

}