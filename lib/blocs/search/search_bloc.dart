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

    on<OnNewPlacesFoundEvent>( (event, emit) => emit( state.copyWith( places: event.places ) ) );

    on<AddToHistoryEvent>( _onAddToHistory );
  
  }

  void _onAddToHistory ( AddToHistoryEvent event, Emitter<SearchState> emit ) {
    List<Feature> newHistory;

    if( state.history.contains( event.place ) ) {
      List<Feature> historyCopy = [ ...state.history ];
      historyCopy.remove( event.place );
      historyCopy.insert( 0, event.place );

      newHistory = historyCopy;
    } else {
      newHistory = [ event.place, ...state.history ];
    }

      emit ( state.copyWith(
        history: newHistory,
      ));
  }

  Future<RouteDestination> getCoorsStartToEnd( LatLng start, LatLng end ) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd( start, end );

    // Información del destino
    final endPlace = await trafficService.getPlaceByCoors( end );

    // Decodificar Geometry
    final points = decodePolyline( trafficResponse.routes[0].geometry, accuracyExponent: 6 ); // accuaracyExponent es 6 porque MapBox trabaja con 6 decimales.

    final latLngList = points.map( (coor) => LatLng( coor[0].toDouble(), coor[1].toDouble() ) ).toList();

    return RouteDestination(
      points: latLngList,
      duration: trafficResponse.routes[0].duration,
      distance: trafficResponse.routes[0].distance,
      endPlace: endPlace,
    );
  }

  Future getPlacesByQuery( LatLng proximity, String query ) async {
    final newPlaces = await trafficService.getPlacesByQuery( proximity, query );

    add( OnNewPlacesFoundEvent( newPlaces ) );
  }

}
