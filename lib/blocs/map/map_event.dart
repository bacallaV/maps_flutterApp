part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController mapController;

  const OnMapInitializedEvent(this.mapController);

}

class OnStartFollowingUserMapEvent extends MapEvent {}
class OnStopFollowingUserMapEvent extends MapEvent {}

class UpdateUserPolylineMapEvent extends MapEvent {
  final List<LatLng> userLocations;

  const UpdateUserPolylineMapEvent(this.userLocations);
}

class OnToggleShowRouteMapEvent extends MapEvent {}

class DisplayPolylineMapEvent extends MapEvent {
  final Map<String, Polyline> polylines;

  const DisplayPolylineMapEvent(this.polylines);
}