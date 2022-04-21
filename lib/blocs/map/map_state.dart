part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoute;

  // Polylinea
  final Map<String, Polyline> polylines;

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.polylines = const {},
    this.showMyRoute = true,
  });

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    Map<String, Polyline>? polylines,
    bool? showMyRoute,
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isFollowingUser: isFollowingUser ?? this.isFollowingUser,
    polylines: polylines ?? this.polylines,
    showMyRoute: showMyRoute ?? this.showMyRoute,
  );
  
  @override
  List<Object> get props => [ isMapInitialized, isFollowingUser, polylines, showMyRoute ];
}
