import 'package:flutter/material.dart';

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
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon( Icons.location_on_outlined, color: Colors.black ),
          title: const Text( 'Colocar ubicación manualmente' ),
          onTap: () => close(
            context,
            SearchResult( cancel: false, manual: true )
          ),
        ),
      ],
    );
  }

}