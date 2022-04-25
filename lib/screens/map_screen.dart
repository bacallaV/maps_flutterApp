import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show Polyline;
import 'package:animate_do/animate_do.dart';

import 'package:c3_4_maps_app/blocs/blocs.dart';
import 'package:c3_4_maps_app/views/views.dart';
import 'package:c3_4_maps_app/widgets/widgets.dart';
import 'package:c3_4_maps_app/helpers/helpers.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final LocationBloc locationBloc;
  late final SearchBloc searchBloc;
  late final MapBloc mapBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    searchBloc = BlocProvider.of<SearchBloc>(context);
    mapBloc = BlocProvider.of<MapBloc>(context);
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnownLocation == null) return const Center(child: Text('Espere por favor...'));

          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);
              if (!mapState.showMyRoute) {
                polylines.removeWhere((key, value) => key == 'myRoute');
              }

            return BlocBuilder<SearchBloc, SearchState>(
              builder: (context, searchState) {

                return SingleChildScrollView(
                  child: Stack(children: [

                    MapView(
                      initialLocation: locationState.lastKnownLocation!,
                      polylines: polylines.values.toSet(),
                      markers: mapState.markers.values.toSet(),
                    ),

                    searchState.displayManualMarker
                      ? ManualMarker(
                          backOnPressed: () => searchBloc.add( OnDeactivateManualMarkerEvent() ),
                          confirmOnPressed: () async {
                            showLoadingMessage(context);
                            
                            await mapBloc.drawRoutePolyline(
                              await searchBloc.getCoorsStartToEnd( locationState.lastKnownLocation!, mapBloc.mapCenter! ) );
                            
                            searchBloc.add( OnDeactivateManualMarkerEvent() );
                            Navigator.pop(context);
                          }
                        )
                      : FadeInDown(
                          duration: const Duration( milliseconds: 300 ),
                          child: const SearchBar()
                        ),

                  ]),
                );
              
              },
            );
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          ButtonToggleRoute(),
          ButtonFollowUser(),
          ButtonCurrentLocation(),
        ],
      ),
    );
  }
}
