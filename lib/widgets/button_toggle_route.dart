import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:c3_4_maps_app/blocs/blocs.dart';

class ButtonToggleRoute extends StatelessWidget {
  const ButtonToggleRoute ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only( bottom: 10 ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                state.showMyRoute ? Icons.dnd_forwardslash_outlined : Icons.route,
                color: Colors.black
              ),
              onPressed: () => mapBloc.add( OnToggleShowRouteMapEvent() ),
            );
          }
        ),
      ),
    );
  }
}