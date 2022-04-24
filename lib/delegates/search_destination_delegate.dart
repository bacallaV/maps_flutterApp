import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import 'package:c3_4_maps_app/blocs/blocs.dart';
import 'package:c3_4_maps_app/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {

  SearchDestinationDelegate():super(
    searchFieldLabel: 'Buscar',
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon( Icons.clear ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon( Icons.arrow_back_ios_new ),
      onPressed: () => close(
        context,
        SearchResult( cancel: true )
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    BlocProvider.of<SearchBloc>(context).getPlacesByQuery(
      BlocProvider.of<LocationBloc>(context).state.lastKnownLocation!,
      query
    );

    return BlocBuilder<SearchBloc, SearchState>(
      builder: ( context, state ) {
        return ListView.separated(
          itemCount: state.places.length,
          separatorBuilder: ( context, i ) => const Divider(),
          itemBuilder: ( context, i ) => _SearchTile(
            place: state.places[i],
            close: close,
          ),
        );
      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final history = BlocProvider.of<SearchBloc>(context).state.history;

    return ListView.builder(
      itemCount: history.length,
      itemBuilder: ( context, i ) => _SearchTile(
        place: history[i],
        history: true,
        close: close,
      ),
    );
  }

}

class _SearchTile extends StatelessWidget {

  final Feature place;
  final bool history;
  final Function( BuildContext, SearchResult ) close;

  const _SearchTile ({
    Key? key,
    required this.place,
    this.history = false,
    required this.close, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon( history ? Icons.history : Icons.place_outlined, color: Colors.blue ),
      title: Text( place.text, ),
      subtitle: Text( place.placeName, ),
      onTap: () {
        BlocProvider.of<SearchBloc>(context).add( AddToHistoryEvent(place) );

        final searchResult = SearchResult(
          cancel: false,
          position: LatLng( place.center[1], place.center[0] ),
          name: place.text,
          description: place.placeName,
        );

        close( context, searchResult );
      },
    );
  }
}