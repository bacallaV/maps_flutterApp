class SearchResult {

  final bool cancel;
  final bool manual;
  // final LatLng 

  SearchResult({
    required this.cancel,
    this.manual = false,
  });

  @override
  String toString() {
    return 'SearchResult{ cancel: $cancel, manual: $manual }';
  }
  
}