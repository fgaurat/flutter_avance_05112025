import 'package:flutter/material.dart';
import 'package:tp_09/counter/view/bloc_counter_page.dart';
import 'package:tp_09/counter/view/cubit_counter_page.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BLoC vs Cubit'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'BLoC'),
              Tab(text: 'Cubit'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [BlocCounterPage(), CubitCounterPage()],
        ),
      ),
    );
  }
}
