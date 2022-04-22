import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator, CupertinoAlertDialog, showCupertinoDialog;
import 'package:flutter/material.dart';

void showLoadingMessage( BuildContext context ) {

  if( Platform.isAndroid ){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ( context ) => AlertDialog(
        title: const Text( 'Espere por favor' ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text( 'Calculando ruta...' ),
            SizedBox( height: 15 ),
            CircularProgressIndicator( strokeWidth: 2, color: Colors.black87, ),
          ],
        ),
      )
    );
    return;
  } else {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: ( context ) => const CupertinoAlertDialog(
        title: Text( 'Espere por favor' ),
        content: CupertinoActivityIndicator()
      )
    );
    return;
  }
}