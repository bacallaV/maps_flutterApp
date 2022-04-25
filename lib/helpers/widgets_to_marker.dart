import 'dart:ui' as ui;

import 'package:flutter/material.dart' show CustomPainter;

import 'package:google_maps_flutter/google_maps_flutter.dart' show BitmapDescriptor;

import 'package:c3_4_maps_app/markers/markers.dart';

Future<BitmapDescriptor> getStartCustomMarker( int duration, String destination ) async => await _getMarker(
  StartMakerPainter( minutes: duration, destination: destination )
);

Future<BitmapDescriptor> getEndCustomMarker( int km, String destination ) async => await _getMarker(
  EndMakerPainter( km: km, destination: destination )
);

Future<BitmapDescriptor> _getMarker( CustomPainter customPaint ) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas( recorder );
  const size = ui.Size( 350, 150 );

  customPaint.paint( canvas, size );

  final picture = recorder.endRecording();

  final image = await picture.toImage( size.width.toInt(), size.height.toInt() );
  final byteData = await image.toByteData( format: ui.ImageByteFormat.png );

  return BitmapDescriptor.fromBytes( byteData!.buffer.asUint8List() );
}