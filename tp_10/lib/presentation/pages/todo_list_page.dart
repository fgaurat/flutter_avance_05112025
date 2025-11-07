import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tp_10/presentation/cubit/todo_cubit.dart';
import 'package:tp_10/presentation/cubit/todo_state.dart';

/// Displays todos and provides navigation toward detail and creation flows.
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Todos')),
      body: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state.status == TodoStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.status == TodoStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.todos.isEmpty) {
            return const Center(child: Text('Aucune tâche pour le moment.'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<TodoCubit>().fetchTodos(),
            child: ListView.separated(
              itemCount: state.todos.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Icon(
                    todo.isCompleted
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: todo.isCompleted ? Colors.green : null,
                  ),
                  onTap: () {
                    context.push('/todo/${todo.id}', extra: todo);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/todo/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
