import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Future<List<Todo>>? _todoListFuture;

  @override
  void initState() {
    super.initState();
    _todoListFuture = TodoService().getTodos();
  }

  Future<void> _refresh() async {
    setState(() {
      _todoListFuture = TodoService().getTodos();
    });
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
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No todos available'));
            } else {
              final todos = snapshot.data!;
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.title),
                    leading: Icon(
                      todo.completed
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
