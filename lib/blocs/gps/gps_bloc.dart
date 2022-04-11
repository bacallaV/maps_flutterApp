import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart' as perm;

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {

  late StreamSubscription gpsServiceSubscription;

  GpsBloc() : super( const GpsState( isGpsEnabled: false, isGpsPermissionGranted: false ) ) {

    on<GpsAndPermissionEvent>((event, emit) {
      emit( state.copyWith(
        isGpsEnabled: event.isGpsEnabled,
        isGpsPermissionGranted: event.isGpsPermissionGranted,
      ) );
    });

    _init();

  }

  Future<void> _init() async {
    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted()
    ]);

    add( GpsAndPermissionEvent(
      isGpsEnabled: gpsInitStatus[0],
      isGpsPermissionGranted: gpsInitStatus[1]
    ));
  }

  Future<bool> _checkGpsStatus() async {
    final isEnabled = await geo.Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription = geo.Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = ( event == geo.ServiceStatus.enabled ) ? true : false;

      add( GpsAndPermissionEvent(
        isGpsEnabled: isEnabled,
        isGpsPermissionGranted: state.isGpsPermissionGranted
      ));
    });

    return isEnabled;
  }

  Future<bool> _isPermissionGranted() async {
    return await perm.Permission.location.isGranted;
  }

  Future<void> askGpsAccess() async {
    final status = await perm.Permission.location.request();

    switch( status ) {
      
      case perm.PermissionStatus.granted:
        add( GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isGpsPermissionGranted: true,
        ));
        break;

      case perm.PermissionStatus.denied:
      case perm.PermissionStatus.restricted:
      case perm.PermissionStatus.limited:
      case perm.PermissionStatus.permanentlyDenied:
        add( GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isGpsPermissionGranted: false,
        ));
        perm.openAppSettings();
    }
  }

  @override
  Future<void> close() {
    // Limpiar el ServiceStatusStream
    gpsServiceSubscription.cancel();
    return super.close();
  }
}
