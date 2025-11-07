import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tp_10/domain/entities/todo.dart';
import 'package:tp_10/presentation/cubit/todo_cubit.dart';
import 'package:tp_10/presentation/cubit/todo_state.dart';

/// Presents a single todo and quick actions on it.
class TodoDetailPage extends StatelessWidget {
  const TodoDetailPage({required this.todo, super.key});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la tâche'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/todo/${todo.id}/edit', extra: todo),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async => _confirmDeletion(context, todo),
          ),
        ],
      ),
      body: BlocListener<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state.status == TodoStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    todo.isCompleted
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    size: 32,
                    color: todo.isCompleted ? Colors.green : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      todo.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(todo.description),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(todo.isCompleted ? Icons.undo : Icons.check),
                  label: Text(
                    todo.isCompleted
                        ? 'Marquer comme à faire'
                        : 'Marquer comme terminée',
                  ),
                  onPressed: () async {
                    final router = GoRouter.of(context);
                    final cubit = context.read<TodoCubit>();
                    final updated = todo.copyWith(
                      isCompleted: !todo.isCompleted,
                    );
                    await cubit.saveTodo(updated);
                    router.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeletion(BuildContext context, Todo todo) async {
    final cubit = context.read<TodoCubit>();
    final router = GoRouter.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la tâche ?'),
          content: const Text('Cette action est irréversible.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && todo.id != null) {
      await cubit.deleteTodo(todo.id!);
      router.pop();
    }
  }
}
