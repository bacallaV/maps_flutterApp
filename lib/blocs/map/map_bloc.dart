import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show BitmapDescriptor, CameraUpdate, Cap, GoogleMapController, InfoWindow, LatLng, Marker, MarkerId, Polyline, PolylineId;

import 'package:c3_4_maps_app/themes/themes.dart';
import 'package:c3_4_maps_app/blocs/blocs.dart';
import 'package:c3_4_maps_app/models/models.dart' show RouteDestination;
import 'package:c3_4_maps_app/helpers/helpers.dart';

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
    on<DisplayPolylineMapEvent>( (event, emit) => emit( state.copyWith( polylines: event.polylines, markers: event.markers ) ) );

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


    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    double tripDuration = ( destination.duration/60 ).floorToDouble();

    final startMarker = Marker(
      markerId: const MarkerId( 'start' ),
      position: destination.points.first,
      // infoWindow: InfoWindow(
      //   title:    'Inicio',
      //   snippet:  'KMs: $kms, duration: $tripDuration',
      // ),
      // icon: await getAssetImageMarker(),
      icon: await getStartCustomMarker( tripDuration.toInt(), 'Inicio' ),
      anchor: const Offset(0.1, 1),
    );
    final endMarker = Marker(
      markerId: const MarkerId( 'end' ),
      position: destination.points.last,
      // infoWindow: InfoWindow(
      //   title:    destination.endPlace.text,
      //   snippet:  destination.endPlace.placeName,
      // ),
      // icon: await getNetworkImageMarker(),
      icon: await getEndCustomMarker( kms.toInt(), destination.endPlace.text ),
    );

    final currentMarkers = Map<String, Marker>.from( state.markers );
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    add( DisplayPolylineMapEvent( currentPolylines, currentMarkers ) );

    await Future.delayed( const Duration(milliseconds: 300) );
    _mapController?.showMarkerInfoWindow( const MarkerId('start') );
  }

  void moveCamera( LatLng toLocation ) {
    _mapController?.animateCamera( CameraUpdate.newLatLng( toLocation ));
  }

  /* Objetos del paquete de Google */
  Polyline _createPolyline( String id, List<LatLng> points ) => Polyline(
    polylineId: PolylineId(id),
    color: Colors.black87,
    width: 5,
    points: points,
    startCap: Cap.roundCap,
    endCap: Cap.roundCap,
  );

  Marker _createMarker({
    required String id,
    required LatLng position,
    required String iwTitle,
    required String iwSnippet,
    BitmapDescriptor? icon
  }) => Marker(
    markerId: MarkerId( id ),
    position: position,
    infoWindow: InfoWindow(
      title: iwTitle,
      snippet: iwSnippet
    ),
    icon: icon ?? BitmapDescriptor.defaultMarker,
  );
  /* Fin de los objetos del paquete de Google */

  @override
  Future<void> close() {
    locationStream?.cancel();
    return super.close();
  }

}
