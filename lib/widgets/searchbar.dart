import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:c3_4_maps_app/models/models.dart';
import 'package:c3_4_maps_app/delegates/delegates.dart';
import 'package:c3_4_maps_app/blocs/blocs.dart';

class SearchBar extends StatelessWidget {
  const SearchBar ({Key? key}) : super(key: key);

  void onSearchResults( BuildContext context, SearchResult searchResult )  async {
    if( searchResult.cancel ) return;

    if( searchResult.manual ) {
      final searchBloc = BlocProvider.of<SearchBloc>(context);
      searchBloc.add( OnActivateManualMarkerEvent() );
    }

    if( searchResult.position != null ) {
      final searchBloc = BlocProvider.of<SearchBloc>(context);
      final locationBloc = BlocProvider.of<LocationBloc>(context);
      final mapBloc = BlocProvider.of<MapBloc>(context);

      final destination = await searchBloc.getCoorsStartToEnd( locationBloc.state.lastKnownLocation!, searchResult.position! );
      await mapBloc.drawRoutePolyline( destination );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only( top: 10 ),
        padding: const EdgeInsets.symmetric( horizontal: 30 ),
        width: double.infinity,
        height: 50,
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 13 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular( 100 ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset( 0, 5 ),
                )
              ]
            ),
            child: const Text(
              '¿Dónde quieres ir?',
              style: TextStyle( color: Colors.black87 ),
            ),
          ),
          onTap: () async {
            final searchResult = await showSearch( context: context, delegate: SearchDestinationDelegate() );

            if( searchResult == null ) return;

            onSearchResults( context, searchResult );
          },
        ),
      ),
    );
  }
}