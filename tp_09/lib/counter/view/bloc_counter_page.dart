import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_09/counter/bloc/counter_bloc.dart';

class BlocCounterPage extends StatelessWidget {
  const BlocCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocListener<CounterBloc, CounterState>(
        listener: (context, state) {
          if (state.value == 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Counter reached 10!')),
            );
          }
        },
        listenWhen: (previous, current) {
          return previous.value != current.value;
        },
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Bloc Counter Page'),

                if (state.loading) ...[
                  SizedBox(height: 16),
                  CircularProgressIndicator(),
                ],
                SizedBox(height: 16),
                Text('Counter Value: ${state.value}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Increment());
                  },
                  child: Text('Increment'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Decrement());
                  },
                  child: Text('Decrement'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Reset());
                  },
                  child: Text('Reset'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
