import 'package:flutter_test/flutter_test.dart';
import 'package:tp_11/models/todo.dart';
import 'package:tp_11/services/todo_service.dart';
import 'package:http/http.dart' as http;

class FakeTodoService extends TodoService {
  FakeTodoService() : super(client: http.Client(), baseUrl: 'fake');

  List<Todo> _data = [Todo(id: 1, title: 'A', completed: false)];
  Object? _error;

  void setData(List<Todo> next) {
    _error = null;
    _data = next;
  }

  void setError(Object error) {
    _error = error;
  }

  @override
  Future<List<Todo>> getTodos() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 50),
    ); // simule réseau
    if (_error != null) throw _error!;
    return _data;
  }
}
