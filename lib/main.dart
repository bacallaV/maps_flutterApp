import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:c3_4_maps_app/blocs/blocs.dart';

import 'package:c3_4_maps_app/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GpsBloc>( create: (_) => GpsBloc(), ),
        BlocProvider<LocationBloc>( create: (_) => LocationBloc(), ),
        BlocProvider<MapBloc>( create: (blocContext) => MapBloc( locationBloc: BlocProvider.of<LocationBloc>(blocContext) ), ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maps App',
        home: LoadingScreen(),
      ),
    );
  }
}
