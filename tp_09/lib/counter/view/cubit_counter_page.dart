import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_09/counter/cubit/counter_cubit.dart';

class CubitCounterPage extends StatelessWidget {
  const CubitCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocListener<CounterCubit, int>(
        listener: (context, value) {
          if (value == 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Counter reached 10!')),
            );
          }
        },
        listenWhen: (previous, current) {
          return previous != current;
        },
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Cubit Counter Page'),
                SizedBox(height: 16),
                Text('Counter Value: $value'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterCubit>().increment();
                  },
                  child: Text('Increment'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterCubit>().decrement();
                  },
                  child: Text('Decrement'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterCubit>().reset();
                  },
                  child: Text('Reset'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterCubit>().resetAsync();
                  },
                  child: Text('ResetAsync'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
