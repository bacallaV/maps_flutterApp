import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

import 'package:c3_4_maps_app/services/services.dart';
import 'package:c3_4_maps_app/models/models.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  TrafficService trafficService;

  SearchBloc({
    required this.trafficService,
  }) : super( const SearchState() ) {

    on<OnActivateManualMarkerEvent>( (event, emit) => emit( state.copyWith( displayManualMarker: true ) ) );
    on<OnDeactivateManualMarkerEvent>( (event, emit) => emit( state.copyWith( displayManualMarker: false ) ) );
  
  }

  Future<RouteDestination> getCoorsStartToEnd( LatLng start, LatLng end ) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd( start, end );

    // Decodificar Geometry
    final points = decodePolyline( trafficResponse.routes[0].geometry, accuracyExponent: 6 ); // accuaracyExponent es 6 porque MapBox trabaja con 6 decimales.

    final latLngList = points.map( (coor) => LatLng( coor[0].toDouble(), coor[1].toDouble() ) ).toList();

    return RouteDestination(
      points: latLngList,
      duration: trafficResponse.routes[0].duration,
      distance: trafficResponse.routes[0].distance
    );
  }

}