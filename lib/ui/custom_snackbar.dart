import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {

  CustomSnackBar({
    Key? key,
    required String message,
    String buttonLabel = 'Ok',
    Duration duration = const Duration( seconds: 2 ),
    VoidCallback? onOk,
  }) : super(
    key: key,
    content: Text( message ),
    duration: duration,
    action: SnackBarAction(
      label: buttonLabel,
      onPressed: onOk ?? (){},
    ),
    backgroundColor: Colors.purple.shade500,
    shape: const RoundedRectangleBorder(),
  );

}