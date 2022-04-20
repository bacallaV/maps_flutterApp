import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c3_4_maps_app/blocs/blocs.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {

  final LatLng initialLocation;

  const MapView ({
    Key? key,
    required this.initialLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    final initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 15,
    );

    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        compassEnabled: false,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (controller) => mapBloc.add( OnMapInitializedEvent( controller ) ),
      ),
    );
  }
}