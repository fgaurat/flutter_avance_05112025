import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_09/counter/bloc/counter_bloc.dart';
import 'package:tp_09/counter/cubit/counter_cubit.dart';
import 'view/home_tabs.dart';

class BlocVsCubitApp extends StatelessWidget {
  const BlocVsCubitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => CounterCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BLoC vs Cubit Demo',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const HomeTabs(),
      ),
    );
  }
}
