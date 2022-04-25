import 'dart:ui' as ui;

import 'package:flutter/material.dart' show ImageConfiguration;

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show BitmapDescriptor;

Future<BitmapDescriptor> getAssetImageMarker() async {
  return BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(
      devicePixelRatio: 2,
    ),
    'assets/imgs/custom-pin.png'
  );
}

Future<BitmapDescriptor> getNetworkImageMarker() async {
  final response = await Dio().get(
    'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-512.png',
    options: Options( responseType: ResponseType.bytes ),
  );

  // Resize de la imagen
  final imageCodec = await ui.instantiateImageCodec(
    response.data,
    targetWidth: 130,
    targetHeight: 130,
  );
  final frame = await imageCodec.getNextFrame();
  final data = await frame.image.toByteData( format: ui.ImageByteFormat.png );

  // Por si algo falla o la NetworkImage ya no existe
  if( data == null ) return await getAssetImageMarker();

  return BitmapDescriptor.fromBytes( data.buffer.asUint8List() );
}