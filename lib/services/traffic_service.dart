import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:c3_4_maps_app/services/services.dart';
import 'package:c3_4_maps_app/models/models.dart' show Feature, PlacesResponse, TrafficResponse;

class TrafficService {

  final Dio _dioTraffic;
  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  final Dio _dioPlaces;
  final String _basePlacesUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  TrafficService()
    : _dioTraffic = Dio()..interceptors.add( TrafficInterceptor() ),
      _dioPlaces = Dio()..interceptors.add( PlacesInterceptor() );

  Future<TrafficResponse> getCoorsStartToEnd( LatLng start, LatLng end ) async {
    final String coorsString = '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseTrafficUrl/driving/$coorsString';

    final response = await _dioTraffic.get( url );

    final trafficResponse = TrafficResponse.fromMap(response.data);

    return trafficResponse;
  }

  Future<List<Feature>> getPlacesByQuery( LatLng proximity, String query ) async {
    if( query.isEmpty ) return [];

    final url = '$_basePlacesUrl/$query.json';

    final response = await _dioPlaces.get( url, queryParameters: {
      'proximity' : '${proximity.longitude},${proximity.latitude}',
      'limit'     : 7,
    } );

    final placesResponse = PlacesResponse.fromMap( response.data );

    return placesResponse.features;
  }

  Future<Feature> getPlaceByCoors( LatLng coors ) async {
    final url = '$_basePlacesUrl/${ coors.longitude },${ coors.latitude }.json';
    final response = await _dioPlaces.get( url, queryParameters: {
      'limit': 1,
    } );

    final placesResponse = PlacesResponse.fromMap( response.data );

    return placesResponse.features.first;
  }

}