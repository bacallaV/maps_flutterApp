import 'package:c3_4_maps_app/ui/ui.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:c3_4_maps_app/blocs/blocs.dart';

class ButtonCurrentLocation extends StatelessWidget {
  const ButtonCurrentLocation ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only( bottom: 10 ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: const Icon( Icons.my_location_outlined, color: Colors.black ),
          onPressed: () {

            final userLocation = locationBloc.state.lastKnownLocation;

            if( userLocation == null ) {
              ScaffoldMessenger.of(context).showSnackBar( CustomSnackBar(
                message: 'No hay ubicación',
              ));

              return;
            }

            mapBloc.moveCamera( userLocation );

          },
        ),
      ),
    );
  }
}