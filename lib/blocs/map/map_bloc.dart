import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' show CameraUpdate, GoogleMapController, LatLng;

import 'package:c3_4_maps_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  GoogleMapController? _mapController;

  MapBloc() : super( const MapState() ) {

    on<OnMapInitializedEvent>( _onInitMap );

  }

  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit ) {
    _mapController = event.mapController;

    _mapController!.setMapStyle( jsonEncode( uberMapTheme ) );

    emit( state.copyWith( isMapInitialized: true ) );
  }

  void moveCamera( LatLng toLocation ) {
    _mapController?.animateCamera( CameraUpdate.newLatLng( toLocation ));
  }

}
