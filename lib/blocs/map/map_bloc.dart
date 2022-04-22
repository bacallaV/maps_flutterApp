import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show CameraUpdate, Cap, GoogleMapController, LatLng, Polyline, PolylineId;

import 'package:c3_4_maps_app/themes/themes.dart';
import 'package:c3_4_maps_app/blocs/blocs.dart';
import 'package:c3_4_maps_app/models/models.dart' show RouteDestination;

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  StreamSubscription<LocationState>? locationStream;
  LatLng? mapCenter;

  MapBloc({
    required this.locationBloc
  }) : super( const MapState() ) {

    on<OnMapInitializedEvent>( _onInitMap );
    on<OnStartFollowingUserMapEvent>( _onStartFollowing );
    on<OnStopFollowingUserMapEvent>( (event, emit) => emit( state.copyWith( isFollowingUser: false ) ) );
    on<UpdateUserPolylineMapEvent>( _onUserPolyline );
    on<OnToggleShowRouteMapEvent>( (event, emit) => emit( state.copyWith( showMyRoute: !state.showMyRoute ) ) );
    on<DisplayPolylineMapEvent>( (event, emit) => emit( state.copyWith( polylines: event.polylines ) ) );

    locationStream = locationBloc.stream.listen( ( locationState ) {
      if( locationState.lastKnownLocation == null ) return;

      add( UpdateUserPolylineMapEvent( locationState.myLocationHistory ) );

      if( !state.isFollowingUser ) return;

      moveCamera( locationState.lastKnownLocation! );
    });

  }

  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit ) {
    _mapController = event.mapController;

    _mapController!.setMapStyle( jsonEncode( uberMapTheme ) );

    emit( state.copyWith( isMapInitialized: true ) );
  }

  void _onStartFollowing( OnStartFollowingUserMapEvent event, Emitter<MapState> emit ) {
    emit( state.copyWith( isFollowingUser: true ) );

    if( locationBloc.state.lastKnownLocation == null ) return;
    
    moveCamera( locationBloc.state.lastKnownLocation! );
  }
  
  void _onUserPolyline( UpdateUserPolylineMapEvent event, Emitter<MapState> emit ) {
    final myRoute = _createPolyline( 'myRoute', event.userLocations );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines['myRoute'] = myRoute;

    emit( state.copyWith( polylines: currentPolylines ) );
  }

  Future drawRoutePolyline( RouteDestination destination ) async {
    final route = _createPolyline( 'route', destination.points );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines['route'] = route;

    add( DisplayPolylineMapEvent( currentPolylines ) );
  }

  void moveCamera( LatLng toLocation ) {
    _mapController?.animateCamera( CameraUpdate.newLatLng( toLocation ));
  }

  Polyline _createPolyline( String id, List<LatLng> points ) => Polyline(
    polylineId: PolylineId(id),
    color: Colors.black87,
    width: 5,
    points: points,
    startCap: Cap.roundCap,
    endCap: Cap.roundCap,
  );

  @override
  Future<void> close() {
    locationStream?.cancel();
    return super.close();
  }

}
