import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:smartstrap/src/ui/home_screen.dart';

import 'blocs/main_app_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainAppBloc>(
        creator: (_context, _bag) => MainAppBloc(),
        child: MaterialApp(
            title: 'SmartStrap',
            theme: ThemeData(
              fontFamily: 'Averta',
              primarySwatch: Colors.blue,
            ),
            home: HomeScreen()));
  }
}
