import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' show CameraUpdate, Cap, GoogleMapController, LatLng, Polyline, PolylineId;

import 'package:c3_4_maps_app/themes/themes.dart';
import 'package:c3_4_maps_app/blocs/blocs.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  StreamSubscription<LocationState>? locationStream;

  MapBloc({
    required this.locationBloc
  }) : super( const MapState() ) {

    on<OnMapInitializedEvent>( _onInitMap );
    on<OnStartFollowingUserMapEvent>( _onStartFollowing );
    on<OnStopFollowingUserMapEvent>( (event, emit) => emit( state.copyWith( isFollowingUser: false ) ) );
    on<UpdateUserPolylineMapEvent>( _onPolylineNewPoint );
    on<OnToggleShowRouteMapEvent>( (event, emit) => emit( state.copyWith( showMyRoute: !state.showMyRoute ) ) );

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
  
  void _onPolylineNewPoint( UpdateUserPolylineMapEvent event, Emitter<MapState> emit ) {
    final myRoute = Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.black87,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations,
    );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines['myRoute'] = myRoute;

    emit( state.copyWith( polylines: currentPolylines ) );
  }

  void moveCamera( LatLng toLocation ) {
    _mapController?.animateCamera( CameraUpdate.newLatLng( toLocation ));
  }

  @override
  Future<void> close() {
    locationStream?.cancel();
    return super.close();
  }

}
