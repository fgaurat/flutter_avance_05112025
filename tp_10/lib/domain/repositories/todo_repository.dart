import 'package:tp_10/domain/entities/todo.dart';

/// Abstraction representing data access for todos.
abstract class TodoRepository {
  Future<List<Todo>> loadTodos();
  Future<Todo> loadTodo(int id);
  Future<Todo> createTodo(Todo todo);
  Future<Todo> updateTodo(Todo todo);
  Future<void> deleteTodo(int id);
}
