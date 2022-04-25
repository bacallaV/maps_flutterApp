import 'package:flutter/material.dart';

class EndMakerPainter extends CustomPainter {

  final int km;
  final String destination;

  EndMakerPainter({
    required this.km,
    required this.destination
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Circulos
    final blackPaint = Paint()
      ..color = Colors.black;
    final whitePaint = Paint()
      ..color = Colors.white;

    const double bcRadius = 20;
    const double wcRadius = 7;

    canvas.drawCircle( Offset( size.width * 0.5, size.height - bcRadius ), bcRadius, blackPaint );
    canvas.drawCircle( Offset( size.width * 0.5, size.height - bcRadius ), wcRadius, whitePaint );

    // Caja Blanca
    final path = Path();
    path.moveTo( 10, 20 );
    path.lineTo( size.width - 10, 20 );
    path.lineTo( size.width - 10, 100 );
    path.lineTo( 10, 100 );
    
    // Sombra
    canvas.drawShadow( path, Colors.black, 10, false );
    // Caja
    canvas.drawPath( path, whitePaint );

    // Caja negra
    const blackBox = Rect.fromLTWH( 10, 20, 70, 80 );
    canvas.drawRect( blackBox, blackPaint );

    /* Cajas de texto */
    // Kilometros
    final textSpan = TextSpan(
      style: const TextStyle( color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400 ),
      text: '$km',
    );

    final kmPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(
      minWidth: 70,
      maxWidth: 70,
    );

    kmPainter.paint( canvas, const Offset(10, 35) );

    const kmText = TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300 ),
      text: 'Km',
    );

    final kmMinPainter = TextPainter(
      text: kmText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(
      minWidth: 70,
      maxWidth: 70,
    );

    kmMinPainter.paint( canvas, const Offset(10, 68) );

    // Descripcion
    final locationText = TextSpan(
      style: const TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300 ),
      text: destination,
    );

    final locationPainter = TextPainter(
      text: locationText,
      maxLines: 2,
      ellipsis: '...',
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(
      minWidth: size.width - 95,
      maxWidth: size.width - 95,
    );

    final double offsetY = ( destination.length > 25 ) ? 35 : 48;

    locationPainter.paint( canvas, Offset( 90, offsetY ) );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics( covariant CustomPainter oldDelegate ) => false;

}