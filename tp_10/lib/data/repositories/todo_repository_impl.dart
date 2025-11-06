import 'package:tp_10/data/models/todo_model.dart';
import 'package:tp_10/domain/entities/todo.dart';
import 'package:tp_10/domain/repositories/todo_repository.dart';

/// Concrete implementation of [TodoRepository] backed by [TodoService].
class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._service);

  final TodoService _service;

  @override
  Future<List<Todo>> loadTodos() async {
    final results = await _service.fetchTodos();
    return List<Todo>.unmodifiable(results);
  }

  @override
  Future<Todo> loadTodo(int id) => _service.fetchTodo(id);

  @override
  Future<Todo> createTodo(Todo todo) {
    final payload = _toModel(todo);
    return _service.createTodo(payload);
  }

  @override
  Future<Todo> updateTodo(Todo todo) {
    final todoId = todo.id;
    if (todoId == null) {
      throw ArgumentError('Cannot update a todo without an id.');
    }
    final payload = _toModel(todo);
    return _service.updateTodo(todoId, payload);
  }

  @override
  Future<void> deleteTodo(int id) => _service.deleteTodo(id);

  TodoModel _toModel(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
    );
  }
}
