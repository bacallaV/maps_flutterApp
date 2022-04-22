import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

class ManualMarker extends StatelessWidget {

  final VoidCallback? backOnPressed;
  final VoidCallback? confirmOnPressed;

  const ManualMarker ({
    Key? key,
    this.backOnPressed,
    this.confirmOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Stack(
        children: <Widget>[

          Positioned(
            top: 70,
            child: _ButtonBack(
              onPressed: backOnPressed ?? (){},
            ),
          ),

          Center(
            child: Transform.translate(
              offset: const Offset( 0, -25 ),
              child: BounceInDown(
                from: 100,
                child: const Icon( Icons.location_on_rounded, size: 50 )
              ),
            ),
          ),

          Positioned(
            bottom: 70,
            left: 40,
            child: ButtonConfirmarDestino(
              onPressed: confirmOnPressed ?? (){},
            ),
          ),

        ],
      )
    );
  }
}

class ButtonConfirmarDestino extends StatelessWidget {

  final VoidCallback onPressed;

  const ButtonConfirmarDestino({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return FadeInUp(
      duration: const Duration( milliseconds: 300 ),
      child: MaterialButton(
        minWidth: screenSize.width - 120,
        color: Colors.black,
        elevation: 0,
        height: 50,
        shape: const StadiumBorder(),
        child: const Text(
          'Confirmar destino',
          style: TextStyle( color: Colors.white, fontWeight: FontWeight.w300 ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _ButtonBack extends StatelessWidget {

  final VoidCallback onPressed;

  const _ButtonBack({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration( milliseconds: 300 ),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon( Icons.arrow_back_ios_new, color: Colors.black ),
          onPressed: onPressed,
        )
      ),
    );
  }
}