import 'package:flutter/material.dart';
import 'package:tp_08/models/todo.dart';
import 'package:tp_08/services/todo_service.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, required this.todoService});

  final TodoService todoService;

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late Future<List<Todo>> _todosFuture;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _todosFuture = widget.todoService.getTodos();
  }

  Future<void> _reloadTodos() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
      _todosFuture = widget.todoService.getTodos();
    });

    try {
      await _todosFuture;
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ma Todo List')),
      body: FutureBuilder<List<Todo>>(
        future: _todosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Une erreur est survenue lors du chargement des tâches.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reloadTodos,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final todos = snapshot.data ?? const <Todo>[];
          if (todos.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reloadTodos,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: 120,
                  horizontal: 24,
                ),
                children: const [
                  Center(
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Aucune tâche pour le moment.\nAjoutez-en une pour commencer !',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reloadTodos,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: todos.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  onTap: () {},
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: todo.title?.isNotEmpty == true
                      ? Text(todo.title!)
                      : null,
                  trailing: Checkbox(
                    value: todo.completed,
                    onChanged: (value) {},
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
