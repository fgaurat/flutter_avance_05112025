import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key, required this.service});

  final TodoService service; // injection pour faciliter le mocking en test

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Future<List<Todo>> _todoListFuture; // non-nullable

  @override
  void initState() {
    super.initState();
    _todoListFuture = widget.service.getTodos();
  }

  Future<void> _refresh() async {
    final fut = widget.service.getTodos();
    setState(() {
      _todoListFuture = fut;
    });
    try {
      await fut;
    } catch (_) {
      // on ignore l'erreur ici, elle sera gérée par le FutureBuilder
    }
  }

  // Garantit un child scrollable pour que le pull-to-refresh marche
  Widget _asScrollable(Widget child) {
    return ListView(
      key: const ValueKey('todo-scroll-wrapper'),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [SizedBox(height: 300, child: Center(child: child))],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TodoList')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Todo>>(
          future: _todoListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _asScrollable(const CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _asScrollable(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      key: const ValueKey('retry-button'),
                      onPressed: () {
                        final fut = widget.service.getTodos();
                        setState(() {
                          _todoListFuture = fut; // ← bloc ici aussi
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            final todos = snapshot.data ?? const <Todo>[];
            if (todos.isEmpty) {
              return _asScrollable(const Text('No todos available'));
            }

            return ListView.builder(
              key: const ValueKey('todo-list'),
              physics:
                  const AlwaysScrollableScrollPhysics(), // ← important pour le refresh avec peu d’items

              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  key: ValueKey('todo-$index'),

                  title: Text(todo.title),
                  leading: Icon(
                    todo.completed
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
